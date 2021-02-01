% read ERA5 mean sea level pressure
% *************************************************************************
% Author:leiyang@fio.org.cn
% 2021-01-25
% *************************************************************************

clear;
clc;
format long

%% Run only one time to get the content.
% 
% filepath='..\data\era5\middle\era5.mslp.20100101.nc'; % Here is the NC file location.
% nc=netcdf.open(filepath,'NC_NOWRITE');
% [numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(nc);% Determine numbers of the variable
% 
% fid1 = fopen('..\test\era5_mslp.txt', 'w'); % open the empty file to write out the data
% 
% for i=0:numvars-1
%     [varname, xtype, varDimIDs, varAtts] = netcdf.inqVar(nc,i);
%     out=mat2str(varname);
%     fprintf(fid1,'%4d %4d %10s  \n',i,varDimIDs(1),out);
% end
% 
% fclose(fid1); 
%% read the orignal data. Must add the offset and scalor before use
% filepath='..\data\era5\middle\era5.mslp.20100101.nc';
% ncdisp(filepath) % Show nc infomation.
% filepath='C:\Users\yangleir\Documents\jianguoyun\Documents\python3_stu\era5\data\download.nc';
% ncdisp(filepath) % Show nc infomation.

% nc=netcdf.open(filepath,'NC_NOWRITE');
% lat=netcdf.getVar(nc,0); % 1d
% lon=netcdf.getVar(nc,1); % 1d
% time=netcdf.getVar(nc,2); % 1d, hours since 1900-01-01 00:00:00.0
% mslp=netcdf.getVar(nc,3); % 3d
%% Another method to read the data. No need to add any offset
filepath='C:\Users\yangleir\Documents\jianguoyun\Documents\python3_stu\era5\data\g.nc';
% ncdisp(filepath) % Show nc infomation.
lat=ncread(filepath,'latitude'); % 1d
lon=ncread(filepath,'longitude'); % 1d
time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
geo=ncread(filepath,'z'); % 3d, Pa
hum=ncread(filepath,'q'); % 3d, Pa
air_t=ncread(filepath,'t'); % 3d, Pa

geo_h=geo/9.80665; % transform the geopotential to height.


%% make new nc file

ny=length(lon);
nx=length(lat);
writegrid(lon,lat,geo_h(:,:,37),'mslp_one.nc',ny,nx)

%% plot line
% figure (2)
% tmp=mslp(1,1:45,1);
% tmp=reshape(tmp,1,45);
% plot(tmp/100);
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

