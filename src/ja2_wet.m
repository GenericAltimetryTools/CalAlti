% This program aims to validate the wet delay measured by satellite radiometer 
% Author:Yang Lei
% 2020-0716

function ja2_wet(sat,loc,dir_0,dry)
% Step 1 preparations
%=========================================================================
% Please modify these parameters according to your requirement

min_cir=56;% 92,165,239,55,
max_cir=303;% 165,239,303,303

%=========================================================================
% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps,h_gnss]=readja2_cal_select_site(loc);% 选择地点千里岩
% Step 2: get the wet correction of satellite altimter (radiometer value)
readjason2_check_wet(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0,sat);
% Step 3: show the wet delay(radiometer and model)
plot_jason2_check_wet(pass_num,min_cir,max_cir,sat);
plot_gmt(pass_num,min_cir,max_cir,sat);
% Step 4: interpolation of  the wet delay to the fixed point and compare the GNSS and radiometer.
% Then save the results.
[bias_std,~,sig_g,dist]=wet_inter_call(min_cir,max_cir,lon_gps,lat_gps,pass_num,loc,sat,dry,h_gnss);
% [bias_std]=wet_filter_save(bias2,sat,min_cir,max_cir);
% [bias2,sig_g]=wet_cal_G_S(sat,loc);

% Step5: Analysis the spatial inluence
dis_0=dist.data(3);% This is the distance from the first point.
[spa]=spatial_dec(153,min_cir,max_cir,sat,dis_0); % here we use the `153` as a constant pass number because the data are in open coean and are of good quality.
% Step6: Analysis the final sigma of radiometer
[sig_r]=sigma_r(bias_std,sig_g,spa);
% finish

return