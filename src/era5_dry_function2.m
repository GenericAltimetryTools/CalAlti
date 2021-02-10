% read ERA5 mean sea level pressure

% *************************************************************************
% -Input: pca time, GNSS sites location, ERA5 nc files contain pressure at mean sea level
% -Output: pressure at the pca time at the GNSS sites.

% Author:leiyang@fio.org.cn
% 2021-01-25
% *************************************************************************

function [pressure_era5]=era5_dry_function2(tim_pca,k1,k2,dir_era)

    %% First, transform the time to YYYYMMDD
    formatOut = 'yyyy/mm/dd HH:MM:SS';
    t=datestr(tim_pca/86400+datenum('2000-1-1 00:00:00'),formatOut);
    disp(t)
    year=t(1:4);
    m=t(6:7);
    d=t(9:10);
    h=t(12:13);h=str2double(h);
    min=t(15:16);min=str2double(min);    
    % Name Example: era5.mslp.20100101.nc
    filename_era= strcat('era5.mslp.',year,m,d,'.nc'); % Full name
    %% Second, load the era5 Netcdf file according to time 
%     % select the dir based on the lat_gps
%     if lat_gps > 34
%         dir_era='..\data\era5\north\';
%     elseif (lat_gps > 23) && (lat_gps < 34)
%         dir_era='..\data\era5\middle\';
%     elseif lat_gps < 23
%         dir_era='..\data\era5\south\';
%     end

    filepath_era= strcat(dir_era,filename_era); % Full path
    % Load nc file from dir

    %%
    % Read nc file
%     ncdisp(filepath_era) % Show nc infomation.
    lat=ncread(filepath_era,'latitude'); % 1d
    lon=ncread(filepath_era,'longitude'); % 1d
%     time_era=ncread(filepath_era,'time'); % 1d, hours since 1900-01-01 00:00:00.0
    mslp=ncread(filepath_era,'msl'); % 3d, Pa
%     time_hour=mod(time_era,24); % the hour of the day.


    %%
% 
%         k1=0;
%         for i=1:length(lat)
%             if lat(i)>=lat_gps && lat(i+1)<lat_gps
%                 k1=i;
%                 break
%             end
%         end
% 
%         k2=0;
%         for i=1:length(lon)
%             if lon(i)<=lon_gps && lon(i+1)>lon_gps
%                 k2=i;
%                 break
%             end
%         end
        
    if h<23 % h change from 0 to 23
        pressure_era5=mslp(k2,k1,h+1)+(min/60)*(mslp(k2,k1,h+2)-mslp(k2,k1,h+1));%Pressure at the MSL at GNSS site. Unit pa
    elseif h==23
        pressure_era5=mslp(k2,k1,h+1)+(min/60)*(mslp(k2,k1,h+1)-mslp(k2,k1,h));%Pressure at the MSL at GNSS site. Unit pa
    end
%                hum_gnss=hum(k2,k1,1:i,ii+1);% the 00:00 h
%             air_gnss=air_t(k2,k1,1:i,ii+1);
        
return