% Read the hy2b wet delay and check the difference between the model and
% radiometer.
% author: leiyang@fio.org.cn

clear; %
clc; % 
format long

dir_0='C:\Users\yangleir\Downloads\hy2b\IDR_2M\';% data directory 
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
sat=3;

for cir=25:25 % 21-47 cycles is one year. 201908-202008
%     cir=17;% choose one cycle
    nm=cir;
    temp1=check_circle(nm);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    temp3=temp2(2:5);% 组成三位数的字符串。
    dir_nm=strcat(dir_0,temp3,'\') ;% 输出文件夹名称

    namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
    len=size(namelist);
    len=len(1);

    for  n=1:len
        q=['processing No.:',num2str( cir),': ',num2str(n),'/',num2str(len)];
        disp(q);
        t1=str2double(namelist(n,24:26));

        filepath=strcat(dir_nm,namelist(n,1:61));

        nc=netcdf.open(filepath,'NC_NOWRITE');
        lat=netcdf.getVar(nc,6);%10-6度
        lon=netcdf.getVar(nc,7);%10-6度
        time=netcdf.getVar(nc,0);%10-6度

        wet=netcdf.getVar(nc,63);%10-4m,rad
        wet_m=netcdf.getVar(nc,62);%10-4m,medel

        netcdf.close(nc)

        outfile=strcat('..\test\hy2_check\',namelist(n,18:26),'.txt');% 只取周期和pass编号
        fid2 = fopen(outfile,'w');

        for i=1:length(lon)              
            if ((-5000<=wet(i)&&wet(i)<=-10))
                fprintf(fid2,'%12.6f %12.6f %12.6f %12.6f  %12.6f %12.6f\n',double(lon(i))/1E6,double(lat(i))/1E6,double(wet(i))/1E1,double(wet_m(i))/1E1,double(wet_m(i))/1E1-double(wet(i))/1E1,time(i));
            end
        end
        fclose(fid2);

    end
    
% Plot the HY-2B passes 
% plot_gmt_pass(cir,sat);

end

% plot_gmt_grid(sat);


% clear the temporary files. Be careful. It will delete all the `txt` files
% in the related directory.

% clear_temp(sat);

