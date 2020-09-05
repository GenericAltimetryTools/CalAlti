% This program is to calibrate Jason-2/3 altimetry data. It will
% call several functions to read SA data, TG data and model corrections.

% ###############################################
% leiyang@fio.org.cn
% 2020-07-06
% ###############################################
clear; 
clc; 
format long

% Step 1 preparations
%=========================================================================
% Please modify these parameters according to your requirement
dir_0='C:\Users\yangleir\Documents\aviso\Jason3\';% data directory 
min_cir=0;% 0,128
max_cir=106;% 106,158 
loc = 'qly';% Here can choose the qly, zmw, zhws
sat=4;% 4==jason-3
fre=1;%表示选择的高度计数据类型，高频为20 or 40，低频为1.

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
%=========================================================================
% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps]=readja2_cal_select_site(loc);% 选择地点千里岩，jason3和jason-2可以通用。
% Step 3: Read satellite altimeter data, and plot the data

if fre==1
    tg_cal_read_jason3(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0);% 读取Jason-3数据
    elseif fre==20
    tg_cal_read_jason3_hi(pass_num,min_cir,max_cir,min_lat,max_lat);% TBD
end
quicklook_alti(min_cir,max_cir,min_lat,max_lat,pass_num,sat);%plot the output data
% Step 4: calculate the PCA point and interpolate the SSH at the PCA.
% Calculate the MSS difference
ja3_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc);% 计算PCA，以及PCA点的SSH插值
grad(lat_gps,lon_gps,sat,loc)
% Step 5: calculate the SSH of the tide gauge data at the PCA time. Then
% the bias between TG and the SA. Aplly the tide correction, reference
% ellipsoid correction, geoid correction.
[bias2]=tg_pca_ssh(sat,fre,loc);% 计算TG在PCA时刻的SSH，并计算测高绝对偏差

[bias]=filter_bias(sat,bias2,loc);% filter and save to (example: ..\test\s3a_check\s3a_bias.txt)
last_bias_save(sat);% output more parameters.
% =========================================================================
% Step 6 Just plot bias
plot_bias(bias,sat)
[P]=trend_bias(bias,sat,min_cir,max_cir);% Add trend analysis
% =========================================================================
