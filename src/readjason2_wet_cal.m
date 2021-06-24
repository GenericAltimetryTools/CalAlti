% Check the land contamination on AMR TB measurements.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

clc;
clear;
format long
pwd
% load the GDR data
nc=netcdf.open('C:\Users\yangleir\Documents\aviso\jason3\153\JA3_GPN_2PdP148_153_20200219_231645_20200220_001258.nc','NC_NOWRITE');
fid1 = fopen('..\temp\ja2_ssh_ok.out','w');% save wet PD
fid3 = fopen('..\temp\ja2_ssh_p153.xys','w');  
fid2 = fopen('..\temp\ja2_all_p153.xys','w');

fprintf(fid2,'%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s\n', ...
        'lon','lat','r_ku','alt','dry','wet','wet_m','ino','ino_gim','ssb','inv','lod','set','pt','ots');

lat=netcdf.getVar(nc,3);%10-6 degree
lon=netcdf.getVar(nc,4);%10-6 degree
time=netcdf.getVar(nc,0);%10-6 degree
alt=netcdf.getVar(nc,58);%10-3m
r_ku=netcdf.getVar(nc,61);%10-3m
dry=netcdf.getVar(nc,82);%10-4m
wet_m=netcdf.getVar(nc,83);%10-4m
wet=netcdf.getVar(nc,84);%10-4m
ino=netcdf.getVar(nc,85);%10-4m
ino_m=netcdf.getVar(nc,87);%10-4m
ssb=netcdf.getVar(nc,88);% sea state bias,10-4m
inv=netcdf.getVar(nc,148);%inv_bar_corr ,10-4m
hff=netcdf.getVar(nc,149);%hf_fluctuations_corr  ,10-4m
ots=netcdf.getVar(nc,150);%ocean tide sole1,10-4m
set=netcdf.getVar(nc,156);%solid earth tide,10-4m
pt=netcdf.getVar(nc,157); %pole tide,10-4m
mss=netcdf.getVar(nc,144); %mean_sea_surface ,10-4m
lod=netcdf.getVar(nc,154); % load_tide_sol1 

surf_t=netcdf.getVar(nc,7); %surface_type
rain_f=netcdf.getVar(nc,48);%rain_flag 
ice_f=netcdf.getVar(nc,50);%rain_flag 
r_rms=netcdf.getVar(nc,67);%range_rms_ku
r_nums=netcdf.getVar(nc,69);%range_rms_ku
swh=netcdf.getVar(nc,92);% swh_ku
wnd=netcdf.getVar(nc,160);% wind speed alti
sig=netcdf.getVar(nc,110);%sig0_ku 
sig0_rms=netcdf.getVar(nc,116);%sig0_ku 
sig0_num=netcdf.getVar(nc,118);%sig0_ku 
off_nd_ag=netcdf.getVar(nc,136);
bath=netcdf.getVar(nc,147);%

netcdf.close(nc)


for i=1:length(lon)
    
        ssh=double(alt(i)-r_ku(i))/10000- ...
        double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(lod(i))/1E4;
    
        sla=double(alt(i)-r_ku(i)-mss(i))/10000- ...
        double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;

    if( (lat(i)<37000000) && (lat(i)>35000000))   
        fprintf(fid3,'%12.6f %12.6f %12.6f %12.6f %12.6f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),ssh,sla);
        fprintf(fid1,'%12.6f %12.6f %12.6f %12.6f\n',double(lon(i))/1E6,double(lat(i))/1E6,double(wet(i))/1E4,double(wet_m(i))/1E4);
        fprintf(fid2,'%12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f  %12.6f %12.6f %12.6f %12.6f %12.6f %12d %12d %12d %12d\n', ...
            double(lon(i))/1E6,double(lat(i))/1E6,double(r_ku(i))/1E4,double(alt(i))/1E4,double(dry(i))/1E4,...
                double(wet(i))/1E4,double(wet_m(i))/1E4,double(ino(i))/1E4,double(ino_m(i))/1E4,double(ssb(i))/1E4,double(inv(i))/1E4,...
            double(lod(i))/1E4,double(set(i))/1E4,double(pt(i))/1E4,double(ots(i))/1E4,sig(i),r_rms(i),wnd(i),swh(i));

    end      


end

fclose('all');
% Finish reading the GDR

% *************************************************************************
% *************************************************************************
% 

load ..\temp\ja2_ssh_ok.out
tmp=ja2_ssh_ok;
lat_gps=36.26;% Location of QLY
lon_gps=121.38;% Location of QLY
len=length(tmp(:,1));
lon=tmp(:,1);
lat=tmp(:,2);
ssh=tmp(:,3);
wet_m=tmp(:,4);

figure(1)
hold on

plot(lat,ssh,'r+');
plot(lat,wet_m,'b+');
wet_min=min(ssh);
wet_max=max(ssh);
plot([lat_gps lat_gps],[wet_min wet_max],'-');
plot([36.73 36.73],[wet_min wet_max],'-');

legend('Rad','Mod')
xlabel('¾­¶È/¡ã')
ylabel('ÊªÑÓ³Ù/m')

% xlim([0 10]);
% ylim([8.5 9.5])
% plot ([36.26 36.26],[-0.18 -0.15],'LineWidth',2)
% text(36.26,-0.175,' \leftarrow QLY','FontSize',10)

