% This program is to calibrate sentinel-3A and B altimetry data. It will
% call several functions to read SA data, TG data and model corrections.
% Please note that the 002 and 003 versions are different
% ###############################################
% leiyang@fio.org.cn
% 2020-07-06
% ###############################################

clear; 
clc; 
% workdir;
format long

% Step 1 preparations
%=========================================================================
%% Please modify these parameters according to your requirement
dir_0='C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\s3a\M\'; % data directory 
min_cir=12;% The First cycle number
max_cir=40;% The last cycle number // The S3A data before 2016 were not found£¿//
loc = 'zmw';% The name of CAL site
sat=5; % 5 means sentinel3-A
fre=1; % The frequency of SA data. 1 is 1Hz and 40 is 40Hz.
tmodel=3; % tide model. 1=NAO99jb,2=fes2014,3=cal FES2014l,4=NAO

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
%=========================================================================
%% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps]=reads3a_cal_select_site(loc); % select the CAL site;do the initialization
%% Step 3: Read satellite altimeter data, and plot the data
if fre==1
    tg_cal_read_s3a(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0);% read 1Hz SSH
    elseif fre==40
    tg_cal_read_s3a_hi(pass_num,min_cir,max_cir,min_lat,max_lat);% read 40Hz SSH
    % TBD
end
quicklook_alti(min_cir,max_cir,min_lat,max_lat,pass_num,sat);%plot the output data
% Step 4: calculate the PCA point and interpolate the SSH at the PCA.
% Calculate the MSS difference
s3a_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc);% 
grad(lat_gps,lon_gps,sat,loc)
% Step 5: calculate the SSH of the tide gauge data at the PCA time. Then
% the bias between TG and the SA. Aplly the tide correction, reference
% ellipsoid correction, geoid correction.
[bias2]=tg_pca_ssh(sat,fre,loc,tmodel);% calculate bias
[bias]=filter_bias(sat,bias2,loc);% filter and save to (example: ..\test\s3a_check\s3a_bias.txt)
last_bias_save(sat);% output more parameters.

% Step 6 Just plot bias
plot_bias(bias,sat)
[P]=trend_bias(bias,sat,min_cir,max_cir);% Add trend analysis

