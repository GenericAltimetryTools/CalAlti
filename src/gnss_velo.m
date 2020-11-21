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
output=[days xx yy zz];

z=zz-mean(zz);y=yy-mean(yy);x=xx-mean(xx);
plot(days,x,days,y,days,z);hold on

legend ('X','Y','Z');
hold off;

% 
% x=bias(:,1);
% y=bias(:,2);
[P,S]=polyfit(days,z,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])

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
z=zz-mean(zz);y=yy-mean(yy);x=xx-mean(xx);
[P,S]=polyfit(d,z,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
% cx=;% connect data
% cy=
cz=polyval(P,6388) 

d2=days(m2:le);
z2=zz2-mean(zz2);y2=yy2-mean(yy2);x2=xx2-mean(xx2);
[P,S]=polyfit(d2,z2,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
cz2=polyval(P,6388) 
c=cz-cz2;
z3=z2+c;
z_combine=[z' z3']';
figure (2)
plot(days,z_combine);hold on

legend ('X','Y','Z');
hold off;
[P,S]=polyfit(days,z_combine,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])

% 
% x=bias(:,1);
% y=bias(:,2);



%-=========================
% clc;
% clear;
filename = '..\tg_xinxizx\gnss\BQLY.txt';
disp(['loading TG file:',filename])
disp('loading........................................................')
gnss=load (filename);

filename = '..\tg_xinxizx\gnss\qly.d';
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
output=[days xx yy zz];

z=zz-mean(zz);y=yy-mean(yy);x=xx-mean(xx);
figure (3)
plot(days,x,days,y,days,z);hold on

legend ('X','Y','Z');
hold off;

% 
% x=bias(:,1);
% y=bias(:,2);
[P,S]=polyfit(days,z,1);
trend_year=P(1)*365*1000;
disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])

