% 卫星测高定标程序
% BY Yang Lei,FIO,MNR of China.
% Email: leiyang@fio.org.cn

% ###############################################
clear; 
clc; 
workdir;
format long

min_cir=0;% 165
max_cir=106;% 239
loc = 'zmw';
sat=4;
fre=1;%表示选择的高度计数据类型，高频为20 or 40，低频为1.

[pass_num,min_lat,max_lat,lat_gps,lon_gps]=readja2_cal_select_site(loc);% 选择地点千里岩，jason3和jason-2可以通用。

if fre==1
    tg_cal_read_jason3(pass_num,min_cir,max_cir,min_lat,max_lat);% 读取Jason-3数据
    elseif fre==20
    tg_cal_read_jason3_hi(pass_num,min_cir,max_cir,min_lat,max_lat);% TBD
end

ja3_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc);% 计算PCA，以及PCA点的SSH插值

% 下面的程序再进行优化，加强程序的易用性。现在的问题是，每次换卫星，还要手动更换潮汐改正等文件。
% =========================================================================
[bias2]=qly_tg_pca_ssh(sat,fre,loc);% 计算TG在PCA时刻的SSH，并计算测高绝对偏差
% =========================================================================

% 下面三行再次对HY-2做三倍中误差约束。剔除粗差。
% 注意！第一个数和最后一个数，不在时间范围内
tmpp=bias2(:,2);
ttt=bias2(:,1);
[tmpp,ttt]=three_sigma_delete(tmpp,ttt);
bias2=[ttt tmpp];
% [bias2]=qly_short_tg_pca_ssh(sat);% 计算TG在PCA时刻的SSH，并计算测高绝对偏差
plot_bias(bias2,sat)

% [ymd]=sec2ydm(sat);% 时间转换，为了使用GMT绘制bias时间序列
% ！！！！！！！！！！！！！！！！！！
% last_bias_save(sat);% 临时子程序，保存bias最终结果，含有时间
% ！！！！！！！！！！！！！！！！！！

save jason_3_bias_new.txt bias2 -ASCII % 保存结果数据
% 趋势分析
[P]=trend_bias(bias2,sat,min_cir,max_cir);

% 绘图,并且统计
% bias1=bias2 (53:62,1:2);

% plot_bias2(sat)