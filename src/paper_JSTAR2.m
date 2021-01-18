% Statistic of HY-2B
format long
clear all

%% Check the impact of data length on the trend estimation.
% bias = load ('..\test\ja2_check\bias_last_ja2_qly.txt');
bias = load ('C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_ja2_zmw3.txt');
x1=bias(:,5)/(365*86400); % This time is same with next line 
x=bias(:,3)/(36.5); % cycle to year
y=bias(:,4)*1000; % meter to mm. 
trend_year=[];
sec=bias(2:length(x),5);
for i=2:length(x)-1
    [P,S]=polyfit(x(2:i+1),y(2:i+1),1);
    trend_year(i)=P(1);% second to year
%     sec(i)=
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (1)
plot(sec(10:length(x)-1),trend_year(10:length(x)-1))
out=[sec(10:length(x)-1) trend_year(10:length(x)-1)'];
save ../temp/trend.txt out -ascii

% non-linear
trend_year2=[];
sec=[];
tmp1=36*3;
for i=2:1:length(x)-tmp1
    [P,S]=polyfit(x(i:i+tmp1),y(i:i+tmp1),1);
    trend_year2(i)=P(1);% second to year
    sec(i)=bias((2*i+tmp1)/2,5);
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year2(i))])
end
figure (2)
plot(sec(2:length(sec)),trend_year2(2:length(sec)))
out=[sec(2:length(sec)); trend_year2(2:length(sec))]';
mean( trend_year2(2:length(sec)))
std( trend_year2(2:length(sec)))
save ../temp/trend2.txt out -ascii

disp(['The uncertainty of the trend: ',num2str(std(trend_year(100:length(x)-1)))]) % This could be seem as the uncertainty.
% semilogy(trend_year)
[P,S]=polyfit(x,y,1);
disp(['The trend of bias (a*x+b) is mm/y:',num2str(P)])


%% Check STD and mean
mean_bias=[];
std_bias=[];
for i=1:length(x)-1
    mean_bias(i)=mean(y(1:i+1));% second to year
    std_bias(i)=std(y(1:i+1));
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(mean_bias(i))])
end
figure (2)
plot(mean_bias(1:length(x)-1));hold on
plot(std_bias(1:length(x)-1))
%%
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2b_qly3.txt
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2b_zhws3.txt
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2b_zmw3.txt
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2b_zmw23.txt

bias1=bias_last_hy2b_qly3(:,4:5);
bias2=bias_last_hy2b_zhws3(:,4:5);
bias3=bias_last_hy2b_zmw3(:,4:5);
bias4=bias_last_hy2b_zmw23(:,4:5);
bias=[bias1' bias2' bias3' bias4'];
[asort ind] = sort(bias(2,:));
b = bias(:,ind);
% plot(b(2,:),b(1,:))
std(b(1,:))
mean(b(1,:))

%% Zhimaowan GNSS data. 
load C:\Users\yangleir\Documents\jianguoyun\Documents\projects\NSFC\青年基金\止锚湾\full_output\height.d
plot(height(10000:length(height)-300))
h=mean(height(10000:length(height)-300)) % The GNSS height of Zhimaowan level point. Just considering the robust data.
tran=h-(20.117) % 
%%
% compare the tide gauge data with NAO and FES model
% 2020-4-1 to 2020-5-1

tg_qly=load ('..\tg_xinxizx\qly\QLY_2011_2018_clean.txt');
tg_zmw=load ('..\tg_xinxizx\zmw\ZMW_sort_clean.DD');
tg_zhiwan=load ('..\tide_zhws\tideZhiwanWharf.DD');

nao_qly=load ('..\test\qly.nao2015_2021');
nao_zmw=load ('..\test\zmw.nao_2011_2021_');
nao_zhiwan=load ('..\test\zhiwan.nao_2019_2022');

fes_qly=load ('..\test\fes.qly_2b_ja_2011_2021');
fes_zmw=load ('..\test\fes.zmw_ja_2b_2011_2021');
fes_zhiwan=load ('..\test\fes.zhws_hy2b_2019_2021');

% qly
ss=[];
tmp000=tg_qly;
tmp1=tmp000(:,1); %yyyymmddHHMM
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
hh=str2num(tmp(:,9:10));
ff=str2num(tmp(:,11:12));
ss(1:length(ff))=0;
ss=ss';
ssh_qly=tmp000(:,2)/100;% unit cm

date_yj = [yyyy  mm dd hh ff ss];
disp('Finish loading of real TG data')
t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);% Jason-2/3 time reference is 2000-01-1 00:00:00。
t_qly=round(t3*86400); % This is the time (seconds) of the tide gauge data ，UTC+0 (same with altimeter)
disp('Finish time reference transform of real TG data')
% plot(t_qly,ssh_qly);


% zmw
ss=[];
tmp000=tg_zmw;
tmp1=tmp000(:,1); %yyyymmddHHMM
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
hh=str2num(tmp(:,9:10));
ff=str2num(tmp(:,11:12));
ss(1:length(ff))=0;
ss=ss';
ssh_zmw=tmp000(:,2)/100;% unit cm

date_yj = [yyyy  mm dd hh ff ss];
disp('Finish loading of real TG data')
t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);% Jason-2/3 time reference is 2000-01-1 00:00:00。
t_zmw=round(t3*86400); % This is the time (seconds) of the tide gauge data ，UTC+0 (same with altimeter)
disp('Finish time reference transform of real TG data')
% plot(t_zmw,ssh_zmw);


% zmw
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
ssh_zhiwan=tmp000(:,3);% unit:m

date_yj = [yyyy  mm dd hh ff ss];
disp('Finish loading of real TG data')
t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);% Jason-2/3 time reference is 2000-01-1 00:00:00。
t_zhiwan=round(t3*86400); % This is the time (seconds) of the tide gauge data ，UTC+0 (same with altimeter)
disp('Finish time reference transform of real TG data')
plot(t_zhiwan,ssh_zhiwan);

% To second 
t_min=(datenum('2020-04-01 00:00:00')-datenum('2000-01-1 00:00:00'))*86400;
t_max=(datenum('2020-08-10 00:00:00')-datenum('2000-01-1 00:00:00'))*86400;

% In situ tide gauge data
[row]=find(t_zhiwan>t_min & t_zhiwan<t_max);
t_zhiwan_select=t_zhiwan(row);
ssh_zhiwan_select=ssh_zhiwan(row)-mean(ssh_zhiwan(row));

[row]=find(t_qly>t_min & t_qly<t_max);
t_qly_select=t_qly(row);
ssh_qly_select=ssh_qly(row)-mean(ssh_qly(row));

[row]=find(t_zmw>t_min & t_zmw<t_max);
t_zmw_select=t_zmw(row);
ssh_zmw_select=ssh_zmw(row)-mean(ssh_zmw(row));

% NAO model
nao_qly_sec=(nao_qly(:,1)+(datenum('2015-01-1 00:00:00')-datenum('2000-01-1 00:00:00')))*86400; %日期的ellipsed day，
nao_qly_tg=nao_qly(:,2); % 预报潮汐tide，单位cm
nao_zmw_sec=(nao_zmw(:,1)+(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')))*86400; %日期的ellipsed day，
nao_zmw_tg=nao_zmw(:,2); % 预报潮汐tide，单位cm
nao_zhiwan_sec=(nao_zhiwan(:,1)+(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')))*86400; %日期的ellipsed day，
nao_zhiwan_tg=nao_zhiwan(:,2); % 预报潮汐tide，单位cm

[row]=find(nao_qly_sec>t_min & nao_qly_sec<t_max);
nao_qly_sec_select=nao_qly_sec(row);
nao_qly_tg_select=(nao_qly_tg(row)-mean(nao_qly_tg(row)))/100;

[row]=find(nao_zmw_sec>t_min & nao_zmw_sec<t_max);
nao_zmw_sec_select=nao_zmw_sec(row);
nao_zmw_tg_select=(nao_zmw_tg(row)-mean(nao_zmw_tg(row)))/100;

[row]=find(nao_zhiwan_sec>t_min & nao_zhiwan_sec<t_max);
nao_zhiwan_sec_select=nao_zhiwan_sec(row);
nao_zhiwan_tg_select=(nao_zhiwan_tg(row)-mean(nao_zhiwan_tg(row)))/100;


% FES model
fes_qly_sec=(fes_qly(:,1)-fes_qly(1,1)+(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')))*86400; %日期的ellipsed day，
fes_qly_tg=fes_qly(:,2); % 预报潮汐tide，单位cm
fes_zmw_sec=(fes_zmw(:,1)-fes_zmw(1,1)+(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')))*86400; %日期的ellipsed day，
fes_zmw_tg=fes_zmw(:,2); % 预报潮汐tide，单位cm
fes_zhiwan_sec=(fes_zhiwan(:,1)-fes_zhiwan(1,1)+(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')))*86400; %日期的ellipsed day，
fes_zhiwan_tg=fes_zhiwan(:,2); % 预报潮汐tide，单位cm

[row]=find(fes_qly_sec>t_min & fes_qly_sec<t_max);
fes_qly_sec_select=fes_qly_sec(row);
fes_qly_tg_select=(fes_qly_tg(row)-mean(fes_qly_tg(row)))/100;

[row]=find(fes_zmw_sec>t_min & fes_zmw_sec<t_max);
fes_zmw_sec_select=fes_zmw_sec(row);
fes_zmw_tg_select=(fes_zmw_tg(row)-mean(fes_zmw_tg(row)))/100;

[row]=find(fes_zhiwan_sec>t_min & fes_zhiwan_sec<t_max);
fes_zhiwan_sec_select=fes_zhiwan_sec(row);
fes_zhiwan_tg_select=(fes_zhiwan_tg(row)-mean(fes_zhiwan_tg(row)))/100;

% Plot
figure(101)
plot(t_zmw_select,ssh_zmw_select,'black');hold on
plot(nao_zmw_sec_select,nao_zmw_tg_select,'r');
plot(fes_zmw_sec_select,fes_zmw_tg_select,'b');

figure(102)
plot(t_qly_select,ssh_qly_select,'black');hold on
plot(nao_qly_sec_select,nao_qly_tg_select,'r');
plot(fes_qly_sec_select,fes_qly_tg_select,'b');

figure(103)
plot(t_zhiwan_select,ssh_zhiwan_select,'black');hold on
plot(nao_zhiwan_sec_select,nao_zhiwan_tg_select,'r');
plot(fes_zhiwan_sec_select,fes_zhiwan_tg_select,'b');

% Statistic
ssh_zhiwan_select_int=interp1(t_zhiwan_select,ssh_zhiwan_select,nao_zhiwan_sec_select,'PCHIP');
tg_dif1=ssh_zhiwan_select_int-nao_zhiwan_tg_select;
tg_dif2=ssh_zhiwan_select_int-fes_zhiwan_tg_select;
O=['STD dif of TG-NAO at Zhiwan:',num2str(std(tg_dif1)),'m'];
O2=['Mean dif of TG-FES at Zhiwan:',num2str(std(tg_dif2)),'m'];
disp(O)
disp(O2)
O=['corrcoef of TG-NAO at zhiwan:',num2str(min(corrcoef(ssh_zhiwan_select_int,nao_zhiwan_tg_select)))];
O2=['corrcoef of TG-FES at zhiwan:',num2str(min(corrcoef(ssh_zhiwan_select_int,fes_zhiwan_tg_select)))];
disp(O)
disp(O2)

ssh_qly_select_int=interp1(t_qly_select,ssh_qly_select,nao_qly_sec_select,'PCHIP');
tg_dif1=ssh_qly_select_int-nao_qly_tg_select;
tg_dif2=ssh_qly_select_int-fes_qly_tg_select;
O=['STD dif of TG-NAO at QLY:',num2str(std(tg_dif1)),'m'];
O2=['STD dif of TG-FES at QLY:',num2str(std(tg_dif2)),'m'];
disp(O)
disp(O2)
O=['corrcoef  of TG-NAO at zhimaowan:',num2str(min(corrcoef(ssh_qly_select_int,nao_qly_tg_select)))];
O2=['corrcoef of TG-FES at zhimaowan:',num2str(min(corrcoef(ssh_qly_select_int,fes_qly_tg_select)))];
disp(O)
disp(O2)

ssh_zmw_select_int=interp1(t_zmw_select,ssh_zmw_select,nao_zmw_sec_select,'PCHIP');
tg_dif1=ssh_zmw_select_int-nao_zmw_tg_select;
tg_dif2=ssh_zmw_select_int-fes_zmw_tg_select;
O=['STD dif of TG-NAO at zhimaowan:',num2str(std(tg_dif1)),'m'];
O2=['STD dif of TG-FES at zhimaowan:',num2str(std(tg_dif2)),'m'];
disp(O)
disp(O2)
O=['corrcoef  of TG-NAO at zhimaowan:',num2str(min(corrcoef(ssh_zmw_select_int,nao_zmw_tg_select)))];
O2=['corrcoef of TG-FES at zhimaowan:',num2str(min(corrcoef(ssh_zmw_select_int,fes_zmw_tg_select)))];
disp(O)
disp(O2)

%%
