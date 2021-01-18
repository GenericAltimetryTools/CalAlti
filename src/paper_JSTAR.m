% Statistic of HY-2B
format long
clear all
% load C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\hy2_check\bias_last_hy2.txt
% bias=bias_last_hy22(2:16,4);
% mean(bias)
% std(bias)

%% Statistics of MSS difference between three tg
filename = '..\tide_zhws\tideZhiwanWharf.DD';
tg_zhiwan=load (filename);
filename = '..\tide_zhws\tideDanganWharf.DD';
tg_dg=load (filename);
filename = '..\tide_zhws\tideWailingdingWharf.DD';
tg_wai=load (filename);   

%% allocate
tmp000=tg_zhiwan;
tmp1=tmp000(:,1);% yyyymmdd
tmp2=tmp000(:,2);% hhmmss
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
tmp=num2str(tmp2);
hh=floor(tmp2/10000);
ff=floor((tmp2-hh*1E4)/100);
ss=tmp2-hh*1E4-ff*1E2;
date_zhiwan = [yyyy  mm dd hh ff ss];
disp('Finish loading of real zhiwan  TG data')
ssh_zhiwan=tmp000(:,3)+ 3.2373;

tmp000=tg_dg;
tmp1=tmp000(:,1);% yyyymmdd
tmp2=tmp000(:,2);% hhmmss
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
tmp=num2str(tmp2);
hh=floor(tmp2/10000);
ff=floor((tmp2-hh*1E4)/100);
ss=tmp2-hh*1E4-ff*1E2;
date_dg = [yyyy  mm dd hh ff ss];
disp('Finish loading of real dangan  TG data')
ssh_dg=tmp000(:,3)+  3.9471;

tmp000=tg_wai;
tmp1=tmp000(:,1);% yyyymmdd
tmp2=tmp000(:,2);% hhmmss
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
tmp=num2str(tmp2);
hh=floor(tmp2/10000);
ff=floor((tmp2-hh*1E4)/100);
ss=tmp2-hh*1E4-ff*1E2;
date_wai = [yyyy  mm dd hh ff ss];
disp('Finish loading of real wailingding TG data')
ssh_wai=tmp000(:,3)+ 2.75;

t3=((datenum(date_zhiwan)-datenum('2000-01-1 00:00:00'))-8/24);%时间格式转，卫星的参考时间是2000-01-1 00:00:00。
% The time zone of TG in China is Zone 8, Thus 8 hours should be
% subtracted from TG data.
t_zhiwan=round(t3*86400);% This is the time (seconds) of the tide gauge data ，UTC+0 (same with altimeter)
t3=((datenum(date_dg)-datenum('2000-01-1 00:00:00'))-8/24);%时间格式转，卫星的参考时间是2000-01-1 00:00:00。
t_dg=round(t3*86400);% This is the time (seconds) of the tide gauge data ，UTC+0 (same with altimeter)
t3=((datenum(date_wai)-datenum('2000-01-1 00:00:00'))-8/24);%时间格式转，卫星的参考时间是2000-01-1 00:00:00。
t_wai=round(t3*86400);% This is the time (seconds) of the tide gauge data ，UTC+0 (same with altimeter)

disp('Finish time reference transform of real TG data')
figure (1)
plot(t_wai,ssh_wai);hold on
plot(t_dg,ssh_dg);hold on
plot(t_zhiwan,ssh_zhiwan)

time_min=((datenum([2020 04 01 00 00 00])-datenum('2000-01-1 00:00:00')))*86400;
time_max=((datenum([2020 04 5 00 00 00])-datenum('2000-01-1 00:00:00')))*86400;

%% check the tide diffrence
load ..\test\zhiwan.nao_2019_2022
load ..\test\zhws.nao_2019_2022
load ..\test\dg.nao_2019_2022
time_nao=dg(:,1)*86400+(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00'))*86400; % 

tg_dif_1=(dg(:,2)-zhws(:,2))/100;
tg_dif_2=(dg(:,2)-zhiwan(:,2))/100;
% plot(time_nao,tg_dif_1)

xlim([time_min time_max])
% 
% mean(tg_dif)
% std(tg_dif)
% histfit(tg_dif)

%% Do Statistic
n=(time_max-time_min)/500; % 9 days
t=linspace(time_min,time_max,n);
s_dg=interp1(t_dg,ssh_dg,t,'PCHIP');
s_wai=interp1(t_wai,ssh_wai,t,'PCHIP');
s_zhiwan=interp1(t_zhiwan,ssh_zhiwan,t,'PCHIP');

d_dg_zhiwan=interp1(time_nao,tg_dif_2,t,'PCHIP');
d_dg_wai=interp1(time_nao,tg_dif_1,t,'PCHIP');

d1=s_dg-s_wai-d_dg_wai;
d2=s_dg-s_zhiwan-d_dg_zhiwan;

figure (2)
% plot(t,d1);hold on
% plot(t,s_dg-s_wai)
plot(t,d_dg_wai);hold on
plot(t,low_pass_filter(s_dg-s_wai-mean(s_dg-s_wai),2,3600,300))
% plot(t,s_dg-s_wai-mean(s_dg-s_wai)-d_dg_wai)
std(s_dg-s_wai);std(d2); % indicate NAO could mitigate the tide difference. But not perfect.

mean(d1)
mean(d2)
mean(s_dg-s_wai)
mean(s_dg-s_zhiwan)
mean(s_zhiwan-s_wai)
%% GMT track
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

loc_dg=[114.3036 22.0549];
loc_zhiwan=[114.1479 21.9949];
loc_wai=[114.0294 22.1080];
loc=[loc_dg;loc_zhiwan;loc_wai];

table = gmt('grdtrack  -G..\mss\zhws.nc', loc);
mss=table.data;
mss_d_zhi=mss(1,3)-mss(2,3)
mss_d_wai=mss(1,3)-mss(3,3)
mss_z_wai=mss(2,3)-mss(3,3)
% Results indicate that the datum of Wansha is not agree with DTU MSS
% model.


