% Estimate the land deformation by GNSS 
% Load GNSS 3-D data
clc;
clear;
filename = '..\tg_xinxizx\gnss\NDWS.txt';
disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load (filename);

filename = '..\tg_xinxizx\gnss\dws.d';
% disp(['loading TG file:',filename])
% disp('loading........................................................')
blh=load (filename);

yyyy=gnss(:,1);
mm=gnss(:,2);
dd=gnss(:,3);
xx=gnss(:,4);
yy=gnss(:,5);
zz=blh(:,3);

date_gnss = [yyyy  mm dd];
days=((datenum(date_gnss)-datenum('2000-01-1 00:00:00')));% days


z=zz;
plot(days,z);hold on
[z,days]=three_sigma_delete(z,days);
plot(days,z);

% legend ('X','Y','Z');
hold off;

% 
% x=bias(:,1);
% y=bias(:,2);
[P,S]=polyfit(days,z,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
output=[days z];
save ..\tg_xinxizx\gnss\dws.d2 output -ascii

trend_year=[];
for i=2:length(z)-1
    [P,S]=polyfit(days(2:i+1),z(2:i+1),1);
    trend_year(i)=P(1)*365*1000;% second to year
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (10)
plot(days(800:length(z)-1),trend_year(800:length(z)-1))
%=========================================================================
% $ awk '{print $4,$5,$6}' NDWS.txt |cct -I +proj=cart +ellps=WGS84 > dws.d

% clc;
clear;
filename = '..\tg_xinxizx\gnss\BZMW.txt';
disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load (filename);
filename = '..\tg_xinxizx\gnss\zmw.d';
% disp(['loading TG file:',filename])
% disp('loading........................................................')
blh=load (filename);
le=length(gnss);

yyyy=gnss(1:le,1);
mm=gnss(1:le,2);
dd=gnss(1:le,3);


date_gnss = [yyyy  mm dd];
days=((datenum(date_gnss)-datenum('2000-01-1 00:00:00')));% days
% output=[days xx yy zz];
[m,n]=find(days==6318);% Find the day of GNSS changing.
[m2,n2]=find(days==6388);

xx=gnss(1:m,4);
yy=gnss(1:m,5);
zz=blh(1:m,3);
xx2=gnss(m2:le,4);
yy2=gnss(m2:le,5);
zz2=blh(m2:le,3);
d=days(1:m);
% d=days(1:m);
z=zz;
[P,S]=polyfit(d,z,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
% cx=;% connect data
% cy=
cz=polyval(P,6388) ;

d2=days(m2:le);
z2=zz2;
[P,S]=polyfit(d2,z2,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
cz2=polyval(P,6388) ;
c=cz-cz2;
z3=z2+c;
z_combine=[z' z3']';
figure (2)
plot(days,z_combine);hold on
[z_combine,days]=three_sigma_delete(z_combine,days);
plot(days,z_combine);

legend ('Z');
hold off;
[P,S]=polyfit(days,z_combine,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
output=[days z_combine];
save ..\tg_xinxizx\gnss\zmw.d2 output -ascii

trend_year=[];
for i=2:length(z_combine)-1
    [P,S]=polyfit(days(2:i+1),z_combine(2:i+1),1);
    trend_year(i)=P(1)*365*1000;% second to year
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (15)
plot(days(800:length(z_combine)-1),trend_year(800:length(z_combine)-1))

%-=========================
% clc;
% clear;
filename = '..\tg_xinxizx\gnss\BQLY.txt';
disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load (filename);

filename = '..\tg_xinxizx\gnss\qly.d';
blh=load (filename);

yyyy=gnss(:,1);
mm=gnss(:,2);
dd=gnss(:,3);
xx=gnss(:,4);
yy=gnss(:,5);
zz=blh(:,3);

date_gnss = [yyyy  mm dd];
days=((datenum(date_gnss)-datenum('2000-01-1 00:00:00')));% days
output=[days xx yy zz];

z=zz;
% std(z)
% mean(z)
figure (3)
plot(days,z);hold on
[z,days]=three_sigma_delete(z,days);
[z,days]=three_sigma_delete(z,days);
[z,days]=three_sigma_delete(z,days);
plot(days,z);

% legend ('X','Y','Z');
hold off;

[P,S]=polyfit(days,z,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
output=[days z];
save ..\tg_xinxizx\gnss\qly.d2 output -ascii

%-=========================
% clc;
% clear;
filename = '..\tg_xinxizx\gnss\SDQD.ios_gamit_raw.neu';
% filename = '..\tg_xinxizx\gnss\SDQD.ios_bernese_raw.neu';

% YYYY.DECM YYYY DOY     N(m)      E(m)      U(m)   sig_n(m)   sig_e(m)  sig_u(m)  

disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load(filename);

days=gnss(:,1);
xx=gnss(:,4);
yy=gnss(:,5);
zz1=gnss(1:1720,6);
zz2=gnss(1721:length(gnss),6);
days1=gnss(1:1720,1);
days2=gnss(1721:length(gnss),1);

[P,S]=polyfit(days1,zz1,1);
trend_year=P(1)*1000;
simu=polyval(P,days);
plot(days,simu);
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])

[P,S]=polyfit(days1,zz1,1);
trend_year=P(1)*1000;
cz1=polyval(P,2016.0806) ;
[P,S]=polyfit(days2,zz2,1);
trend_year=P(1)*1000;
cz2=polyval(P,2016.0806) ;
c=cz1-cz2;

z3=zz2+c;
z_combine=[zz1' z3']';
z_combine=z_combine-mean(z_combine)+11.7;
% std(z)
% mean(z)
figure (4)
plot(days,z_combine);hold on
[z_combine,days]=three_sigma_delete(z_combine,days);
[z_combine,days]=three_sigma_delete(z_combine,days);
[z_combine,days]=three_sigma_delete(z_combine,days);
plot(days,z_combine);

% legend ('X','Y','Z');


[P,S]=polyfit(days,z_combine,1);
trend_year=P(1)*1000;
simu=polyval(P,days);
plot(days,simu);
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
hold off;

output=[days z_combine];
save ..\tg_xinxizx\gnss\sdqd.d2 output -ascii

trend_year=[];
for i=2:length(z_combine)-1
    [P,S]=polyfit(days(2:i+1),z_combine(2:i+1),1);
    trend_year(i)=P(1)*1000;% second to year
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (12)
plot(days(1000:length(z_combine)-1),trend_year(1000:length(z_combine)-1))
% mean(trend_year(1000:length(z_combine)-1))
% std(trend_year(1000:length(z_combine)-1))

%-=========================
% clc;
% clear;
filename = '..\tg_xinxizx\gnss\GDZH.ios_gamit_raw.neu';
% filename = '..\tg_xinxizx\gnss\GDZH.ios_bernese_raw.neu';

% YYYY.DECM YYYY DOY     N(m)      E(m)      U(m)   sig_n(m)   sig_e(m)  sig_u(m)  

disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load(filename);

days=gnss(:,1);
xx=gnss(:,4);
yy=gnss(:,5);
zz=gnss(:,6)+5.0471732e+01;

% std(z)
% mean(z)
figure (5)
plot(days,zz);hold on
[zz,days]=three_sigma_delete(zz,days);
[zz,days]=three_sigma_delete(zz,days);
[zz,days]=three_sigma_delete(zz,days);
plot(days,zz);

% legend ('X','Y','Z');


[P,S]=polyfit(days,zz,1);
trend_year=P(1)*1000;
simu=polyval(P,days);
plot(days,simu);
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
hold off;

output=[days zz];
save ..\tg_xinxizx\gnss\gdzh.d2 output -ascii

trend_year=[];
for i=2:length(zz)-1
    [P,S]=polyfit(days(2:i+1),zz(2:i+1),1);
    trend_year(i)=P(1)*1000;% second to year
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (13)
plot(days(800:length(zz)-1),trend_year(800:length(zz)-1))

%-=========================
% clc;
% clear;
% filename = '..\tg_xinxizx\gnss\LNHL.ios_gamit_raw.neu';
filename = '..\tg_xinxizx\gnss\LNHL.ios_bernese_raw.neu';

% YYYY.DECM YYYY DOY     N(m)      E(m)      U(m)   sig_n(m)   sig_e(m)  sig_u(m)  

disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load(filename);

days=gnss(:,1);
xx=gnss(:,4);
yy=gnss(:,5);
zz=gnss(:,6)+4.2492700e+01;

% std(z)
% mean(z)
figure (6)
plot(days,zz);hold on
[zz,days]=three_sigma_delete(zz,days);
[zz,days]=three_sigma_delete(zz,days);
[zz,days]=three_sigma_delete(zz,days);
plot(days,zz);

[P,S]=polyfit(days,zz,1);
trend_year=P(1)*1000;
simu=polyval(P,days);
plot(days,simu);
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
hold off;

output=[days zz];
save ..\tg_xinxizx\gnss\lnhl.d2 output -ascii

trend_year=[];
for i=2:length(zz)-1
    [P,S]=polyfit(days(2:i+1),zz(2:i+1),1);
    trend_year(i)=P(1)*1000;% second to year
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (14)
plot(days(800:length(zz)-1),trend_year(800:length(zz)-1))

%% wanshan
% Check the land deformation through GNSS 
vertical = load('D:\ZWS\GBS\NetS10\ZhiwanMountaintop\altzhiwan.dd');
v=vertical(:,2);
t=vertical(:,1);
[v,t]=three_sigma_delete(v,t);
plot(v)
mean(v)
std(v)


%--------------------------------------------------------------------------
% date_gnss = [2021  1 1];
% days=((datenum(date_gnss)-datenum('2000-01-1 00:00:00')))
