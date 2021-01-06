% This program is to calibrate Jason-2 altimetry data. It will call several
% functions to read SA (satellite altimetry) data, TG (tide gauge) data and
% model corrections.
% GMT (Generic Mapping Tools) is used to calcuate the MSS difference by
% 'grad'.

% ###############################################
% Author: leiyang@fio.org.cn
% 2020-07-06
% ###############################################

clear; % clear variables in memory
clc; % clear commond window
format long

% Step 1 preparations
%=========================================================================
% Please modify these parameters according to your requirement
dir_0='C:\Users\yangleir\Documents\aviso\Jason2\';% data directory 
loc = 'zmw';% Here can choose the qly and zmw
if strcmp(loc,'zmw')
    min_cir=114;%
    % over the zmw, the tide data only begin at circle 114.
elseif strcmp(loc,'qly')
    min_cir=92;% over the qly, the tide data begin at circle 92.
end
max_cir=303;% 165,239,303. This is depended on the tide data time span.
sat=1; % 1 = Jason-2
fre=1; % 1=1Hz. Usually 1 Hz is ok to do the CAL.
tmodel=3; % tide model. 1=NAO99jb,2=fes2014,3=call FES2014

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
%=========================================================================

% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps]=readja2_cal_select_site(loc);% select the site `loc` from qly and zmw.

% Step 3: Read satellite altimeter data, and plot the data
tg_cal_read_jason(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0);% read SA
quicklook_alti(min_cir,max_cir,min_lat,max_lat,pass_num,sat);% plot the SA to have a quick look of the SA quality.

% Step 4: calculate the PCA point and interpolate the SSH at the PCA.
% Use `grad` to calculate the MSS difference
ja2_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc);% calculate PCA SSH of SA
grad(lat_gps,lon_gps,sat,loc)

% Step 5: calculate the SSH of the tide gauge data at the PCA time. Then
% the bias between TG and the SA. Aplly the tide correction, reference
% ellipsoid correction, geoid correction.
[bias2]=tg_pca_ssh(sat,fre,loc,tmodel);% calculate the TG PCA SSH and then the altimeter SSH bais
% plot(bias2(:,1),bias2(:,2)); % Just plot bias.
[bias]=filter_bias(sat,bias2,loc);% filter and save to (example: ..\test\s3a_check\s3a_bias.txt)
last_bias_save(sat);% output more parameters.
% =========================================================================
% Step 6 Just plot bias after filtering
plot_bias(bias,sat)
[P]=trend_bias(bias,sat,min_cir,max_cir);% Add trend analysis
