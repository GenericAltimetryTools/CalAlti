% This program aims to validate the wet delay measured by satellite radiometer 
% Author:Yang Lei
% 2020-0716

clear; %
clc; % 
format long

% Step 1 preparations
%=========================================================================
% Please modify these parameters according to your requirement
dir_0='C:\Users\yangleir\Downloads\hy2b\IDR_2M\';% data directory 
min_cir=7;% 7
max_cir=46;% 46
loc = 'yong';% please select from hisy hisy2  sdqd sdyt sdrc sdrc2 yong yong2 fjpt gdst
sat=3;% 3=hy2b
%=========================================================================
% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps]=readhy2_cal_select_site(loc);% 
% Step 2: get the wet correction of satellite altimter (radiometer value)
readhy2b_check_wet(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0,sat);
% Step 3: show the wet delay(radiometer and model)
plot_hy2b_check_wet(pass_num,min_cir,max_cir,sat);
% Step 4: interpolation of  the wet delay to the fixed point.
wet_inter(min_cir,max_cir,pass_num,loc,sat);
% Step 4: compare the GNSS and radiometer.
[bias2]=wet_cal_G_S(sat,loc);
% Step5: Save
wet_filter_save(bias2,sat,min_cir,max_cir)
% Step6: Analysis the spatial inluence
dis_0=0;% This is the distance from the first point.
[spa]=spatial_dec(pass_num,min_cir,max_cir,sat,dis_0);
% finish