% This Fuction  aims to calculate SSH of Tide Gauge at the PCA time of
% satellite altimetry. Then the bias of SA could be easily estimated by
% make SSH difference between tide gauge and SA (after adding corrections) 
% The SA time unit is second, and the reference time for SA is 2000-1-1
% 00:00:00.
% The tide gauge data is provided from China Oceanic Information Network.
% Here the QianLiYan TG data is the input data, which spans from
% 2011-2018. 
% The output of the tide model of NAO, a fortran program, is used here for
% correcting tide difference between different location. 

% This program is wrote by YangLei at FIO,MNR of China.

% Basic steps:
% 1,Read TG data
% 2,Read PCA time of the satellite altimter (unit s, refer to 2000-1-1 00:00:00)
% 3,Determine the SSH of tide gauge station at the PCA time.(interpolate)
% 4,Read tide correction from NAO model.
% 5,Save result.

function [bias2]=tg_pca_ssh(sat,fre,loc)
    if strcmp(loc,'cst') || strcmp(loc,'cst009')
        disp('cst')
        filename = 'J:\成山头验潮\CST_sort_clean.DD'; 
    elseif strcmp(loc,'qly')
        disp('qly')
        filename = '..\tg_xinxizx\qly\QLY_2011_2018_clean.txt';
    elseif strcmp(loc,'zmw735') || strcmp(loc,'zmw436') || strcmp(loc,'zmw')
        filename = 'J:\芷锚湾潮汐\ZMW_sort_clean.DD';
    end
    
    
%     filename = 'J:\千里岩二次定标\qlytg\tg_new_201501_201712.txt';
    disp(['loading TG file:',filename])
    disp('loading........................................................')
    tg=load (filename);
	%\千里岩潮汐\QLY201301_201412.txt    I:\千里岩二次定标\qlytg\tg_new_201501_201703.txt tg_new_201501_201712.txt
	% 一共有三个潮汐文件。注意替换，下面也要修改参考时间。
    
    % Time of tide data 
    tmp000=tg;
    tmp1=tmp000(:,1);
    tmp2=tmp000(:,2);
    tmp=num2str(tmp1);
    yyyy=str2num(tmp(:,1:4));
    mm=str2num(tmp(:,5:6));
    dd=str2num(tmp(:,7:8));
    hh=str2num(tmp(:,9:10));
    ff=str2num(tmp(:,11:12));
    ss(1:length(ff))=0;
    ss=ss';
    
    date_yj = [yyyy  mm dd hh ff ss];
    disp('Finish loading of real TG data')
    if strcmp(loc,'qly')        
        ssh=tmp000(:,2)/100+7.502;% 7.502 is the parameter of height reference 
    % transform from TG local to WGS-84.
    elseif strcmp(loc,'cst') || strcmp(loc,'cst009')
        ssh=tmp000(:,2)/100+10.632;% 10.632 is the parameter of height reference 
    % transform from TG local to WGS-84.
    elseif strcmp(loc,'zmw') || strcmp(loc,'zmw735') ||  strcmp(loc,'zmw436')
        ssh=tmp000(:,2)/100-0.108;% 10.632 is the parameter of height reference 
    % transform from TG local to WGS-84. TBD
    end
    
    t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);%时间格式转，卫星的参考时间是2000-01-1 00:00:00。
    % The time zone of TG in China is Zone 8, Thus 8 hours should be
    % subtracted from TG data.
    tm2=round(t3*86400);% 这是验潮的时间，UTC
    disp('Finish time reference transform of real TG data')
    
    if sat==1
            load ..\test\ja2_check\pca_ssh.txt;
		elseif sat==2
            load .\saral_check\pca_ssh.txt;
        elseif sat==3
            load .\hy2_check\pca_ssh.txt;
		elseif sat==4
			load .\ja3_check\pca_ssh.txt;
        elseif sat==5
            load ..\test\s3a_check\pca_ssh.txt;
    end
	
    
	pca_tim=round(pca_ssh(:,3));% This is time of SA, as Jason-2&3,etc,.
    ssh_ali=pca_ssh(:,4); % SSH of SA
    b=length(ssh_ali); % SA len, the number of SA cycles
    c=length(ff); % TG len
    
    tmp3(1:b)=0; % zero Array, save location of the time of PCA points 
    % saved in pca_ssh.txt .
    tmp3=tmp3';
    
    % 循环，寻找卫星过境的验潮站前后时刻。As data interval, SA is 1 sec and TG is 10 secs.
    for i=1:b
        n=0;
        for j=1:c-1
            
            if((pca_tim(i)<tm2(j+1)) && (pca_tim(i)>tm2(j)) || (pca_tim(i)==tm2(j)))
                n=j;
%                 break
                continue
            end

        end
        % 注意 潮汐数据的有效性检验。9998,9989是无效值。		
        tmp3(i)=n;% 存储验潮数据对应时间的位置
    end
    disp('Finish time selection of TG based on PCA time')
    
    % 下面是拟合，计算过境时刻的TG的SSH
    tg_pca_ssh(1:b)=0;% 保存TG的PCA SSH值
    for i=1:b
        if tmp3(i)~=0
            loct=tmp3(i);
            ssh_tg2=ssh(loct-12:loct+12); % 截取验潮站这一时间前后各2小时的数据，即前后各12个数据。
            ssh_tg3=smooth(ssh_tg2,4,'rlowess'); % Here should be carefull 
            % to set the smooth algrithm. like the span and methods
            tt=tm2(loct-12:loct+12);
            t_pca=pca_tim(i);
            tg_pca_ssh(i)=interp1(tt,ssh_tg3,t_pca,'PCHIP');
        end
    end
    disp('Finish interpolation of TG SSH at PCA')
    % test interp and smooth
    % plot(tt,ssh_tg2,'-bo',tt,ssh_tg3,'-rs',t_pca,tg_pca_ssh(b),'bs','MarkerSize',10)
    
    % 计算绝对偏差
    
    % First, the DTU MSS model is used to get the MSS value at the PCA
    % points. This step was done by the GMT track program and data was
    % saved in the *.dat file. Then, the *.dat file will be read in the
    % follwing codes. Be carefull that length of *.dat is based on the input
    % file of pca_ssh.txt. In the *.dat file, the first line is the MSS at
    % the TG points, and the left lines are corresponding to the PCA
    % points. Thus, make the subtraction and get the MSS correction. 
    if strcmp(loc,'qly')
        if sat==1
            mss=load ('..\test\ja2_check\dtu18_qly.dat');
            jason2_mss=mss;
            tg_mss=jason2_mss(1,3);
            jason_mss=jason2_mss(2:length(jason2_mss),3);
            mss_correction=-(jason_mss-tg_mss); % this is the needed parameter.

        elseif ((sat==2) && (fre==40))

            mss=load ('.\qianliyan_tg_cal\saral40_qly.dat');
            tg_mss=mss(1,3);
            saral_mss=mss(2:length(mss),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==2) && (fre==1))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18.dat'); % 注意替换dat文件名
            saral_m=mss;
            tg_mss=saral_m(1,3);
            saral_mss=saral_m(2:length(saral_m),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==3) && (fre==1))

            hy2=load ('.\qianliyan_tg_cal\hy2_dtu18_qly.dat');
            tg_mss=hy2(1,3);
            saral_mss=hy2(2:length(hy2),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif sat==4
            ja3 = load ('.\qianliyan_tg_cal\jason3_2016_2018_dtu18.dat');% Ja3.
            jason3_mss=ja3;
            tg_mss=jason3_mss(1,3);
            jason_mss=jason3_mss(2:length(jason3_mss),3);
            mss_correction=-(jason_mss-tg_mss);

        elseif sat==5
            mss=load ('..\test\s3a_check\dtu18_qly.dat');% 注意替换，jason-2.dat是对应的2013-2014，jason2_2011是对应的2011-2012.
            s3a_mss=mss;
            tg_mss=s3a_mss(1,3);
            s3a_mss=s3a_mss(2:length(s3a_mss),3);
            mss_correction=-(s3a_mss-tg_mss);
        end
        
    elseif strcmp(loc,'cst') || strcmp(loc,'cst009')
        if sat==1
            mss=load ('.\qianliyan_tg_cal\jason2_2011_2017_dtu18.dat');
            jason2_mss=mss;
            tg_mss=jason2_mss(1,3);
            jason_mss=jason2_mss(2:length(jason2_mss),3);
            mss_correction=-(jason_mss-tg_mss); % this is the needed parameter.

        elseif ((sat==2) && (fre==40))

            load .\qianliyan_tg_cal\saral40.dat;
            tg_mss=saral40(1,3);
            saral_mss=saral40(2:length(saral40),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==2) && (fre==1))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18_cst.dat'); % 注意替换dat文件名
            saral_m=mss;
            tg_mss=saral_m(1,3);
            saral_mss=saral_m(2:length(saral_m),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==3) && (fre==1))

            hy2=load ('.\qianliyan_tg_cal\hy2_cst_dtu18.dat');
            tg_mss=hy2(1,3);
            saral_mss=hy2(2:length(hy2),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif sat==4
            ja3 = load ('.\qianliyan_tg_cal\jason3_2016_2018_dtu18.dat');% Ja3.
            jason3_mss=ja3;
            tg_mss=jason3_mss(1,3);
            jason_mss=jason3_mss(2:length(jason3_mss),3);
            mss_correction=-(jason_mss-tg_mss);

        elseif sat==5
            mss=load ('.\qianliyan_tg_cal\s3a_2019_dtu18_cst.dat');% 注意替换，jason-2.dat是对应的2013-2014，jason2_2011是对应的2011-2012.
            s3a_mss=mss;
            tg_mss=s3a_mss(1,3);
            s3a_mss=s3a_mss(2:length(s3a_mss),3);
            mss_correction=-(s3a_mss-tg_mss);
        end
    elseif strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')
        if sat==1
            mss=load ('.\qianliyan_tg_cal\jason2_2011_2017_dtu18_zmw.dat');
            jason2_mss=mss;
            tg_mss=jason2_mss(1,3);
            jason_mss=jason2_mss(2:length(jason2_mss),3);
            mss_correction=-(jason_mss-tg_mss); % this is the needed parameter.

        elseif ((sat==2) && (fre==40))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18_zmw735.dat');
            tg_mss=mss(1,3);
            saral_mss=mss(2:length(mss),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==2) && (fre==1))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18_zmw735.dat'); % 注意替换dat文件名
            saral_m=mss;
            tg_mss=saral_m(1,3);
            saral_mss=saral_m(2:length(saral_m),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==3) && (fre==1))

            hy2=load ('.\qianliyan_tg_cal\hy2_zmw_dtu18.dat');
            tg_mss=hy2(1,3);
            saral_mss=hy2(2:length(hy2),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif sat==4
            ja3 = load ('.\qianliyan_tg_cal\ja3_all_dtu18_zmw.dat');% Ja3.
            jason3_mss=ja3;
            tg_mss=jason3_mss(1,3);
            jason_mss=jason3_mss(2:length(jason3_mss),3);
            mss_correction=-(jason_mss-tg_mss);

        elseif sat==5
            mss=load ('.\qianliyan_tg_cal\s3a_2019_dtu18_zmw.dat');% 注意替换，jason-2.dat是对应的2013-2014，jason2_2011是对应的2011-2012.
            s3a_mss=mss;
            tg_mss=s3a_mss(1,3);
            s3a_mss=s3a_mss(2:length(s3a_mss),3);
            mss_correction=-(s3a_mss-tg_mss);
        end
    end    
    disp('Finish DTU MSS correction,MEAN:')
    mean(mss_correction)
    disp('Begin NAO file loading and correction')  
%         =================================================================
%         plot(mss_correction,'-o'); % look at this figure, a repeat cycle
%         is very clear, which means the orbit of SA is controled by
%         something.

%         plot(pca_ssh(:,1)); % latitude or longitude of SA movements in a
%         repeated cycle.  
%         =================================================================

%         bias(1:length(ssh_ali))=0;
%     for i=1:length(ssh_ali)
%         bias(i)=ssh_ali(i)-tg_pca_ssh(i)-0.7179+mss_correction(i);
%     end
%     
%     tg_pca_ssh2=tg_pca_ssh';

    [tg_dif]=nao_dif(sat,loc);% 潮汐改正

    mean_tg_dif=mean(tg_dif);
    
    disp(['mean_tg_dif(cm):',num2str(mean_tg_dif)]);
    disp('Finish NAO file loading and correction') 
    disp('Begain calculate the bias of SA by adding NAO and MSS correction')
%     disp('The parameters size are:')
%     whos
    
    if sat==5
        bias=ssh_ali-(tg_pca_ssh')+mss_correction-tg_dif/100;
%       Sentinel-3 height reference is WGS-84,which is not the same with
%       other SA missions. The unit of bias is m
    else
        bias=ssh_ali-(tg_pca_ssh')-0.7179+mss_correction-tg_dif/100; %-tg_dif/100
%         Height reference for other SA missions is T/P which has a 0.7179m
%         transtorm difference with WGS-84 (TG reference). This value could
%         be calculated by program wgs_tp.m.
    end

    disp('Finish bias calculation')
    
    tmpp=bias;
    ttt=pca_ssh(:,5); % cycle number
    tim2=pca_ssh(:,3); % time in seconds
    
%     [tmpp,ttt]=three_sigma_delete(tmpp,ttt);
    bias2=[ttt tmpp tim2];
%     save_data=[ssh_ali tg_pca_ssh2 mss_correction bias];
%     save jason_2_bias_new_all.txt save_data -ASCII % 保存结果数据

return