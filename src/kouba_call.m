% Three subfuntions are provided
% -kouba, least square fit
% -kouba2, using the single level as the surface wet PD of earth.
% -kouba3, only use the pressure level data.
% I suggest the kouba3 and kouba funtion.

%%

clear;
clc;

format long

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

% define the location
% lat_gps=36.2672;% 千里岩验潮站的坐标
% lon_gps=121.3853;
% lat_gps=1.8235778e+01;% GNSS的坐标
% lon_gps=1.0953055e+02;% 

lat_gps=1.6834028e+01;% GNSS的坐标
lon_gps=1.1233533e+02;%  
%%
% Pressure level
dir_nm=strcat('..\data\era5\4d\south','\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
temp=size(namelist);
file_num=temp(1);

% single level
dir_nm2=strcat('..\data\era5\pl_tcwv','\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist2 = ls(fullfile(dir_nm2,'*.nc'));% 这里ls可以和dir替换

[oro_suface]=orgraphy_height(lon_gps,lat_gps);% orography height

for nm=1:length(namelist)
    
    filepath=strcat(dir_nm,namelist(nm,:));
    disp(filepath)
%     filepath2=strcat(dir_nm2,namelist2(nm,:));

%     [kouba_p]=kouba(filepath,lon_gps,lat_gps);
%     [kouba_p]=kouba2(filepath,filepath2,lon_gps,lat_gps,oro_suface);
    [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
    
    % Filter data
    temp=std(kouba_p);
    if temp<300
        kouba_p_day(nm)=mean(kouba_p);
    else
        kouba_p_day(nm)=-9999;
    end  
    kouba_p_day_std(nm)=temp;
    
end

figure(11)
kouba_p_day=kouba_p_day';

k=1;
for i=1:length(kouba_p_day)
    if kouba_p_day(i)>-60 && kouba_p_day(i)<6000
        kouba_good(k)=kouba_p_day(i);
        days(k)=i;
        k=k+1;
    end        
end
mean(kouba_p_day)
std(kouba_p_day)
plot(days,kouba_good,'o')

figure (12)
days=linspace(1,length(namelist),length(namelist));
plot(days,kouba_p_day_std,'o')


