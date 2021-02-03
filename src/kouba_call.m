clear;
clc;
format long
% define the location
% lat_gps=36.2672;% 千里岩验潮站的坐标
% lon_gps=121.3853;
lat_gps=1.8235778e+01;% GNSS的坐标
lon_gps=1.0953055e+02;% 

% lat_gps=23;% GNSS的坐标
% lon_gps=116;% 
%%

dir_nm=strcat('..\data\era5\4d\south','\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
temp=size(namelist);
file_num=temp(1);

for nm=1:length(namelist)
    
    filepath=strcat(dir_nm,namelist(nm,:));
    disp(filepath)
%     filepath='..\data\era5\4d\hisy.nc';
    [kouba_p]=kouba2(filepath,lon_gps,lat_gps);
    kouba_p_day(nm)=mean(kouba_p);
    
end

figure(11)
plot(kouba_p_day,'o')


