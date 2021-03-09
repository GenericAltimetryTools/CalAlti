% Comparison of xiam site between  IGS\CMONOC\CGN
% - try the ERA5 kouba coefficient, comparing to the 2000 value.
% - comparison between xiam sites from IGS,CMONOC,CGN.

%% 
clc
clear

% load tro data
gnss_wet_CMO=load ('..\test\gnss_wet\troXIAM.d3'); % tro from CMONOC site
gnss_wet_IGS=load ('..\test\gnss_wet\trokmnm.d3'); % tro from IGS site
gnss_wet_CNG=load ('..\test\gnss_wet\troDXMN.d');  % tro from IGS site

% Be attention that three data set have different formats.

% For CMONOC the format is :`2008.000000000 2524.90 209.70 17.50`
% `time ZTD wet sig_td`. 
% For China Ocean station GNSS, the format is `2010 01 01 00 00 00
% 2349.51 33.41 1.51` : `YYYY MM DD hh mm ss ztd wetpd sigma_ztd`
% For IGS, the format is `08 001 03000 2366.8 1.6`=`YY DDD Seconds dry
% sigma`. The seconds is accumulated in one day with maximum value of
% 85500. (15 minutes lost in IGS data)


%% First, CMONOC sites.
tmp000=gnss_wet_CMO;
y_0=floor(tmp000(:,1)); % year
da=tmp000(:,1)-y_0; % days/366
ztd_delay=tmp000(:,2);  % ZTD of GNSS,including the dry. Format: 2519.00
% The ZTD is accurate. To subtract the dry PD from GDR or ERA5, the
% accurate wet PD could be got.
z_delay=tmp000(:,3); % wet PD of GNSS, excluding the dry.
% z_delay_sigma=tmp000(:,4);  % sigma of the wet PD of GNSS.

% convert the time from year.. (as 2010.89773) to second refered to '2000-01-1 00:00:00'
% First, calculate the seconds of the year refered to 2000.
for i=2000:2030
   date_yj=[i 1 1 0 0 0];
   y_sec(i)=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
end

% Then, add the seconds of the days.
sec=y_sec(y_0)'+da*366*24*60*60; % the time in unit of second. 

g_ztd=ztd_delay; % GNSS ZTD
g_wet=z_delay; % GNSS wet

tm2=round(sec); % GNSS time in second
% plot(tm2,g_ztd);

%% find the year of 2018 and do the comparison of 2018. Because the whole data is slow.
index_=find(y_0==2018);
% index_(1);% this is the first data of 2010
% tm_2010=tm2(index_(1):length(y_0));
tm_2018=tm2(index_);% one year
g_ztd_2018=g_ztd(index_);
g_wet_2018=g_wet(index_);



%% calculate dry PD using ERA5
lat_gps=24.449852;% GNSSµÄ×ø±ê
lon_gps=118.08259	;%
h_gnss=93;

index_k=1;
[k1,k2,dir_era]=era5_interp(lon_gps,lat_gps);
pressure_era5_ready=[];
for i=1:length(tm_2018)
    [pressure_era5]=era5_dry_function2(tm_2018(i),k1,k2,dir_era);% pressure
    pressure_era5_ready(index_k)=pressure_era5;
    index_k=index_k+1;
end
% plot(pressure_era5_ready);

% pressure from ERA5
[pressure_era5_gnss_height]=dry_height(pressure_era5_ready,h_gnss)/100;%unit hPa.
% Dry delay from ERA5 pressure
pca_dry_corrected=-pressure_era5_gnss_height*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);% Dry PD Unit is mm.

figure('Name','GNSS dry ','NumberTitle','off');
plot(tm_2018,g_ztd_2018-g_wet_2018);hold on
plot(tm_2018,-pca_dry_corrected);

g_wet_CMO_era5=g_ztd_2018+pca_dry_corrected';
figure('Name','GNSS wet ','NumberTitle','off');
plot(tm_2018,g_wet_2018,'b--o');hold on
plot(tm_2018,g_wet_CMO_era5,'r-');

mean(g_wet_2018)
mean(g_wet_CMO_era5)
% The wet difference between that using ERA5 and GNSS internal are very
% small (about 1mm).

%% IGS sites.
tmp000=gnss_wet_IGS;
y_0=tmp000(:,1)+2000; % year
da=tmp000(:,2); % 
sec_igs=tmp000(:,3); % 

ztd_delay=tmp000(:,4);  % ZTD of GNSS,including the dry. Format: 2519.00
% convert the time from year.. (as 2010.89773) to second refered to '2000-01-1 00:00:00'
for i=2000:2030
   date_yj=[i 1 1 0 0 0];
   y_sec(i)=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
end

sec=y_sec(y_0)'+(da-1)*24*60*60+sec_igs; % time in unit of second.

g_ztd_IGS=ztd_delay; % GNSS ZTD

tm2_IGS=round(sec); % GNSS time in second      

%% ZTD comparison between IGS and CMO

tm_inter=intersect(tm_2018,tm2_IGS); % intersection between IGS and CMO

index_igs = []; % index of IGS
for i=1:length(tm_inter)
tmpindex = find(tm2_IGS==tm_inter(i));
index_igs = [index_igs,tmpindex];
end


index_cmo = [];% index of cmo 
for i=1:length(tm_inter)
tmpindex = find(tm_2018==tm_inter(i));
index_cmo = [index_cmo,tmpindex];
end

tm_2018_igs=tm2_IGS(index_igs);% one year
g_ztd_2018_igs=g_ztd_IGS(index_igs);
tm_2018_cmo=tm_2018(index_cmo);% one year
g_ztd_2018_cmo=g_ztd_2018(index_cmo);
g_wet_CMO_era5_2018=g_wet_CMO_era5(index_cmo);

figure('Name','GNSS ztd of IGS and CMO','NumberTitle','off');
plot(tm_2018_cmo,g_ztd_2018_cmo);hold on
plot(tm_2018_igs,g_ztd_2018_igs);hold on
% Result show the IGS and the CMO network are very close.

ztd_d_igs_cmo=g_ztd_2018_igs-g_ztd_2018_cmo;
figure('Name','GNSS ztd difference between IGS and CMO(IGS-CMO)','NumberTitle','off');
plot(tm_2018_igs,ztd_d_igs_cmo);hold on
mean (ztd_d_igs_cmo); % Total delay defference is about 2cm. Contain dry and wet. Height difference is about 60m.

%% wet comparison
lat_gps=24.463822;% 
lon_gps=118.38858;    
h_gnss=49.1-12.3;   

index_k=1;
[k1,k2,dir_era]=era5_interp(lon_gps,lat_gps);
pressure_era5_ready=[];
for i=1:length(tm_2018_igs)
    [pressure_era5]=era5_dry_function2(tm_2018_igs(i),k1,k2,dir_era);% pressure
    pressure_era5_ready(index_k)=pressure_era5;
    index_k=index_k+1;
end
% plot(pressure_era5_ready);

% pressure from ERA5
[pressure_era5_gnss_height]=dry_height(pressure_era5_ready,h_gnss)/100;%unit hPa.
% Dry delay from ERA5 pressure
pca_dry_corrected_IGS=-pressure_era5_gnss_height*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);% Dry PD Unit is mm.
g_wet_IGS_era5=g_ztd_2018_igs+pca_dry_corrected_IGS';


g_wet_d_igs_cmo=g_wet_IGS_era5-g_wet_CMO_era5_2018; % With no height correction.


mean(g_wet_d_igs_cmo)
std(g_wet_d_igs_cmo)
% The difference between IGS and CMO wet PD is only +4mm without the height
% correction. The IGS is lower than the CMO about 56m, so IGS WPD is
% higher about +4mm.

kouba_coefficient=2600; % This is the mean value.
g_wet_IGS_era5_height_toCMO=g_wet_IGS_era5*exp(-56.2/kouba_coefficient);
g_wet_d_igs_cmo_height_toCMO=g_wet_IGS_era5_height_toCMO-g_wet_CMO_era5_2018;
mean(g_wet_d_igs_cmo_height_toCMO)
std(g_wet_d_igs_cmo_height_toCMO)
% For 2600, the bias reduced to -1 from 4mm,
% For 2000, the bias reduced to -3 from 4mm,so the 


% The mean bias change from -2.7 to -1.2. Good
% The std bias change from 9.7 to 9.3. Good.

figure('Name','GNSS wet of IGS and CMO','NumberTitle','off');
plot(tm_2018_igs,g_wet_IGS_era5_height_toCMO);hold on
plot(tm_2018_igs,g_wet_CMO_era5_2018);hold on
out=[tm_2018_igs g_wet_IGS_era5_height_toCMO g_wet_CMO_era5_2018];
save('../temp/igs_cmo.txt','out','-ascii');

figure('Name','GNSS wet difference(IGS-CMO) with and without height correction ','NumberTitle','off');
plot(tm_2018_igs,g_wet_d_igs_cmo);hold on
plot(tm_2018_igs,g_wet_d_igs_cmo_height_toCMO);hold on


%% CNG sites.
tmp000=gnss_wet_CNG;
time_tmp=floor(tmp000(:,1:6)); % `YYYY MM DD hh mm ss`
sec=((datenum(time_tmp)-datenum('2000-01-1 00:00:00')))*86400;
tm2=round(sec); % GNSS time in second   

% remove the repeated data that maybe exited in CGN data files.
[tm2_clean,ia,ic]=unique(tm2); % remove the duplicated data using unique.
tm2_CNG=tm2_clean;

z_delay=tmp000(ia,8);  % wet PD of GNSS, excluding the dry. Format:240.60
ztd_delay=tmp000(ia,7);  % ZTD of GNSS,including the dry. Format: 2519.00
z_delay_sigma=tmp000(ia,9);  % sigma of the wet PD of GNSS.

g_wet_CNG=z_delay; % GNSS wet PD
g_ztd_CNG=ztd_delay; % GNSS ZTD

%% 

tm_inter=intersect(tm_2018,tm2_CNG); % intersection between IGS and CMO

index_cng = []; % index of IGS
for i=1:length(tm_inter)
tmpindex = find(tm2_CNG==tm_inter(i));
index_cng = [index_cng,tmpindex];
end


index_cmo = [];% index of cmo 
for i=1:length(tm_inter)
tmpindex = find(tm_2018==tm_inter(i));
index_cmo = [index_cmo,tmpindex];
end

tm_2018_cng=tm2_CNG(index_cng);% one year
g_ztd_2018_cng=g_ztd_CNG(index_cng);
% g_ztd_2018_cng= smooth(tm_2018_cng,g_ztd_2018_cng,24,'moving');
tm_2018_cmo=tm_2018(index_cmo);% one year
g_ztd_2018_cmo=g_ztd_2018(index_cmo);
g_wet_CMO_era5_2018=g_wet_CMO_era5(index_cmo);

figure('Name','GNSS ztd between CMO and CNG ','NumberTitle','off');
plot(tm_2018_cmo,g_ztd_2018_cmo);hold on
plot(tm_2018_cng,g_ztd_2018_cng);
% Result show the IGS and the CMO network are very close.

ztd_d_cng_cmo=g_ztd_2018_cng-g_ztd_2018_cmo;
figure('Name','GNSS ztd difference between CNG and CMO(CNG-CMO)','NumberTitle','off');
plot(tm_2018_cng,ztd_d_cng_cmo);hold on
mean (ztd_d_cng_cmo); % Total delay defference is about 2cm. Contain dry and wet. Height difference is about 60m.

%%
lat_gps=24.447600;% 
lon_gps=118.070800 ;    
h_gnss=13.8;   

index_k=1;
[k1,k2,dir_era]=era5_interp(lon_gps,lat_gps);
pressure_era5_ready=[];
for i=1:length(tm_2018_cng)
    [pressure_era5]=era5_dry_function2(tm_2018_cng(i),k1,k2,dir_era);% pressure
    pressure_era5_ready(index_k)=pressure_era5;
    index_k=index_k+1;
end

% pressure from ERA5
[pressure_era5_gnss_height]=dry_height(pressure_era5_ready,h_gnss)/100;%unit hPa.
% Dry delay from ERA5 pressure
pca_dry_corrected_IGS=-pressure_era5_gnss_height*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);% Dry PD Unit is mm.
g_wet_cng_era5=g_ztd_2018_cng+pca_dry_corrected_IGS';

figure('Name','GNSS wet ','NumberTitle','off');
plot(tm_2018_cng,g_wet_cng_era5);hold on
plot(tm_2018_cng,g_wet_CMO_era5_2018);hold on

g_wet_d_cng_cmo=g_wet_cng_era5-g_wet_CMO_era5_2018;
mean(g_wet_d_cng_cmo)
std(g_wet_d_cng_cmo)
% The difference between IGS and CNG wet PD is 15mm without the height
% correction.

kouba_coefficient=2690; % This is the mean value.
g_wet_cng_era5_height_toCMO=g_wet_cng_era5*exp((13.8-93)/kouba_coefficient);
g_wet_d_cng_cmo_height_toCMO=g_wet_cng_era5_height_toCMO-g_wet_CMO_era5_2018;
mean(g_wet_d_cng_cmo_height_toCMO)
std(g_wet_d_cng_cmo_height_toCMO)


figure('Name','GNSS wet difference(CNG-CMO) ','NumberTitle','off');
plot(tm_2018_cng,g_wet_d_cng_cmo);hold on
plot(tm_2018_cng,g_wet_d_cng_cmo_height_toCMO);hold on

% Conclution. The IGS and the CMO show very good agreements. But the CMO
% and the CNG shows a bias about 7mm and STD of 70mm. Very large. The CNG
% shows large osilations. Need smooth.?
