% ###############################################

function read_hy2a_l2p(min_cir,max_cir,min_lat,max_lat,min_lon,max_lon,dir_0)

% ###############################################
% First loop directories

for cycle=min_cir:max_cir

    temp1=check_circle(cycle);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    temp3=temp2(2:5);% 组成字符串。
    dir_nm=strcat(dir_0,'\cycle_',temp3,'\'); % 
    namelist = ls(fullfile(dir_nm,'*.nc')); % 
    
    % Second loop files
    for nm=1:length(namelist)
%     for nm=290:310
        nm
        filepath=strcat(dir_nm,namelist(nm,:));
        nc=netcdf.open(filepath,'NC_NOWRITE');
        lat=netcdf.getVar(nc,1);%10-6度
        lon=netcdf.getVar(nc,2);%10-6度
        time=netcdf.getVar(nc,0);%10-6度
        alt=netcdf.getVar(nc,3);%10-4m
        r_ku=netcdf.getVar(nc,4);%10-4m
        wet=netcdf.getVar(nc,5);%10-4m
        wet_m=netcdf.getVar(nc,6);%10-4m,wet model
        dry=netcdf.getVar(nc,7);%10-4m
        dac=netcdf.getVar(nc,8); % The DAC equals the INV + HFF      
        ots=netcdf.getVar(nc,9);%ocean tide sole1,10-4m
        set=netcdf.getVar(nc,10);%solid earth tide,10-4m
        pt=netcdf.getVar(nc,11); %pole tide,10-4m
        ssb=netcdf.getVar(nc,12);% sea state bias,10-4m
        ino=netcdf.getVar(nc,13);%10-4m
        mss=netcdf.getVar(nc,14); %mean_sea_surface ,10-4m
        sla=netcdf.getVar(nc,15); %mean_sea_surface ,10-4m

        netcdf.close(nc)

        outfile=strcat('..\test\hy2_check\',namelist(nm,23:34),'l2p','.dat');% 只取周期和pass编号
        fid2 = fopen(outfile,'w');
%             k=0;
        for i=1:length(lon)
%             
%             if lat(i)<max_lat && lat(i)> min_lat && r_ku(i)~=2147483647 ...
%                     && alt(i)~=2147483647 && sla(i)~=32767
            
            if lat(i)<max_lat && lat(i)> min_lat && lon(i)<max_lon && lon(i)> min_lon  && sla(i)~=32767           
                
                ssh=double(alt(i)-r_ku(i))/1E4- ...
                double(dry(i)+wet(i)+ino(i)+ssb(i)+dac(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;

                sla_my=ssh-double(mss(i))/1E4;

                ssh_nc=(double(mss(i))+double(sla(i)))/1E4;
                ssh_d=ssh-ssh_nc;
                sla_nc=double(sla(i))/1E4;
            
%                 fprintf(fid2,'%12.6f %12.6f %12.6f  %12.6f  %12.8f %12.8f %12.8f  %12.8f %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),ssh,ssh_nc,ssh_d,sla_my,sla_nc,double(mss(i))/1E4);
                fprintf(fid2,'%12.6f %12.6f  %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,ssh_nc);
            
            end
        end
        fclose(fid2);
    end 
    fclose('all');
end
return