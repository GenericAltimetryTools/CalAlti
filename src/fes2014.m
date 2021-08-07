% reading tide constituents of NetCDF format by matlab.

%% 
function [series1]=fes2014(lat_t,lon_t,time_in)

disp('===========================FES 2014 computing===========================')
namelist = ls ('..\fes2014\FES2014\*.nc');% 这里ls可以和dir替换

% BL=textread('..\fes2014\LAT_LON\lat_lon.txt');%%读取数据文件纬度、经度
M=0.0625;
H=0;
G=0;

for n=1:length(namelist)
    filepath=strcat('..\fes2014\FES2014\',namelist(n,1:7));
    lon=ncread(filepath,'lon');
    lat=ncread(filepath,'lat');
    amp_read=ncread(filepath,'amplitude');%%%%%%单位是cm
    pha_read=ncread(filepath,'phase');%%%%单位是度，范围-180到180    
    HC=amp_read';%%%%单位是cm
    HS=pha_read';
%%%%%%%%%%%%%%%%%%%%%
    for i=1:length(lat_t)      
        x=floor((90+lat_t(i))/M)+1;%%确定该点左上网格点在矩阵中的列数
        y=floor(lon_t(i)/M)+1;%%确定该点左上网格点在矩阵中的行数
        
        lat_read=lat(x,1);%%左上网格点的纬度
        lon_read=lon(y,1);%%左上网格点的经度
        
        HC1=[HC(x,y),HC(x,y+1);HC(x+1,y),HC(x+1,y+1)];%%%周围2*2=4个点H
        HS1=[HS(x,y),HS(x,y+1);HS(x+1,y),HS(x+1,y+1)];%%%%%G 


        lat1=lat_read:M:lat_read+M;
        lon1=lon_read:M:lon_read+M;

        id=find(isnan(HC1));%%%%%确认周围点无效点的个数
        if (sum(id)==0)%%%%%%%%说明周围四个点全是有效值            
            HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
            GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');            
        elseif (sum(id)>0&&sum(id)<10)%%%%%四个点中存在有效值
            aver1=nanmean(nanmean(HC1));
            aver2=nanmean(nanmean(HS1));
            HC1(id)=aver1;
            HS1(id)=aver2;
            HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
            GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');

        elseif(sum(id)==10)%%%%%%四个点全为无效点，然后扩大范围至周围4*4=16个点
            HC1=[HC(x-1,y-1),HC(x-1,y),HC(x-1,y+1),HC(x-1,y+2);...
                HC(x,y-1),HC(x,y),HC(x,y+1),HC(x,y+2);...
                HC(x+1,y-1),HC(x+1,y),HC(x+1,y+1),HC(x+1,y+2);...
                HC(x+2,y-1),HC(x+2,y),HC(x+2,y+1),HC(x+2,y+2)];%%16个网格点的H
            HS1=[HS(x-1,y-1),HS(x-1,y),HS(x-1,y+1),HS(x-1,y+2);...
                HS(x,y-1),HS(x,y),HS(x,y+1),HS(x,y+2);...
                HS(x+1,y-1),HS(x+1,y),HS(x+1,y+1),HS(x+1,y+2);...
                HS(x+2,y-1),HS(x+2,y),HS(x+2,y+1),HS(x+2,y+2)];%%16个网格点的G
            lat1=lat_read-M:M:lat_read+2*M;
            lon1=lon_read-M:M:lon_read+2*M;

            id=find(isnan(HC1));
            if(sum(id)~=136)%%%%%%%16个点中存在有效值126=sum(1:16)
                aver1=nanmean(nanmean(HC1));
                aver2=nanmean(nanmean(HS1));
                HC1(id)=aver1;
                HS1(id)=aver2;    
                HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
                GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');
 
            else%%%%%%%%%%其余情况表示无有效点，扩大范围至周围6*6=36个点
                HC1=[HC(x-2,y-2),HC(x-2,y-1),HC(x-2,y),HC(x-2,y+1),HC(x-2,y+2),HC(x-2,y+3);...
                    HC(x-1,y-2),HC(x-1,y-1),HC(x-1,y),HC(x-1,y+1),HC(x-1,y+2),HC(x-1,y+3);...
                    HC(x,y-2),HC(x,y-1),HC(x,y),HC(x,y+1),HC(x,y+2),HC(x,y+3);...
                    HC(x+1,y-2),HC(x+1,y-1),HC(x+1,y),HC(x+1,y+1),HC(x+1,y+2),HC(x+1,y+3);...
                    HC(x+2,y-2),HC(x+2,y-1),HC(x+2,y),HC(x+2,y+1),HC(x+2,y+2),HC(x+2,y+3);...
                    HC(x+3,y-2),HC(x+3,y-1),HC(x+3,y),HC(x+3,y+1),HC(x+3,y+2),HC(x+3,y+3)];%%%%%%周边36个点
                HS1=[HS(x-2,y-2),HS(x-2,y-1),HS(x-2,y),HS(x-2,y+1),HS(x-2,y+2),HS(x-2,y+3);...
                    HS(x-1,y-2),HS(x-1,y-1),HS(x-1,y),HS(x-1,y+1),HS(x-1,y+2),HS(x-1,y+3);...
                    HS(x,y-2),HS(x,y-1),HS(x,y),HS(x,y+1),HS(x,y+2),HS(x,y+3);...
                    HS(x+1,y-2),HS(x+1,y-1),HS(x+1,y),HS(x+1,y+1),HS(x+1,y+2),HS(x+1,y+3);...
                    HS(x+2,y-2),HS(x+2,y-1),HS(x+2,y),HS(x+2,y+1),HS(x+2,y+2),HS(x+2,y+3);...
                    HS(x+3,y-2),HS(x+3,y-1),HS(x+3,y),HS(x+3,y+1),HS(x+3,y+2),HS(x+3,y+3)];%%%%%%周边36个点
                lat1=lat_read-2*M:M:lat_read+3*M;
                lon1=lon_read-2*M:M:lon_read+3*M;
                id=find(isnan(HC1));
                if (sum(id)~=666)%%%%%%36个点中存在有效点，666=sum(1:36)
                    HC1(id)=nanmean(nanmean(HC1));
                    HS1(id)=nanmean(nanmean(HS1));   
                    HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
                    GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');
                else%%%%%%%%36个点无有效点，扩大范围8*8=64
                    HC1=[HC(x-3,y-3),HC(x-3,y-2),HC(x-3,y-1),HC(x-3,y),HC(x-3,y+1),HC(x-3,y+2),HC(x-3,y+3),HC(x-3,y+4);...
                       HC(x-2,y-3),HC(x-2,y-2),HC(x-2,y-1),HC(x-2,y),HC(x-2,y+1),HC(x-2,y+2),HC(x-2,y+3),HC(x-2,y+4);...
                       HC(x-1,y-3),HC(x-1,y-2),HC(x-1,y-1),HC(x-1,y),HC(x-1,y+1),HC(x-1,y+2),HC(x-1,y+3),HC(x-1,y+4);...
                       HC(x,y-3),HC(x,y-2),HC(x,y-1),HC(x,y),HC(x,y+1),HC(x,y+2),HC(x,y+3),HC(x,y+4);...
                       HC(x+1,y-3),HC(x+1,y-2),HC(x+1,y-1),HC(x+1,y),HC(x+1,y+1),HC(x+1,y+2),HC(x+1,y+3),HC(x+1,y+4);...
                       HC(x+2,y-3),HC(x+2,y-2),HC(x+2,y-1),HC(x+2,y),HC(x+2,y+1),HC(x+2,y+2),HC(x+2,y+3),HC(x+2,y+4);...
                       HC(x+3,y-3),HC(x+3,y-2),HC(x+3,y-1),HC(x+3,y),HC(x+3,y+1),HC(x+3,y+2),HC(x+3,y+3),HC(x+3,y+4);...
                       HC(x+4,y-3),HC(x+4,y-2),HC(x+4,y-1),HC(x+4,y),HC(x+4,y+1),HC(x+4,y+2),HC(x+4,y+3),HC(x+4,y+4)];%%%%%%周边64个点
                    HS1=[HS(x-3,y-3),HS(x-3,y-2),HS(x-3,y-1),HS(x-3,y),HS(x-3,y+1),HS(x-3,y+2),HS(x-3,y+3),HS(x-3,y+4);...
                       HS(x-2,y-3),HS(x-2,y-2),HS(x-2,y-1),HS(x-2,y),HS(x-2,y+1),HS(x-2,y+2),HS(x-2,y+3),HS(x-2,y+4);...
                       HS(x-1,y-3),HS(x-1,y-2),HS(x-1,y-1),HS(x-1,y),HS(x-1,y+1),HS(x-1,y+2),HS(x-1,y+3),HS(x-1,y+4);...
                       HS(x,y-3),HS(x,y-2),HS(x,y-1),HS(x,y),HC(x,y+1),HS(x,y+2),HS(x,y+3),HS(x,y+4);...
                       HS(x+1,y-3),HS(x+1,y-2),HS(x+1,y-1),HC(x+1,y),HS(x+1,y+1),HS(x+1,y+2),HS(x+1,y+3),HS(x+1,y+4);...
                       HS(x+2,y-3),HS(x+2,y-2),HS(x+2,y-1),HC(x+2,y),HS(x+2,y+1),HS(x+2,y+2),HS(x+2,y+3),HS(x+2,y+4);...
                       HS(x+3,y-3),HS(x+3,y-2),HS(x+3,y-1),HC(x+3,y),HS(x+3,y+1),HS(x+3,y+2),HS(x+3,y+3),HS(x+3,y+4);...
                       HS(x+4,y-3),HS(x+4,y-2),HS(x+4,y-1),HC(x+4,y),HS(x+4,y+1),HS(x+4,y+2),HS(x+4,y+3),HS(x+4,y+4)];%%%%%%周边64个点
                    lat1=lat_read-3*M:M:lat_read+4*M;
                    lon1=lon_read-3*M:M:lon_read+4*M;
                    id=find(isnan(HC1));
                    if (sum(id)~=2080)
                        HC1(id)=nanmean(nanmean(HC1));
                        HS1(id)=nanmean(nanmean(HS1));   
                        HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
                        GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');
                    else
                        HH=str2num('NaN');
                        GG=str2num('NaN');
                    end                
                end
            end      
        end    

        if(GG>360)
            GG=GG-360;
        elseif(GG<0)
            GG=GG+360;
        end
        HG1(i,n*2-1)=HH;
        HG1(i,n*2)=GG;
    end
 
end


%%
% Tide simulation by FES2014
[nameu,fu]=textread('..\fes2014\fu.txt','%s%f'); % This is the frequency of tidal consstituents.For Ex of S2: 1/0.0805=12.42h
nameu=char(nameu);
tidecon(29,4)=0;

for i=1:length(lat_t) % BLis lat lon   
    for j=1:29
        tidecon(j,1)=HG1(i,j*2-1);
        tidecon(j,3)=HG1(i,j*2);
    end
    % Edit the time and computer the tide by calling t_predic.
        tim1=time_in; % input time
        cd ../fes2014
        series1(i,:)=t_predic(tim1(i),nameu,fu,tidecon);
        cd ../src
end


return
