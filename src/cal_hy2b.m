% This program is to calibrate HY-2 altimetry data. It will
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
% dir_0='D:\hy2b\IDR_2M\';% data directory 
dir_0='D:\hy2b\GDR_2P\';% GDR-2P version released in mid 2020

% At present, it only works for HY-2B over Zhu hai wan shan site.
loc = 'bzmw';% Here can choose the bqly(2b qly), bzmw (2b zmw), zhws.
if  strcmp(loc,'zhws')
    min_cir=23;% 
    max_cir=46;% 
elseif  strcmp(loc,'bqly')|| strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
    min_cir=2;% cycle 5 have problems
    max_cir=54;%
end
sat=3;% 3==hy2-b
fre=1;% choose 1 | 20
tmodel=3; % tide model. 1=NAO99jb,2=fes2014,3=call FES2014,4=call NAO99jb

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
%=========================================================================
% Step 2: select the CAL site
[pass_num,min_lat,max_lat,lat_gps,lon_gps]=readhy2_cal_select_site(loc);% 
% Step 3: Read satellite altimeter data, and plot the data

if fre==1
    tg_cal_read_hy2(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0);% 
    elseif fre==20
    disp('No high frequency program yet.')
end

quicklook_alti(min_cir,max_cir,min_lat,max_lat,pass_num,sat);%plot the output data

% Step 4: calculate the PCA point and interpolate the SSH at the PCA.
% Calculate the MSS difference
hy2b_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc);% Calculte PCA SSH of SA
grad(lat_gps,lon_gps,sat,loc)

% Step 5: calculate the SSH of the tide gauge data at the PCA time. Then
% the bias between TG and the SA. Aplly the tide correction, reference
% ellipsoid correction, geoid correction.
[bias2]=tg_pca_ssh(sat,fre,loc,tmodel);% PCA SSH of TG. Calaulte SA bias

[bias]=filter_bias(sat,bias2,loc);% filter and save to (example: ..\test\s3a_check\s3a_bias.txt)
last_bias_save(sat);% output more parameters.
% =========================================================================
% Step 6 Just plot bias
plot_bias(bias,sat)
[P]=trend_bias(bias,sat,min_cir,max_cir);% Add trend analysis
% =========================================================================
