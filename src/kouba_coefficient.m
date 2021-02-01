% calculate the 2000 coefficient.

clear;
clc;
format long

%% content.

% % The file contains:
% %    0    0 'longitude'  
% %    1    1 'latitude'  
% %    2    2    'level'  (pressure_level) the 37th level is the bottom. 
% %    3    3     'time'  (hours since 1900-01-01 00:00:00.0)
% %    4    0        'z'  (Geopotential)
% %    5    0        'q'  (specific_humidity)
% %    6    0        't'  (air_temperature)

%%
% define the location
lat_gps=1.8235778e+01;% GNSS的坐标
lon_gps=1.0953055e+02;% 
%%
filepath='..\data\era5\4d\hisy.nc';
% ncdisp(filepath) % Show nc infomation.
lat=ncread(filepath,'latitude'); % 1d
lon=ncread(filepath,'longitude'); % 1d
time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
geo=ncread(filepath,'z'); % 4D:lon,lat,level,time
hum=ncread(filepath,'q'); % 
air_t=ncread(filepath,'t'); % 
level=ncread(filepath,'level'); % pressure level
geo_h=geo/9.80665; % transform the geopotential to height.

%% plot line to check the relation of pressure levels and the height
figure('Name','pressure level and height','NumberTitle','off');
 % the pressure level and height
tmp=geo_h(1,1,1:37,1);
tmp=reshape(tmp,1,37);
plot(1:37,tmp);

figure ('Name','level 37 height and the time in one day','NumberTitle','off') % the pressure level height and the time relation in one day.
tmp=geo_h(1,1,37,1:24);
tmp=reshape(tmp,1,24);
plot(1:24,tmp);

figure ('Name','level 37 humidity and the latitude','NumberTitle','off') %
tmp=hum(1,1:5,37,1);
tmp=reshape(tmp,1,5);
plot(lat,tmp);


%% make new nc file

ny=length(lon);
nx=length(lat);
writegrid(lon,lat,hum(:,:,37,1),'mslp_one.nc',ny,nx)

%% plot 2D with GMT
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

gmt ('set MAP_ANNOT_OBLIQUE=45 FONT_TITLE=10p')
gmt ('grd2cpt mslp_one.nc -Crainbow > mydata.cpt')
gmt ('grdimage -Rmslp_one.nc  -JR10c mslp_one.nc  -K > ../temp/pl_era5.ps')
gmt ('pscoast -Rmslp_one.nc -JR10c -Df -A10000/0/1 -Bxa120g -Byag  -O -K -W0.01p  >> ../temp/pl_era5.ps')
gmt ('psxy -R -J -Sc0.2 -Gred -O -K >> ../temp/pl_era5.ps',[lon_gps,lat_gps])
gmt ('psscale -DjBC+o0c/-1.4c+w2.4i/0.08i -Rmslp_one.nc -JR10c -Cmydata.cpt -Bxaf -By+lunit -I -O  --FONT_ANNOT_PRIMARY=7p -K >> ../temp/pl_era5.ps ')
movefile('mslp_one.nc', '..\temp\mslp_one.nc'); 
delete('mydata.cpt')

%%
% calculte the WPD for each pressure level (geopotential height)

% time
% time  = double(time);
% formatout = 'mm dd, yyyy HH:MM:SS.FFF';%转换格式
% dstr = datestr((datenum('1900-01-01') + time./24),formatout);
% TM = datevec(dstr);%将时间字符数组转化为数值数组
% WPD integration over 37 levels

% interpolation of value to GNSS sites
k1=0;
for i=1:length(lat)
    if lat(i)>lat_gps && lat(i+1)<lat_gps
        k1=i;
        break
    end
end

k2=0;
for i=1:length(lon)
    if lon(i)<lon_gps && lon(i+1)>lon_gps
        k2=i;
        break
    end
end

hum_gnss=hum(k2,k1,:,1);% the 00:00 h
air_gnss=air_t(k2,k1,:,1);
hum_gnss=reshape(hum_gnss,37,1);
air_gnss=reshape(air_gnss,37,1);
plot(level,hum_gnss)
wet_pd=(1.116454*1e-3*trapz(double(level),hum_gnss)+17.66543828*trapz(double(level),hum_gnss./air_gnss))*(1+0.0026*cosd(2*lat_gps));

%% comparison with the 

filepath='..\data\era5\4d\hisy_msl.nc';
% ncdisp(filepath) % Show nc infomation.
lat=ncread(filepath,'latitude'); % 1d
lon=ncread(filepath,'longitude'); % 1d
time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
t2m=ncread(filepath,'t2m'); % 
tcwv=ncread(filepath,'tcwv'); % 

t2m_gnss=t2m(k2,k1,1);% the 00:00 h
tcwv_gnss=tcwv(k2,k1,1);
tm=50.440+0.789*t2m_gnss;
wet_pd_msl=(0.101995+1725.55/tm)*(tcwv_gnss/1000);

