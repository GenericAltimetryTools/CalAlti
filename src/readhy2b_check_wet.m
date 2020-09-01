% Read HY-2B wet delay.
% ###############################################
function readhy2b_check_wet(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0,sat)

if sat==3
    fid3 = fopen('..\test\hy2_check\ponits_number.txt','w');
    fid1 = fopen('..\test\hy2_check\ponits_circle.txt','w');
end

% First loop directories
for nm=min_cir:max_cir
%     dir_0='G:\hy2\IGDR\0';
    temp1=check_circle(nm);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    temp3=temp2(2:5);% 组成三位数的字符串。
    dir_nm=strcat(dir_0,temp3,'\') % 输出文件夹名称
    
    % Then get the specified pass name, such as the pass 147 which is
    % needed for checking out.
    % Format: H2A_RA1_IDR_2PT_0050_0147_20130822_090240_20130822_095452.nc
    %         H2A_RA1_IDR_2PT_0070_0001_20140524_015934_20140524_025140
    %         H2B_OPER_IDR_2MC_0014_0017_20190430T095913_20190430T105128.nc
    % Get all nc file names in present dir. 'Fullfile' is a internal 
    % function.
    namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
    len=size(namelist);
    len=len(1);
    
    for  n=1:len
        t1=str2double(namelist(n,24:26));
        if t1==pass_num % here is pass which you need to output data;009;147
            
            filepath=strcat(dir_nm,namelist(n,1:61));
            
            nc=netcdf.open(filepath,'NC_NOWRITE');
            lat=netcdf.getVar(nc,6);%10-6度
            lon=netcdf.getVar(nc,7);%10-6度
            time=netcdf.getVar(nc,0);%10-6度
%             alt=netcdf.getVar(nc,44);%10-3m
%             r_ku=netcdf.getVar(nc,47);%10-3m
            dry=netcdf.getVar(nc,61);%10-4m model dry
            wet=netcdf.getVar(nc,63);%10-4m,rad
            wet_m=netcdf.getVar(nc,62);%10-4m,medel
%             ino=netcdf.getVar(nc,64);%10-4m,alt_ku
            % ino=netcdf.getVar(nc,65);%10-4m,model_gim
%             ssb=netcdf.getVar(nc,66);% sea state bias,10-4m
%             inv=netcdf.getVar(nc,109);%inv_bar_corr ,10-4m
%             hff=netcdf.getVar(nc,110);%hf_fluctuations_corr ,10-4m
%             ots=netcdf.getVar(nc,111);%ocean tide sole1,10-4m
%             set=netcdf.getVar(nc,117);%solid earth tide,10-4m
%             pt=netcdf.getVar(nc,118); %pole tide,10-4m
%             mss=netcdf.getVar(nc,105); %

            %关闭netcdf文件
            netcdf.close(nc)
            
            outfile=strcat('..\test\hy2_check\',namelist(n,18:26),'.txt');% 只取周期和pass编号
            fid2 = fopen(outfile,'w');
%             k=0;
            
            for i=1:length(lon)              
                if (((lat(i))<max_lat &&(lat(i))> min_lat)&& (-5000<=wet(i)&&wet(i)<=-10))
                        fprintf(fid2,'%12.6f %12.6f %12.6f %12.6f %12.6f %12.6f\n',double(lon(i))/1E6,double(lat(i))/1E6,double(wet(i))/1E1,double(wet_m(i))/1E1,time(i),double(dry(i))/1E1);
%                         fprintf(fid1,'%12.6f %12d\n',double(lat(i))/1E6,nm);
%                         k=k+1;% statistic of valid point number 
                end
            end
            fclose(fid2);
%             fprintf (fid3,'%12s %12d\n',namelist(n,17:20),k);
        end
    end
end 
            fclose(fid1);
            fclose(fid3);
return 

