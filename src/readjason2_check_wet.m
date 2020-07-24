% Reading altimeter data of NetCDF format by matlab.
% The altimeter data include (I)GDR(S),OGDR. 
% Other high level altimetry product of NetCDF format can also be processed
% ###############################################
% Modified on 2014.06.05 by Yang Lei. FIO, Qingdao.
% This program is for check key parameter availability at local sea, such
% as Qian liyan and Yuan dao. Mainly the Range_ku, Orbit and wet_radiometer
% and other parameters for calculating SSH. The check is important since 
% the HY-2 data are not high quality and we do not know whether the data 
% are available in specific coastal area. But it may be less inmportant for
% Jason-2 or Saral since their data are good enough.
% This program loops directories, read specified pass and output the 
% desired data  to one file(s).
%　All right reserved.
% ###############################################
% clear; % clear variables in memory
% clc; % clear commond window
% cd C:\Users\yl\Documents\matlab\;
% format long
% tic;
function readjason2_check_wet(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0,sat)
if sat==1
    fid3 = fopen('..\test\ja2_check\ponits_number.txt','w');
    fid1 = fopen('..\test\ja2_check\ponits_circle.txt','w');
elseif sat==4
    fid3 = fopen('..\test\ja3_check\ponits_number.txt','w');
    fid1 = fopen('..\test\ja3_check\ponits_circle.txt','w');
end
% ###############################################
% ###############################################
% First loop directories
% temp1=num2str(pass_num);
temp1=check_circle(pass_num);% 调用函数，判断circle的位数。
temp2=num2str(temp1);
temp3=temp2(3:5);% 组成三位数的字符串。
dir_nm=strcat(dir_0,temp3,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
temp=size(namelist);
file_num=temp(1);

for nm=1:length(namelist)
%     dir_0='G:\Jason2\cycle_';
%     temp1=check_circle(nm);% 调用函数，判断circle的位数。
%     temp2=num2str(temp1);
%     temp3=temp2(3:5);% 组成三位数的字符串。
%     dir_nm=strcat(dir_0,temp3,'\') % 输出文件夹名称
% 
%     namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
%     temp=size(namelist);
%     file_num=temp(1);
    
%     for n=1:file_num
        t1=str2double(namelist(nm,13:15));
        if ((t1>min_cir) && (t1<max_cir)) % here is pass which you need to output data;009;147
            t1
            filepath=strcat(dir_nm,namelist(nm,1:54));
            nc=netcdf.open(filepath,'NC_NOWRITE');
            lat=netcdf.getVar(nc,3);%10-6度
            lon=netcdf.getVar(nc,4);%10-6度
            time=netcdf.getVar(nc,0);%10-6度
%             alt=netcdf.getVar(nc,58);%10-3m
%             r_ku=netcdf.getVar(nc,61);%10-3m
%             dry=netcdf.getVar(nc,82);%10-4m
            wet_m=netcdf.getVar(nc,83);%10-4m
            wet=netcdf.getVar(nc,84);%10-4m
%             ino=netcdf.getVar(nc,85);%10-4m
%             ssb=netcdf.getVar(nc,88);% sea state bias,10-4m
%             inv=netcdf.getVar(nc,148);%inv_bar_corr ,10-4m
%             hff=netcdf.getVar(nc,149);%hf_fluctuations_corr  ,10-4m
%             ots=netcdf.getVar(nc,150);%ocean tide sole1,10-4m
%             set=netcdf.getVar(nc,156);%solid earth tide,10-4m
%             pt=netcdf.getVar(nc,157); %pole tide,10-4m
%             mss=netcdf.getVar(nc,144); %mean_sea_surface ,10-4m

            %关闭netcdf文件
            netcdf.close(nc)
            if sat==1
                outfile=strcat('..\test\ja2_check\',namelist(nm,13:19),'.txt');% 只取周期和pass编号
            elseif sat==4
                outfile=strcat('..\test\ja3_check\',namelist(nm,13:19),'.txt');% 只取周期和pass编号
            end
            
            fid2 = fopen(outfile,'w');
            k=0;
            for i=1:length(lon)
                
               if (((lat(i))<max_lat &&(lat(i))> min_lat)&& (-5000<=wet(i)&&wet(i)<=-10))
                        fprintf(fid2,'%12.6f %12.6f %12.6f %12.6f %12.6f\n',double(lon(i))/1E6,double(lat(i))/1E6,double(wet(i))/1E1,double(wet_m(i))/1E1,time(i));
%                         fprintf(fid1,'%12.6f %12d\n',double(lat(i))/1E6,nm);
%                         k=k+1;% statistic of valid point number 
%                         end
                end
            end
            fclose(fid2);
%             fprintf (fid3,'%12s %12d\n',namelist(n,13:19),k);
        end
%     end
end 
            fclose(fid1);
            fclose(fid3);

return 