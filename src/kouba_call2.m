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
coastline=load('..\test\gnssinfo\sites_all_in_tgrs'); % GNSS coordinate
len_coastline=length(coastline); % the number of GNSS site
step=1;
% len_coastline=2;

% DO coordinates loop
for c=1:len_coastline
    lat_gps=coastline(c,2);%
    lon_gps=coastline(c,1);%  
    X = ['Location : ',num2str(lat_gps),', ' num2str(lon_gps),' N=',num2str(c)];
    disp(X)
    
    % The area are splited to three parts: north,middle and south.
    index_=1;
    if lat_gps>=34
        area='north';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % ERA5 pressure level data
        namelist = ls(fullfile(dir_nm,'*.nc'));% list all the files.
        temp=size(namelist);
        file_num=temp(1);

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);% use the kouba3 funtion.
            % Filter data
            temp=std(kouba_p);

            if temp<500
                kouba_p_day(c,index_)=mean(kouba_p);% This is the mean value for each day.
                kouba_day(c,index_)=nm;% `c` means the sites number 
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

%% select 

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

% 
% load file and smooth data
figure ('Name','Seasonal kouba coefficient','NumberTitle','off') % the pressure level height and the time relation in one day.

for c=1:len_coastline
    file_in=strcat('../temp/kouba_site_',num2str(c),'.txt');
    file_out=strcat('../temp/kouba_site_',num2str(c),'_smooth.txt');
    kouba_coast=load(file_in);
    kouba_coast_month = smooth(kouba_coast(:,1),kouba_coast(:,2),30,'moving');
    plot(kouba_coast(:,1),kouba_coast_month);hold on
    out=[kouba_coast(:,1) kouba_coast_month] ;
    save(file_out,'out','-ASCII') % 保存结果数据   
    % Get seasonal data.
%     k=1;
%     if kouba_coast(:,1)>d1 && kouba_coast(:,1)<d1+366
%         kouba_coast_month
%     end
%     for s=d1:d1+366
%         k=k+1;
%     end
%     
end

%% Get seasonal signals. 
% Five years mean.2010-2014

d1=datenum('2010-1-1 00:00:00')-datenum('2009-10-1 00:00:00');
d2=datenum('2015-3-31 00:00:00')-datenum('2015-1-1 00:00:00');
d3=datenum('2015-3-31 00:00:00')-datenum('2009-10-1 00:00:00')+1;
d4=linspace(1,d3,d3);
d5=datenum('2015-1-1 00:00:00')-datenum('2010-1-1 00:00:00'); % Total days

% days
d10=datenum('2010-12-31 00:00:00')-datenum('2010-1-1 00:00:00')+1;
d11=datenum('2011-12-31 00:00:00')-datenum('2010-1-1 00:00:00')+1;
d12=datenum('2012-12-31 00:00:00')-datenum('2010-1-1 00:00:00')+1;
d13=datenum('2013-12-31 00:00:00')-datenum('2010-1-1 00:00:00')+1;
d14=datenum('2014-12-31 00:00:00')-datenum('2010-1-1 00:00:00')+1;

for c=1:len_coastline
    file_in=strcat('../temp/kouba_site_',num2str(c),'_smooth.txt');
    file_out=strcat('../temp/kouba_site_',num2str(c),'_season.txt');
    kouba_smooth=load(file_in);
    % Get seasonal data.
    year_one=kouba_smooth(:,2);
    d=kouba_smooth(:,1);

    kouba_inter=interp1(d',year_one',d4,'pchip');
    kouba_inter_clear=kouba_inter(d1:d3-d2);% 2010-1-1-2015-1-1
    

%     
    kouba_2010=kouba_inter_clear(1:d10);
    kouba_2011=kouba_inter_clear(d10+1:d11);
    kouba_2012=kouba_inter_clear(d11+1:d12-1);% 366 days. I use 365 days here for computing right. Later will add the day 366 the same as 365
    kouba_2013=kouba_inter_clear(d12+1:d13);
    kouba_2014=kouba_inter_clear(d13+1:d14);

    kouba_365=(kouba_2010+kouba_2011+kouba_2012+kouba_2013+kouba_2014)/5;
    kouba_365(366)=0.5*(kouba_365(365)+kouba_365(1));
    
    out=[kouba_365'] ;
    save(file_out,'out','-ASCII') % 保存结果数据   
    
    plot(kouba_365);hold on
end

%  plot(kouba_inter_clear);hold on

    