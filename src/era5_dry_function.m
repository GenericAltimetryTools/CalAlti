% read ERA5 mean sea level pressure

% *************************************************************************
% -Input: pca time, GNSS sites location, ERA5 nc files contain pressure at mean sea level
% -Output: pressure at the pca time at the GNSS sites.

% Author:leiyang@fio.org.cn
% 2021-01-25
% *************************************************************************

function [pressure_era5]=era5_dry_function(tim_pca,lon_gps,lat_gps)

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
    % select the dir based on the lat_gps
    if lat_gps > 34
        dir_era='..\data\era5\north\';
    elseif (lat_gps > 23) && (lat_gps < 34)
        dir_era='..\data\era5\middle\';
    elseif lat_gps < 23
        dir_era='..\data\era5\south\';
    end

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


    %% make new nc file
    % The `h` (hour) from the pca time determine the time here. 
    if h < 23
        layer1=h+1; % ERA5 begain with 00:00, end at 23:00. So first 1 level is at 0 hour.
        layer2=h+2;
    elseif h==23
        layer1=h; % ERA5 begain with 00:00, end at 23:00. So first 1 level is at 0 hour.
        layer2=h+1; % For PCA time between 23-24, use the 22 and 23 hour.
    end
    ny=length(lon);
    nx=length(lat);
    
    if exist('mslp_one.nc','file')==1
        delete ('mslp_one.nc');
    elseif exist('mslp_two.nc','file')==1
        delete ('mslp_two.nc');
    end

    writegrid(lon,lat,mslp(:,:,layer1),'mslp_one.nc',ny,nx)
    writegrid(lon,lat,mslp(:,:,layer2),'mslp_two.nc',ny,nx)
    %% Use grdtrack to interp the pressure at GNSS location
    input=[lon_gps,lat_gps];
%     gmt('grdtrack  -R -J  -Z50 -Wthinnest,red -O -K -t70 >> ../temp/test.ps ', slope); 
    p1=gmt('grdtrack  -Gmslp_one.nc ',input);
    p2=gmt('grdtrack  -Gmslp_two.nc ',input);
    if h<23
        pressure_era5=p1.data(3)+(min/60)*(p2.data(3)-p1.data(3));%Pressure at the MSL at GNSS site. Unit pa
    elseif h==23
        pressure_era5=p2.data(3)+(min/60)*(p2.data(3)-p1.data(3));%Pressure at the MSL at GNSS site. Unit pa
    end
    %% plot 2D with GMT
%     oldpath = path;
%     path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
% 
%     gmt ('set MAP_ANNOT_OBLIQUE=45 FONT_TITLE=10p')
%     gmt ('grd2cpt mslp_one.nc -Crainbow > mydata.cpt')
%     gmt ('grdimage -Rmslp_one.nc  -JM10c mslp_one.nc  -K > ../temp/mslp.ps')
%     gmt ('pscoast -Rmslp_one.nc -JM10c -Dl -A10000/0/1 -Bxag -Byag  -O -K -W0.01p  >> ../temp/mslp.ps')
%     gmt ('psscale -DjBC+o0c/-1.4c+w2.4i/0.08i -Rmslp_one.nc -JM10c -Cmydata.cpt -Bxaf -By+lunit -I -O  --FONT_ANNOT_PRIMARY=7p -K >> ../temp/mslp.ps ')
%     % gmt ('psxy -R -J -Sc0.02 -Gred -O -K >> ../temp/igs.ps',out)
%     delete('mydata.cpt')
%%
%     movefile('mslp_one.nc', '..\temp\mslp_one.nc'); 
    delete ('mslp_one.nc'); delete ('mslp_two.nc');

    %%

return