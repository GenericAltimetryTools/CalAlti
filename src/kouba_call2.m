% Three subfuntions are provided
% -kouba, least square fit
% -kouba2, using the single level as the surface wet PD of earth.
% -kouba3, only use the pressure level data.
% I suggest the kouba3 and kouba funtion.

% -Input: EAR5 pressure level data
%       : latitude,longitude from files
% -Output: Mean Kouba parameter over a time span at each GNSS site
%        : Time series of Kouba for each GNSS sites.

% This function will loop the coordinate of coastline resampled of 300km.
% Just run one years data to speed up.

%%

clear;
clc;

format long

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

% coastline=load('..\data\era5\coastline\coastal.d3');
coastline=load('..\test\gnssinfo\sites_all_in_tgrs');
len_coastline=length(coastline);
step=1;
% len_coastline=2;

% DO coordinates loop
for c=1:len_coastline
    lat_gps=coastline(c,2);%
    lon_gps=coastline(c,1);%  
    X = ['Location : ',num2str(lat_gps),', ' num2str(lon_gps),' N=',num2str(c)];
    disp(X)
    
    index_=1;
    if lat_gps>=34
        area='north';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
        namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
        temp=size(namelist);
        file_num=temp(1);

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
            % Filter data
            temp=std(kouba_p);

            if temp<500
                kouba_p_day(c,index_)=mean(kouba_p);
                kouba_day(c,index_)=nm;
            else
                kouba_p_day(c,index_)=-9999;
                kouba_day(c,index_)=nm;
            end  
            kouba_p_day_std(c,index_)=temp;
            index_=index_+1;
            
            X = ['Number: ',num2str(c),' file at: ',filepath];
            disp(X)
            
        end

    elseif lat_gps>23 && lat_gps<=33
        area='middle';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
        namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
        temp=size(namelist);
        file_num=temp(1);        

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
            % Filter data
            temp=std(kouba_p);

             if temp<500
                kouba_p_day(c,index_)=mean(kouba_p);
                kouba_day(c,index_)=nm;
            else
                kouba_p_day(c,index_)=-9999;
                kouba_day(c,index_)=nm;
            end  
            kouba_p_day_std(c,index_)=temp;
            index_=index_+1;
            
            X = ['Number: ',num2str(c),' file at: ',filepath];
            disp(X)
        end


    elseif lat_gps>=15.5 && lat_gps<=23
        area='south';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
        namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
        temp=size(namelist);
        file_num=temp(1);

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
            % Filter data
            temp=std(kouba_p);

             if temp<500
                kouba_p_day(c,index_)=mean(kouba_p);
                kouba_day(c,index_)=nm;
            else
                kouba_p_day(c,index_)=-9999;
                kouba_day(c,index_)=nm;
            end  
            kouba_p_day_std(c,index_)=temp;
            index_=index_+1;
            
            X = ['Number: ',num2str(c),' file at: ',filepath];
            disp(X)
        end
        
    else
        disp('out side of the research extent');
    end
    
end

% plot(kouba_p_day(1,:))

% select 
kouba_p_day2=[];
kouba_p_day_std2=[];
fid4=fopen('../temp/kouba_coast.txt','w');

for c=1:len_coastline
%     c
    k=1;
    lat_gps=coastline(c,2);%
    lon_gps=coastline(c,1);%  
    outfile=strcat('../temp/kouba_site_',num2str(c),'.txt');
    fid1=fopen(outfile,'w');
    
    for nm=1:length(kouba_p_day)
        if kouba_p_day(c,nm)>100 && kouba_p_day(c,nm)<5000
            kouba_p_day2(k)=kouba_p_day(c,nm);
%             kouba_p_day_std2(c,k)=kouba_p_day_std(c,nm);
            days=kouba_day(c,nm);
            fprintf(fid1,'%12d  %12.6f \n',days,kouba_p_day2(k));
            k=k+1;
        end
    end
    fclose(fid1);
    
   kouba_m=mean(kouba_p_day2);
%        
   fprintf(fid4,'%12.6f %12.6f %12.6f \n',lon_gps,lat_gps,kouba_m);
%    out(c)=[lon_gps lat_gps kouba_m];
end
fclose('all');

% load ../temp/kouba_coast.txt
% plot(kouba_coast(:,3))
% 
% load ../temp/kouba_site_2.txt
% plot(kouba_site_2(:,1),kouba_site_2(:,2))
