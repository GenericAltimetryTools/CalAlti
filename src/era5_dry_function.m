% read ERA5 mean sea level pressure
% *************************************************************************
% Author:leiyang@fio.org.cn
% 2021-01-25
% *************************************************************************

function [pressure_era5]=era5_dry_function()

filepath='C:\Users\yangleir\Documents\jianguoyun\Documents\python3_stu\era5\data\g.nc';
ncdisp(filepath) % Show nc infomation.
lat=ncread(filepath,'latitude'); % 1d
lon=ncread(filepath,'longitude'); % 1d
time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
mslp=ncread(filepath,'t'); % 3d, Pa


%% make new nc file

ny=length(lon);
nx=length(lat);
writegrid(lon,lat,mslp(:,:,30)/9.8,'mslp_one.nc',ny,nx)

%% plot 2D with GMT
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

gmt ('set MAP_ANNOT_OBLIQUE=45 FONT_TITLE=10p')
gmt ('grd2cpt mslp_one.nc -Crainbow > mydata.cpt')
gmt ('grdimage -Rmslp_one.nc  -JR10c mslp_one.nc  -K > ../temp/igs.ps')
gmt ('pscoast -Rmslp_one.nc -JR10c -Dl -A10000/0/1 -Bxa120g -Byag  -O -K -W0.01p  >> ../temp/igs.ps')
gmt ('psscale -DjBC+o0c/-1.4c+w2.4i/0.08i -Rmslp_one.nc -JR10c -Cmydata.cpt -Bxaf -By+lunit -I -O  --FONT_ANNOT_PRIMARY=7p -K >> ../temp/igs.ps ')
% gmt ('psxy -R -J -Sc0.02 -Gred -O -K >> ../temp/igs.ps',out)
movefile('mslp_one.nc', '..\temp\mslp_one.nc'); 
delete('mydata.cpt')

%%
% time1990 = datenum('2000-01-01')- datenum('1900-01-01');     % 从公元1900-01-01到2000年所经历的日数
% righttime = time/24- time1990  ;   % 
return