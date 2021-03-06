%Calculate the tide difference between different locations.(One point is
%satellte altimter PCA point, another point is the tide station.)
%The input parameter is the sat and loc. The output is the tide difference
%between PCA and tide station.

function [tg_dif]=nao_dif(sat,loc)

% The `if` and `elseif` programs are not easy to read. I will improve this
% part later.

   if strcmp(loc,'qly') && sat==3
%         if 
            load .\qianliyan_tg_cal\hy2.nao2013
            load .\hy2_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2013
            sat_day=hy2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=hy2(:,2); % cm
%         end
   elseif strcmp(loc,'bqly') && sat==3
            load ..\test\hy2_check\hy2.nao2015_2021
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\qly.nao2015_2021 % same with J3
            disp('loading qianliyan hy2b tide model')
            sat_day=hy2(:,1); %日期的ellipsed day，
            sat_tg=hy2(:,2); % 预报潮汐tide，单位cm

   elseif strcmp(loc,'qly') && sat==1
            load ..\test\ja2_check\ja2.nao2011_2017 % 注意变换文件，对应不同的时期
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load ..\test\ja2_check\pca_ssh.txt;
            load ..\test\qly.nao2011_2017
%             load .\qianliyan_tg_cal\tg_FES2014.qly_ja2pca_2011_2017
            disp('loading qianliyan ja2 tide model')
            sat_day=ja2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja2(:,2); % 预报潮汐tide，单位cm
%             sat_tg=tg_FES2014(:,2);
%         end

   elseif strcmp(loc,'qly') && sat==2
            load .\qianliyan_tg_cal\saral.nao2011_2017
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2011_2017
            sat_day=saral(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=saral(:,2); % 预报潮汐tide，单位cm
%         end

    elseif strcmp(loc,'qly') && sat==4
            load ..\test\ja3_check\ja3.nao2015_2021 % jason-3和Jason-2可以共用一个潮汐预报文件
            load ..\test\ja3_check\pca_ssh.txt;
            load  ..\test\qly.nao2015_2021 % Input of the model tide at QLY
            % 注意变换文件，对应不同的时期,qly.nao2015_2017,qly.nao2013

            sat_day=ja3(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja3(:,2); % 预报潮汐tide，单位cm
       
    elseif strcmp(loc,'qly') && sat==5
            load ..\test\s3a_check\s3a.nao2015_2019 % jason-3和Jason-2可以共用一个潮汐预报文件
            load ..\test\s3a_check\pca_ssh.txt;
            load ..\test\qly.nao2015_2021 % 注意变换文件，对应不同的时期,qly.nao2015_2017
            sat_day=s3a(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=s3a(:,2); % 预报潮汐tide，单位cm
        
   elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==3
%        disp('TBD')
%        if 
            load .\qianliyan_tg_cal\hy2._cst_30km_fes
            load .\hy2_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\tg_FES2014.cst_saralpca_2011_2019;
            sat_day=hy2(:,1)-hy2(1,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=hy2(:,2); % 预报潮汐tide，单位cm
%         end

    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==1
            load .\qianliyan_tg_cal\ja2.nao2011_2017 % 注意变换文件，对应不同的时期
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load .\ja2_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2011_2017
            sat_day=ja2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja2(:,2); % 预报潮汐tide，单位cm
        

    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==2
            load .\qianliyan_tg_cal\saral.cst_2011_2019
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\cst.cst_2011_2019
            load .\qianliyan_tg_cal\tg_FES2014.cst_saralpca_2011_2019;
%           tg_FES2014.cst_saralpca_2011_2019 is provided by FU yanguang,using the fes2014model.
%           First column is the cst,second is the saral pca model value.
            
            sat_day=saral(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
%             sat_tg=saral(:,2); % 预报潮汐tide，单位cm
            sat_tg=tg_FES2014(:,2); % 预报潮汐tide，单位cm
%         end

    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==4
            load .\qianliyan_tg_cal\ja3.nao2015_2019 % jason-3和Jason-2可以共用一个潮汐预报文件
            load .\ja3_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2015_2019 % Input of the model tide at QLY
            % 注意变换文件，对应不同的时期,qly.nao2015_2017,qly.nao2013

            sat_day=ja3(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja3(:,2); % 预报潮汐tide，单位cm
%         end
    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==5
            tide=load ('.\qianliyan_tg_cal\fes_cst_s3a.txt');
            load .\s3a_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\tg_FES2014.cst_saralpca_2011_2019;
            sat_day=tide(:,1)-tide(1,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=tide(:,3); % 预报潮汐tide，单位cm
%         end
    elseif (strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')) && sat==1
%        if sat==1
            load ..\test\ja2_check\ja2.nao_zmw_2011_2021_25km % 注意变换文件，对应不同的时期
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.
            load ..\test\ja2_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
            sat_day=ja2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja2(:,2); % 预报潮汐tide，单位cm

       elseif sat==2 && strcmp(loc,'zmw735')
            load .\qianliyan_tg_cal\saral.nao_zmw_2011_2019_25km
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\zmw.nao_2011_2019_
           
            sat_day=saral(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=saral(:,2); % 预报潮汐tide，单位cm
%        end 
       elseif sat==2 && strcmp(loc,'zmw436')
            load .\qianliyan_tg_cal\saral.zmw_saral_436
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\zmw.nao_2011_2019_
           
            sat_day=saral(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=saral(:,2); % 预报潮汐tide，单位cm
%        end  
      elseif (strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')) && sat==4
            load ..\test\ja2_check\ja2.nao_zmw_2011_2021_25km % Jason3 is same with Jason-2 at zmw
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load ..\test\ja3_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
%             load ..\test\tg_FES2014.zmw_ja2pca_2011_2021
            sat_day=ja2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja2(:,2); % 预报潮汐tide，单位cm
%             sat_tg=tg_FES2014(:,3);% use the FES 2014 model
%       end 
      elseif (strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')) && sat==5
            load .\qianliyan_tg_cal\s3a.zmw_s3a_25km % 注意变换文件，对应不同的时期
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load .\s3a_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\zmw.nao_2011_2019_
            sat_day=s3a(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=s3a(:,2); % 预报潮汐tide，单位cm
%       end       
      elseif (strcmp(loc,'zmw') || strcmp(loc,'bzmw')) && sat==3 
            load ..\test\hy2_check\hy2.nao_2011_2021_ % contain time span of 2A (from 2011) and 2B (from 2018) 
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
            sat_day=hy2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=hy2(:,2); % 预报潮汐tide，单位cm
      elseif strcmp(loc,'bzmw2') && sat==3 
            load ..\test\hy2_check\hy2.nao_2011_2021_p190 % contain time span of 2A (from 2011) and 2B (from 2018) 
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
            sat_day=hy2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=hy2(:,2); % 预报潮汐tide，单位cm
      elseif strcmp(loc,'zhws') && sat==4
%        if
            load ..\test\ja3_check\ja3.nao_zhws %    
            load ..\test\ja3_check\pca_ssh.txt;
            load ..\test\zhws.nao_2019_2022
            sat_day=ja3(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=ja3(:,2); % 预报潮汐tide，单位cm
%        end
      elseif strcmp(loc,'zhws') &&  sat==3
            load ..\test\hy2_check\hy2.nao_zhws % 
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\zhiwan.nao_2019_2022
            sat_day=hy2(:,1); %日期的ellipsed day，单位日，起始时刻2013.1.1 00:00:00，结束2015.1.1 00:00:00
            sat_tg=hy2(:,2); % 预报潮汐tide，单位cm
%        end
    end
  
   if strcmp(loc,'qly') || strcmp(loc,'bqly')  % I only use the qly_tg to stand for the tg model value at tg station.
        qly_tg=qly(:,2);% NAO tide
%        qly_tg=tg_FES2014(:,1);
   elseif strcmp(loc,'cst') || strcmp(loc,'cst009')
%        qly_tg=cst(:,2);% NAO tide
         qly_tg=tg_FES2014(:,1);
   elseif strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436') || strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
        qly_tg=zmw(:,2);% NAO tide
%        qly_tg=tg_FES2014(:,2);% FES 2014 model. C2 is model for tide station.
   elseif strcmp(loc,'zhws') && sat==4
         qly_tg=zhws(:,2);%
   elseif strcmp(loc,'zhws') && sat==3
        qly_tg=zhiwan(:,2);%
   end
   
   
   
    pca_sec=pca_ssh(:,3);% PCA time (seconds) refer to 2000-01-1 00:00:00
%     Transform the time reference of satellite pca time to the NAO
%     ellipsed day. Here should be carefull since the start time of NAO
%     maybe different.

    if sat==1 || sat==2 % unit : day
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 注意变换年份，对应不同的时期  
    elseif sat==5 || sat == 4 && strcmp(loc,'qly') % 
        pca_day=pca_sec/86400-(datenum('2015-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 注意变换年份，对应不同的时期 
    elseif sat==3 && strcmp(loc,'bqly')
        pca_day=pca_sec/86400-(datenum('2015-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 注意变换年份，对应不同的时期         
    elseif sat==3 && strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 注意变换年份，对应不同的时期                 
    elseif sat == 4 && strcmp(loc,'zmw') % 
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); %    
    elseif sat==3 && strcmp(loc,'qly') || strcmp(loc,'cst009')
        pca_day=pca_sec/86400-(datenum('2013-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 注意变换年份，对应不同的时期 
    elseif sat==3 && strcmp(loc,'zmw')
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 注意变换年份，对应不同的时期 
    elseif sat==4 && strcmp(loc,'zhws') % zhws 2019-01-1 00:00:00
        disp('zhu hai wan shan')
        pca_day=pca_sec/86400-(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 
    elseif sat==3 && strcmp(loc,'zhws') % zhws 2019-01-1 00:00:00
        disp('zhu hai wan shan')
        pca_day=pca_sec/86400-(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); %         
    end
    
    % *&&&&&*&*&*&*&
    
    % 插值处pca_day的千里岩和定标点预报潮汐
%     figure(1234);plot(sat_day(1:2000),sat_tg(1:2000));hold on;plot(sat_day(1:2000),qly_tg(1:2000));hold off
    tg_pca_ssh=interp1(sat_day,sat_tg,pca_day,'PCHIP');
    tg_qly_ssh=interp1(sat_day,qly_tg,pca_day,'PCHIP');
    tg_dif=tg_pca_ssh-tg_qly_ssh;

return