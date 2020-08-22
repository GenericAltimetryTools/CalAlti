% This program aims to validate the wet delay measured by satellite radiometer 
% Author:Yang Lei
% 2020-0716

function hy2b_wet(sat,loc,dir_0)

% Step 1 preparations
%=========================================================================
% Please modify these parameters according to your requirement
min_cir=7;% 7
max_cir=48;% 46

%=========================================================================
% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps]=readhy2_cal_select_site(loc);% 
% Step 2: get the wet correction of satellite altimter (radiometer value)
readhy2b_check_wet(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0,sat);
% Step 3: show the wet delay(radiometer and model)
plot_hy2b_check_wet(pass_num,min_cir,max_cir,sat);
% Step 4: interpolation of  the wet delay to the fixed point.
[bias_std,bias2,sig_g,dist]=wet_inter_call(min_cir,max_cir,lon_gps,lat_gps,pass_num,loc,sat);

% Step5: Analysis the spatial inluence
dis_0=dist.data(3);% This is the distance from the first point.
[spa]=spatial_dec(265,min_cir,max_cir,sat,dis_0);% Here we use the YONG as a reference
% Step6: Analysis the final sigma of radiometer
[sig_r]=sigma_r(bias_std,sig_g,spa);
% finish
return