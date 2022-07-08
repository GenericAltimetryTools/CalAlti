% Envalue the  geoid by GNSS buoy

%% This is the GNSS buoy data in 2019-04 over XMD
clc
clear
format long

oldpath = path; % Add GMT path. The GMT is available from https://github.com/GenericMappingTools/gmt
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

x=load ('C:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\结果文件\GF2.txt');
x2=load ('C:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\结果文件\GF1.txt');
%-------- DO the  Butterworth IIR digital filter to the GNSS SSH--------%
order=2;lwidth=2.1;hwidth=120;
len=length(x)-2500;
b=93000;
tmp1 = high_pass_filter(x(:,2), order,hwidth,1);
tmp2 = low_pass_filter(x(:,2), order,300,1);%G1
tmp3 = low_pass_filter(x2(:,2), order,300,1);% G2
b2=93000;
len2=length(x2);

% GMT
gmt('gmtset MAP_FRAME_WIDTH = 0.02c FONT_LABEL 7 MAP_LABEL_OFFSET 5p ')
gmt('gmtset FORMAT_GEO_MAP = ddd:mm:ssF')

psname=strcat('XMD_route.ps');
bound='-R120:12/120:30/35:55/36:07';
order=['pscoast ',bound,' -JM3i  -Ba -BSWen -Df -W0.1 -Glightyellow -K > ',psname];
gmt(order); 
order=['psxy -R -J -W1p,red  -K -O >> ',psname];
route_g=[x(b:len,3),x(b:len,4)];
gmt(order,route_g); % the distance line 50km

order=['psxy -R -J -W1p,blue  -K -O >> ',psname];
route_g=[x2(b2:len2,3),x2(b2:len2,4)];
gmt(order,route_g); % the distance line 50km 

order=['grdcontour C:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\fig\qly.nc -R -J -C0.1 -A0.5f6+um -Gd1i -L-100/100  -O -K -Wa0.3p -Wc0.15p,black >> ',psname];
gmt(order); % the distance line 50km 

% order=['pswiggle  -R -J  -Z10 -W2p,24/75/167,  -O -K -DjBR+w1+o0.2i+l0cm >> ',psname];
% wave=[x(:,3:4) tmp1];
% gmt(order, wave(b:len,1:3)) % second order derivative

t_gb=x(b:len,1)-32*3600;
t_gb2=x2(b2:len2,1)-32*3600;

plot(tmp2(b:len,1))
t1=x(b,1)-32*3600;
hh1=floor(t1/3600);
mm1=floor((t1/3600-hh1)*60);
ss1=floor(((t1/3600-hh1)*60-mm1)*60);

t2=x(len,1)-32*3600;
hh2=floor(t2/3600);
mm2=floor((t2/3600-hh2)*60);
ss2=floor(((t2/3600-hh2)*60-mm1)*60);

% add tide correction.
load naotide_xmd0401.out
tide=(naotide_xmd0401(:,2)-mean(naotide_xmd0401(:,2)))/100;
t_nao=naotide_xmd0401(:,1)*3600*24;

t_cor=interp1(t_nao,tide,t_gb,'spline');
t_cor2=interp1(t_nao,tide,t_gb2,'spline');


% DTU model
order=['grdtrack  -GC:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\fig\qly.nc']; % calculate the distance from grid points to coastline
tra=gmt(order,x(b:len,3:4)); % Here is the Bug for some locations.
order=['grdtrack  -GC:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\fig\qly.nc']; % calculate the distance from grid points to coastline
tra2=gmt(order,x2(b2:len2,3:4)); % Here is the Bug for some locations.

% % DTU 10
% order=['grdtrack  -GC:\Users\yangleir\Documents\jianguoyun\Documents\基本数据集\dtu\DTU10MSS_2min.nc']; % calculate the distance from grid points to coastline
% tra=gmt(order,x(b:len,3:4)); % Here is the Bug for some locations.
% order=['grdtrack  -GC:\Users\yangleir\Documents\jianguoyun\Documents\基本数据集\dtu\DTU10MSS_2min.nc']; % calculate the distance from grid points to coastline
% tra2=gmt(order,x2(b2:len2,3:4)); % Here is the Bug for some locations.


% CLS model
% order=['grdtrack  -Gcls_mss8.nc']; % calculate the distance from grid points to coastline
% tra=gmt(order,x(b:len,3:4)); % Here is the Bug for some locations.
% order=['grdtrack  -Gcls_mss8.nc']; % calculate the distance from grid points to coastline
% tra2=gmt(order,x2(b2:len2,3:4)); % Here is the Bug for some locations.

subplot(1,2,2)
plot(t_gb,t_cor);
legend('NAO tide corr');
xlabel('time/s');ylabel('Tide/m')
subplot(1,2,1)
d1=mean(tmp2(b:len)-t_cor-tra.data(:,3));
d2=mean(tmp2(b:len)-tra.data(:,3));
d4=mean(tmp3(b2:len2)-tra2.data(:,3));
d3=mean(tmp3(b2:len2)-t_cor2-tra2.data(:,3));
std(tmp3(b2:len2)-t_cor2-tra2.data(:,3))
std(tmp2(b:len)-t_cor-tra.data(:,3))

% plot(t_gb,tmp2(b:len)-d2,t_gb,tmp2(b:len)-t_cor-d1,t_gb,tra.data(:,3),t_gb2,tmp3(b2:len2)-t_cor2-d3)
% legend('G1','G1+tide corr','DTU18','G2+tide corr')
% xlabel('time/s');ylabel('Geoid/m')

plot(t_gb,tmp2(b:len)-t_cor-d1,t_gb,tra.data(:,3),t_gb2,tmp3(b2:len2)-t_cor2-d3)
legend('G1+tide corr','DTU18','G2+tide corr')
xlabel('time/s');ylabel('Geoid/m')

%% 
% 2015 qianliyan buoy

load E:\2015.6.28千里岩实验\results\浮标解算结果\g1.loc
load E:\2015.6.28千里岩实验\results\浮标解算结果\g2.loc
load E:\2015.6.28千里岩实验\results\浮标解算结果\g3.loc

% GMT
gmt('gmtset MAP_FRAME_WIDTH = 0.02c FONT_LABEL 7 MAP_LABEL_OFFSET 5p ')
gmt('gmtset FORMAT_GEO_MAP = ddd:mm:ssF')

psname=strcat('qly_route.ps');
bound='-R121/121.5/36/36.5';
bound='-R121:11/121:12/36:14:30/36:15';
bound='-R121.351041561/121.389600941/36.250117396/36.2617';
bound='-R121.382354547/121.392148651/36.260627921/36.27239';
order=['pscoast ',bound,' -JM5i  -Ba -BSWen -Df -W0.1 -Glightyellow -K > ',psname];
gmt(order); 
order=['psxy -R -J -W1p,red  -K -O >> ',psname];
gmt(order,g1); % the distance line 50km

order=['psxy -R -J -W1p,yellow  -K -O >> ',psname];
gmt(order,g2); % the distance line 50km

order=['psxy -R -J -W1p,yellow  -K -O >> ',psname];
gmt(order,g3); % the distance line 50km

format long
lat_m=mean(g1);
order=['psxy -R -J -Sc0.2c -Gblue  -K -O >> ',psname];
gmt(order,lat_m); % the distance line 50km

%% qianliyan ship GNSS 2014
format long
shipgps=load ('E:\千里岩定标（2014.09.15）\千里岩试验9.15\千里岩定标实验解算结果（2014.09.15-18）\船载GPS解算\9.18所内基站+千里岩山顶基站\千里岩基站\261.out');
% shipgps=load ('E:\千里岩定标（2014.09.15）\千里岩试验9.15\千里岩定标实验解算结果（2014.09.15-18）\船载GPS解算\9.17-所内基站\260.out');
%-------- DO the  Butterworth IIR digital filter to the GNSS SSH--------%
x=shipgps;
order=2;lwidth=2.1;hwidth=120;
len=length(x)-5000;
b=5000;
tmp1 = high_pass_filter(x(:,4), order,hwidth,1);
tmp2 = low_pass_filter(x(:,4), order,500,1);%G1


% GMT
gmt('gmtset MAP_FRAME_WIDTH = 0.02c FONT_LABEL 7 MAP_LABEL_OFFSET 5p ')
gmt('gmtset FORMAT_GEO_MAP = ddd:mm:ssF')

psname=strcat('qly_route2.ps');
bound='-R121.183396625/121.376678714/36.233596546/36.292698';
order=['pscoast ',bound,' -JM3i  -Ba -BSWen -Df -W0.1 -Glightyellow -K > ',psname];
gmt(order); 
order=['psxy -R -J -W1p,red  -K -O >> ',psname];
route_g=[x(b:len,3),x(b:len,2)];
gmt(order,route_g); % the distance line 50km

order=['grdcontour C:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\fig\qly.nc -R -J -C0.1 -A0.5f6+um -Gd1i -L-100/100  -O -K -Wa0.3p -Wc0.15p,black >> ',psname];
gmt(order); % the distance line 50km 

t_gb=x(b:len,1)-0*3600;% time in second

plot(tmp2(b:len,1))

t1=x(b,1)-0*3600;% begin
hh1=floor(t1/3600);% hh:mm:ss
mm1=floor((t1/3600-hh1)*60);
ss1=floor(((t1/3600-hh1)*60-mm1)*60);

t2=x(len,1)-0*3600;% end
hh2=floor(t2/3600);
mm2=floor((t2/3600-hh2)*60);
ss2=floor(((t2/3600-hh2)*60-mm2)*60);

% add tide correction.
tg=load ('E:\千里岩潮汐\20140918.txt');
% plot(tg(:,2));
tide=(tg(:,2)-mean(tg(:,2)))/100;
t_nao=linspace(1,144,144)*600-8*3600;

t_cor=interp1(t_nao,tide,t_gb,'spline');
plot(t_cor);hold on

% Using FES
time_pca_trans=t_gb/86400+datenum('2014-9-18 00:00:00');

% Now we got the location and time of PCA. 
[t_tg]=fes2014(route_g(:,2),route_g(:,1),time_pca_trans);
t_tg=t_tg/100;
plot(t_tg/100);hold on

% DTU18 model
order=['grdtrack  -GC:\Users\yangleir\Documents\jianguoyun\Documents\projects\guanlan\23_air_alti_sar\结果文件\fig\qly.nc']; % calculate the distance from grid points to coastline
tra=gmt(order,route_g); % Here is the Bug for some locations.


% % % DTU 10
% order=['grdtrack  -GC:\Users\yangleir\Documents\jianguoyun\Documents\基本数据集\dtu\DTU10MSS_2min.nc']; % calculate the distance from grid points to coastline
% tra=gmt(order,route_g); % Here is the Bug for some locations.


% CLS model
% order=['grdtrack  -Gcls_mss8.nc']; % calculate the distance from grid points to coastline
% tra=gmt(order,x(b:len,3:4)); % Here is the Bug for some locations.
% order=['grdtrack  -Gcls_mss8.nc']; % calculate the distance from grid points to coastline
% tra2=gmt(order,x2(b2:len2,3:4)); % Here is the Bug for some locations.

subplot(1,2,2)
plot(t_gb,t_tg);
legend('NAO tide corr');
xlabel('time/s');ylabel('Tide/m')
subplot(1,2,1)
d1=mean(tmp2(b:len)-t_tg-tra.data(:,3));
d2=mean(tmp2(b:len)-tra.data(:,3));
std(tmp2(b:len)-t_tg-tra.data(:,3))

plot(t_gb,tmp2(b:len)-t_tg-d1,t_gb,tra.data(:,3))
legend('G1+tide corr','DTU18','G2+tide corr')
xlabel('time/s');ylabel('Geoid/m')
