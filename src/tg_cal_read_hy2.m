function tg_cal_read_hy2(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0)


fid3 = fopen('..\test\hy2_check\ponits_number.txt','w');
fid1 = fopen('..\test\hy2_check\ponits_circle.txt','w');

% fid2 = fopen('.\hy2output\hy2_all_p147.xys','w');
% fprintf(fid2,'%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s \n', ...
%         'lon','lat','r_ku','alt','dry','wet','ino','ssb','inv','lod','set','pt','ots','hff');

for nm=min_cir:max_cir
%     dir_0='J:\hy2\IGDR\0';
    temp1=check_circle(nm);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    temp3=temp2(2:5);% 组成三位数的字符串。
    dir_nm=strcat(dir_0,temp3,'\') % 输出文件夹名称
    
    namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
    for  n=1:length(namelist)
        t1=str2double(namelist(n,24:26));
        if t1==pass_num % here is pass which you need to output data;009;147
            filepath=strcat(dir_nm,namelist(n,1:61));
            nc=netcdf.open(filepath,'NC_NOWRITE');
            lat=netcdf.getVar(nc,6);%10-6度
            lon=netcdf.getVar(nc,7);%10-6度
            time=netcdf.getVar(nc,0);%10-6度
            alt=netcdf.getVar(nc,44);%10-3m
            r_ku=netcdf.getVar(nc,47);%10-3m
            dry=netcdf.getVar(nc,61);%10-4m
%             wet=netcdf.getVar(nc,29);%10-4m,rad
            wet=netcdf.getVar(nc,62);%10-4m,model
            ino=netcdf.getVar(nc,64);%10-4m,alt_ku
            % ino=netcdf.getVar(nc,32);%10-4m,model_bent
            ssb=netcdf.getVar(nc,66);% sea state bias,10-4m
            inv=netcdf.getVar(nc,109);%inv_bar_corr ,10-4m
            hff=netcdf.getVar(nc,100);%hf_fluctuations_corr ,10-4m
            ots=netcdf.getVar(nc,111);%ocean tide sole1,10-4m
            set=netcdf.getVar(nc,117);%solid earth tide,10-4m
            pt=netcdf.getVar(nc,118); %pole tide,10-4m
            mss=netcdf.getVar(nc,105); %
            lod=netcdf.getVar(nc,115); % load_tide_sol1 
            % 下面的字段是数据筛选所用
%             surf_t=netcdf.getVar(nc,3); %surface_type
%             rain_f=netcdf.getVar(nc,87);%rain_flag 
%             ice_f=netcdf.getVar(nc,88);%rain_flag 
            r_rms=netcdf.getVar(nc,53);%range_rms_ku
            swh=netcdf.getVar(nc,68);% swh_ku
%             wnd=netcdf.getVar(nc,81);% wind speed alti
%             sig=netcdf.getVar(nc,44);%sig0_ku 
%             sig0_rms=netcdf.getVar(nc,46);%sig0_ku 
%             off_nd_ag=netcdf.getVar(nc,60);
%             bath=netcdf.getVar(nc,68);%
            % 下面是HY-2特有的，改正距离值
%             cog=netcdf.getVar(nc,105);%cog_corr
%             inp=netcdf.getVar(nc,106);%内部延迟
%             dop=netcdf.getVar(nc,107);%多普勒延迟
%             mor=netcdf.getVar(nc,108);%模型化的仪器距离改正
%             net_i=netcdf.getVar(nc,25);%net_instr_corr_ku
            netcdf.close(nc)
            
            outfile=strcat('..\test\hy2_check\',namelist(n,18:26),'.dat');% 只取周期和pass编号
            fid2 = fopen(outfile,'w');
%             outfile2=strcat('..\test\hy2_check\',namelist(n,18:26),'.all');% 只取周期和pass编号
%             fid4 = fopen(outfile2,'w');
            
%             fprintf(fid4,'%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s \n', ...
%                     'lon','lat','r_ku','alt','dry','wet','ino','ssb','inv','lod','set','pt','ots','hff');
            k=0;
            for i=1:length(lon)
                % ssh_i: no ocean tide (but ocean loading tide) and used for VAL with tide gauge
                % data; sla is the sla;ssh: added full ocean tide.
                ssh_i=double(alt(i)-r_ku(i))/10000- ...
                double(ino(i)+ssb(i)+set(i)+pt(i))/1E4 ...
                - double(lod(i))/1E4-double(dry(i)+wet(i))/1E4; % -...
                %; % double(cog(i))/1E4-double(inp(i))/1E4-double(dop(i))/1E4。double(net_i(i))/1E4
                sla=double(alt(i)-r_ku(i)-mss(i))/10000- ...
                double(ino(i)+ssb(i)+set(i)+pt(i))/1E4 ...
                - double(ots(i))/1E4-double(dry(i)+wet(i)+inv(i))/1E4;
            
                ssh=double(alt(i)-r_ku(i))/10000- ...
                double(ino(i)+ssb(i)+set(i)+pt(i))/1E4 ...
                - double(ots(i))/1E4-double(dry(i)+wet(i)+inv(i))/1E4; %-...
%                 double(cog(i))/1E4-double(inp(i))/1E4-double(dop(i))/1E4;
            
                 if (((lat(i))<max_lat &&(lat(i))> min_lat) && ((alt(i)-r_ku(i))>-1300000 && (alt(i)-r_ku(i)) < 1000000) && ...
                         (-25000<=dry(i) && dry(i)<=-19000)&& (-5000<=wet(i)&&wet(i)<=-10) ) %&& (0<=ssh&&ssh<=100)

                    fprintf(fid2,'%12.6f %12.6f %12.6f %12.6f %12.6f %12.6f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),ssh_i,ssh,sla);
                    fprintf(fid1,'%12.6f %12d\n',double(lat(i))/1E6,nm);
                    k=k+1;% statistic of valid point number 
                 end
            
            end
            fclose(fid2);
%             fclose(fid4);
            fprintf (fid3,'%12s %12d\n',namelist(n,18:21),k);
        end
    end
end
    fclose('all');
    %加条件，判断,编辑准则参考HY-2数据格式说明和Jason-2数据手册
%     
%     if( (lat(i)<36700000) && (lat(i)>36000000) && (surf_t(i)==0) ...
%          && (0<=r_rms(i) && r_rms(i)<=2000)...
%          && ((alt(i)-r_ku(i))>-1300000 && (alt(i)-r_ku(i)) < 1000000)...
%          && (-25000<=dry(i) && dry(i)<=-19000)&& (-5000<=wet(i)&&wet(i)<=-10)  && (-4000<=ino(i)&&ino(i)<=400)...
%          && (-5000<=ssb(i)&&ssb(i)<=0)...
%          && (-50000<=ots(i)&&ots(i)<=50000) && (-10000<=set(i)&&set(i)<=10000) &&  (-1500<=pt(i)&&pt(i)<=1500)...
%          && (sig0_rms(i)<=100) && (700<sig(i)&&sig(i)<3000) && (wnd(i)>0 && wnd(i)< 3000)...
%          && (0<=swh(i)&&swh(i)<=11000) && (-2000<=off_nd_ag(i)&&off_nd_ag(i)<=6400))
%         
% *************************************************************************
% *************************************************************************
% 
% load .\hy2_check\ponits_circle.txt
% load  .\hy2_check\ponits_number.txt
% 
% latitude=ponits_circle(:,1);
% points=ponits_circle(:,2);
% cir_number=ponits_number(:,2);
% circle=ponits_number(:,1);
% 
% figure(21);
% hold on
% 
% plot(latitude,points,'o')
% xlabel('纬度/°')
% ylabel('卫星周期')
% ylim([min(points) max(points)]);
% xlim([min_lat/1E6 max_lat/1E6])
% 
% for i=1:length(circle)
% text(36.48,circle(i),num2str(cir_number(i)),'FontSize',10)
% end
% 
% grid on
% hold off

return
