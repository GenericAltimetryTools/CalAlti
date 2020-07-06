% ###############################################
% Read the 1Hz Sentinel-3 data (Marine standard)
% output the SSH around the CAL site

function tg_cal_read_s3a(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0)

fid3 = fopen('..\test\s3a_check\ponits_number.txt','w'); % contains the number of valid data points
fid1 = fopen('..\test\s3a_check\ponits_circle.txt','w'); % contains the latitude and the cycle No.

temp1=dir_name(dir_0);% Get the S3A directory names   
dir_nm=strcat(dir_0,temp1,'\'); % directory plus \  

temp=size(dir_nm);
file_num=temp(1); % The numbers of the directory 

for n=1:file_num

    t1=str2double(temp1(n,74:76));% Find the number of the pass, and determine if it passes the CAL site
    t2=str2double(temp1(n,70:72));% The number of the cycle

    if (t2<=max_cir && t2>=min_cir)
    if t1==pass_num % here is pass input from the reads3a_cal_select_site.m program
        filepath = fullfile(dir_nm(n,:),'standard_measurement.nc')% 这里ls可以和dir替换
        nc=netcdf.open(filepath,'NC_NOWRITE');
        
        % Begin the reading of S3A GDR data.
        time=netcdf.getVar(nc,0);%10-6度

        lat=netcdf.getVar(nc,11);%10-6度
        lon=netcdf.getVar(nc,12);%10-6度
        alt=netcdf.getVar(nc,31);%10-3m
        r_ku=netcdf.getVar(nc,46);%10-3m
        r_ku_plrm=netcdf.getVar(nc,48);%10-3m

        if t2<27
%                 cycle 27 has been changed the location of parameters. But
%                 this is not only because the baseline change Since
%                 baseline was changed after cycle 24. cycle 24 25 26 has
%                 the same parameter location with the baseline 002.
            dry=netcdf.getVar(nc,154);%10-4m
            dry_mean=netcdf.getVar(nc,155);%10-4m
            wet=netcdf.getVar(nc,160);%10-4m
            wet_m_zero=netcdf.getVar(nc,156);%10-4m，模型值，用于陆地。
            ino=netcdf.getVar(nc,164);%10-4m

            ssb=netcdf.getVar(nc,169);% sea state bias,10-4m
            inv=netcdf.getVar(nc,188);%inv_bar_corr ,10-4m
            hff=netcdf.getVar(nc,189);%hf_fluctuations_corr ,10-4m
            ots=netcdf.getVar(nc,190);%ocean tide sole1,10-4m     
            set=netcdf.getVar(nc,196);%solid earth tide,10-4m
            pt=netcdf.getVar(nc,197); %pole tide,10-4m
            olt=netcdf.getVar(nc,194); %ocean load tide,10-4m
            mss=netcdf.getVar(nc,175); %mean_sea_surface,10-4m
            god=netcdf.getVar(nc,186); % geoid ,10-4m

            % For data filter
            surf_t=netcdf.getVar(nc,21); %surface_type
            r_rms=netcdf.getVar(nc,58);%range_rms_ku
            swh=netcdf.getVar(nc,83);% swh_ku
            wnd=netcdf.getVar(nc,206);% wind speed alti
            sig=netcdf.getVar(nc,65);%sig0_ku 
            r_nums=netcdf.getVar(nc,61);% 
            sig0_rms=netcdf.getVar(nc,77);% 
            sig0_num=netcdf.getVar(nc,80);% 
%             off_nd_ag=netcdf.getVar(nc,62);% 
            bathy=netcdf.getVar(nc,187);%
        elseif t2>=27
            dry=netcdf.getVar(nc,155);%10-4m
            dry_mean=netcdf.getVar(nc,156);%10-4m
            wet=netcdf.getVar(nc,161);%10-4m
            wet_m_zero=netcdf.getVar(nc,157);%10-4m，模型值，用于陆地。
            ino=netcdf.getVar(nc,165);%10-4m

            ssb=netcdf.getVar(nc,170);% sea state bias,10-4m
            inv=netcdf.getVar(nc,189);%inv_bar_corr ,10-4m
            hff=netcdf.getVar(nc,190);%hf_fluctuations_corr ,10-4m
            ots=netcdf.getVar(nc,191);%ocean tide sole1,10-4m     
            set=netcdf.getVar(nc,197);%solid earth tide,10-4m
            pt=netcdf.getVar(nc,198); %pole tide,10-4m
            olt=netcdf.getVar(nc,195); %ocean load tide,10-4m
            mss=netcdf.getVar(nc,176); %mean_sea_surface,10-4m
            god=netcdf.getVar(nc,187); % geoid ,10-4m

            % For data filter
            surf_t=netcdf.getVar(nc,21); %surface_type
            r_rms=netcdf.getVar(nc,58);%range_rms_ku
            swh=netcdf.getVar(nc,83);% swh_ku
            wnd=netcdf.getVar(nc,207);% wind speed alti
            sig=netcdf.getVar(nc,65);%sig0_ku 
            r_nums=netcdf.getVar(nc,61);% 
            sig0_rms=netcdf.getVar(nc,77);% 
            sig0_num=netcdf.getVar(nc,80);% 
%             off_nd_ag=netcdf.getVar(nc,62);% 
            bathy=netcdf.getVar(nc,188);%
        end
        
        netcdf.close(nc)
        
        % check the required directory 
        if exist('..\test\s3a_check\','dir')==0
           disp('creat new dir to save the temp files') 
           mkdir('..\test\s3a_check\');
        end

        outfile=strcat('..\test\s3a_check\',temp1(n,70:76),'.dat');% 只取周期和pass编号
        fid2 = fopen(outfile,'w');
        outfile=strcat('..\test\s3a_check\',temp1(n,70:76),'.d');% 只取周期和pass编号
        fid20 = fopen(outfile,'w');

        k=0;
        if t2<27
            % write the header
            fprintf(fid20,'%12s %12s %12s  %12s %12s %12s %12s %12s %12s %12s %12s\n','lon','lat','tim','inv','dry','wet','ots','pt','set','ssb','ino');
            for i=1:length(lon)
%                 whos
                ssh=double(alt(i)-r_ku(i))/10000- ...
                    double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4; % SSH is the stable measurements for geodesy, oceanography..
                sla=double(alt(i)-r_ku(i)-mss(i))/10000- ...
                    double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;
                ssh_i=double(alt(i)-r_ku(i))/10000- ...
                    double(dry(i)+wet(i)+ino(i)+ssb(i)+set(i)+olt(i)+pt(i))/1E4; % ssh_i is used for CAL.(No tide correction and inv)
                % write the key
                % parameters (location,time,range,corrections...).
                if(((lat(i))<max_lat &&(lat(i))> min_lat))
                       fprintf(fid20,'%12.6f %12.6f %12.6f  %12.6f %12.6f %12.8f %12.6f %12.6f %12.8f %12.6f %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),double(inv(i))/1E4,double(dry(i))/1E4,double(wet(i))/1E4,double(ots(i))/1E4,double(pt(i))/1E4,double(set(i))/1E4,double(ssb(i))/1E4,double(ino(i))/1E4);%W%WGS-84椭球
                end
                % restrict selection
                if(((lat(i))<max_lat &&(lat(i))> min_lat) && (surf_t(i)==0)  && (0<=r_rms(i) && r_rms(i)<=2000) ...
                    && ((alt(i)-r_ku(i))>-1300000 && (alt(i)-r_ku(i)) < 1000000) ...
                    && (-25000<=dry(i) && dry(i)<=-19000)&& (-5000<=wet(i)&&wet(i)<=-10)  && (-4000<=ino(i)&&ino(i)<=400)......
                    && (-5000<=ssb(i)&&ssb(i)<=0)...
                    && (-50000<=ots(i)&&ots(i)<=50000) && (-10000<=set(i)&&set(i)<=10000) &&  (-1500<=pt(i)&&pt(i)<=1500) ...
                    && (sig0_rms(i)<=100) && (700<sig(i)&&sig(i)<3000) && (wnd(i)>0 && wnd(i)< 3000) ...
                    && (0<=swh(i)&&swh(i)<=11000))
                        % write out the SSH,SLA
                        fprintf(fid2,'%12.6f %12.6f %12.6f  %12.6f %12.6f %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),ssh_i,ssh,sla);%WGS-84椭球
                        fprintf(fid1,'%12.6f %12d\n',double(lat(i))/1E6,t2);
                        k=k+1;% statistic of valid point number 
                end
            end


        elseif t2>=27
%                 whos
            fprintf(fid20,'%12s %12s %12s  %12s %12s %12s %12s %12s %12s %12s %12s\n','lon','lat','tim','inv','dry','wet','ots','pt','set','ssb','ino');
            le=length(lon);
%             info=['The length  of data:',num2str(le)];
%             disp(info)
            for i=1:length(lon)

                ssh=double(alt(i)-r_ku(i))/10000- ...
                    double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;
                sla=double(alt(i)-r_ku(i)-mss(i))/10000- ...
                    double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;
                ssh_i=double(alt(i)-r_ku(i))/10000- ...
                    double(dry(i)+wet(i)+ino(i)+ssb(i)+set(i)+olt(i)+pt(i))/1E4;

                if(((lat(i))<max_lat &&(lat(i))> min_lat))
                       fprintf(fid20,'%12.6f %12.6f %12.6f  %12.6f %12.6f %12.8f %12.6f %12.6f %12.8f %12.6f %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),double(inv(i))/1E4,double(dry(i))/1E4,double(wet(i))/1E4,double(ots(i))/1E4,double(pt(i))/1E4,double(set(i))/1E4,double(ssb(i))/1E4,double(ino(i))/1E4);%WGS-84椭球
                end
%                     test the sentinel3-A 003 baseline data. After cycle
%                     27 there has a reading error of the standard file.
%                     The Inv parameter has been changed to int32 from
%                     int16 in 002 baseline before cycle 27. 


                if(((lat(i))<max_lat &&(lat(i))> min_lat) && (surf_t(i)==0)  && (0<=r_rms(i) && r_rms(i)<=2000) ...
                    && ((alt(i)-r_ku(i))>-1300000 && (alt(i)-r_ku(i)) < 1000000) ...
                    && (-25000<=dry(i) && dry(i)<=-19000)&& (-5000<=wet(i)&&wet(i)<=-10)  && (-4000<=ino(i)&&ino(i)<=400)......
                    && (-5000<=ssb(i)&&ssb(i)<=0)...
                    && (-50000<=ots(i)&&ots(i)<=50000) && (-10000<=set(i)&&set(i)<=10000) &&  (-1500<=pt(i)&&pt(i)<=1500) ...
                    && (sig0_rms(i)<=100) && (700<sig(i)&&sig(i)<3000) && (wnd(i)>0 && wnd(i)< 3000) ...
                    && (0<=swh(i)&&swh(i)<=11000))

                        fprintf(fid2,'%12.6f %12.6f %12.6f  %12.6f %12.6f %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),ssh_i,ssh,sla);%WGS-84椭球
                        fprintf(fid1,'%12.6f %12d\n',double(lat(i))/1E6,t2);
                        k=k+1;% statistic of valid point number 

                end
            end
        end

        fclose(fid2);fclose(fid20);
        fprintf (fid3,'%12s %12d\n',temp1(n,70:76),k);
    end
    end
end

fclose('all');

return