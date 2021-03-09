% Three subfuntions are provided
% -kouba, least square fit
% -kouba2, using the single level as the surface wet PD of earth.
% -kouba3, only use the pressure level data.
% I suggest the kouba3 and kouba funtion. (fast and robust)

%%

clear;
clc;

format long

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

% define the location
% lat_gps=16.8;% 
% lon_gps=112.3;
% area='south';

% lat_gps=25.4589;% GNSS的坐标
% lon_gps=119.847;% 1.1976872e+02 2.5502154e+01
% area='middle';

lat_gps=40.7;% GNSS的坐标
lon_gps=121;%  
area='north';
%%
% Pressure level
dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist = ls(fullfile(dir_nm,'*.nc'));% 
temp=size(namelist);
file_num=temp(1);

% single level
dir_nm2=strcat('..\data\era5\pl_tcwv','\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist2 = ls(fullfile(dir_nm2,'*.nc'));% 

[oro_suface]=orgraphy_height(lon_gps,lat_gps);% orography height

for nm=1:length(namelist)
    
    filepath=strcat(dir_nm,namelist(nm,:));
    disp(filepath)
%     filepath2=strcat(dir_nm2,namelist2(nm,:));

%     [kouba_p]=kouba(filepath,lon_gps,lat_gps);
%     [kouba_p]=kouba2(filepath,filepath2,lon_gps,lat_gps,oro_suface);
    [kouba_p]=kouba3(filepath,lon_gps,lat_gps); % this is the best one.
%     
    % Filter data
    temp=std(kouba_p);
    if temp<500
        kouba_p_day(nm)=mean(kouba_p);
    else
        kouba_p_day(nm)=-9999;
    end  
    kouba_p_day_std(nm)=temp;
    
end

% figure(11)
kouba_p_day=kouba_p_day';
days=[];
k=1;
for i=1:length(kouba_p_day)
    if kouba_p_day(i)>-60 && kouba_p_day(i)<6000
        kouba_good(k)=kouba_p_day(i);
        days(k)=i;
        k=k+1;
    end        
end

k=1;
for i=1:length(kouba_p_day_std)
    if  kouba_p_day_std(i)<600
        kouba_p_day_std_good(k)=kouba_p_day_std(i);
        days2(k)=i;
        k=k+1;
    end        
end

% mean(kouba_p_day)
% std(kouba_p_day)
% plot(days,kouba_good,'o')


figure('Name','Kouba coefficient STD'); 
% days=linspace(1,length(namelist),length(namelist));
kouba_std_month = smooth(days2,kouba_p_day_std_good,120,'moving');
plot(days2,kouba_p_day_std_good,'o');hold on
plot(days2,kouba_std_month,'r-');hold on

out=[days' kouba_good'];
filename1=strcat('../temp/kouba_',area,'.txt');
save(filename1,'out','-ASCII') % 保存结果数据  
% save  ../temp/kouba_n.txt out -ascii

figure('Name','Kouba coefficient'); 
kouba_coefficient=load (filename1);
kouba_good_month = smooth(kouba_coefficient(:,1),kouba_coefficient(:,2),120,'moving');
plot(kouba_coefficient(:,1),kouba_coefficient(:,2),'o');hold on
plot(kouba_coefficient(:,1),kouba_good_month,'r-');

mean(kouba_coefficient(:,2))
std(kouba_coefficient(:,2))

out=[kouba_coefficient(:,1) kouba_coefficient(:,2) kouba_good_month];
filename1=strcat('../temp/kouba_',area,'_smooth.txt');
save(filename1,'out','-ASCII') % 保存结果数据  


