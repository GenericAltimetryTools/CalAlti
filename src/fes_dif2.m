%Calculate the tide difference between different locations.(One point is
%satellte altimter PCA point, another point is the tide station.)
%The input parameter is the sat and loc. The output is the tide difference
%between PCA and tide station.

% Call FES programs (Matlab)


function [tg_dif]=fes_dif2(sat,loc)


   if strcmp(loc,'bqly') || strcmp(loc,'qly')
       
        disp('loading qianliyan hy2b tide model')       
        fes=load('..\test\fes.qly_2b_ja_2011_2021');
        
        sat_day=fes(:,1)-fes(1,1); %ellipsed day      
        tg_fes=fes(:,2); % fes at tide gauge
        
        if sat==3
            load ..\test\hy2_check\pca_ssh.txt;
            sat_tg=fes(:,4); % FES 2014 tide£¬unit cm
        elseif sat==1
            load ..\test\ja2_check\pca_ssh.txt;
            sat_tg=fes(:,3); % FES 2014 tide£¬unit cm
        elseif sat==4
            load ..\test\ja3_check\pca_ssh.txt;
            sat_tg=fes(:,3); % FES 2014 tide£¬unit cm          
        end

    elseif strcmp(loc,'zmw') || strcmp(loc,'bzmw') || strcmp(loc,'bzmw2')
     
        disp('loading qianliyan hy2b tide model')       
        fes=load('..\test\fes.zmw_ja_2b_2011_2021');
        
        sat_day=fes(:,1)-fes(1,1); %ellipsed day      
        tg_fes=fes(:,2); % fes at tide gauge
        
        if sat==3 && strcmp(loc,'bzmw')
            load ..\test\hy2_check\pca_ssh.txt;
            sat_tg=fes(:,4); % FES 2014 tide£¬unit cm
        elseif sat==3 && strcmp(loc,'bzmw2')
            load ..\test\hy2_check\pca_ssh.txt;
            sat_tg=fes(:,5); % FES 2014 tide£¬unit cm            
        elseif sat==1
            load ..\test\ja2_check\pca_ssh.txt;
            sat_tg=fes(:,3); % FES 2014 tide£¬unit cm
        elseif sat==4
            load ..\test\ja3_check\pca_ssh.txt;
            sat_tg=fes(:,3); % FES 2014 tide£¬unit cm          
        end
   
    elseif strcmp(loc,'zhws') 
     
        disp('loading Zhuhaiwanshan Wailingding tide model')       

        
        if sat==3 
            fes=load('..\test\fes.zhws_hy2b_2019_2021');
            sat_day=fes(:,1)-fes(1,1); %ellipsed day      
            tg_fes=fes(:,2); % fes at tide gauge            
            load ..\test\hy2_check\pca_ssh.txt;
            sat_tg=fes(:,3); % FES 2014 tide£¬unit cm     
        elseif sat==4
            fes=load('..\test\fes.zhws_ja3_2019_2021');
            sat_day=fes(:,1)-fes(1,1); %ellipsed day      
            tg_fes=fes(:,2); % fes at tide gauge            
            load ..\test\ja3_check\pca_ssh.txt;
            sat_tg=fes(:,3); % FES 2014 tide£¬unit cm          
        end
        
    end
 
    pca_sec=pca_ssh(:,3);% PCA time refer to 2000-01-1 00:00:00
%     Transform the time reference of satellite pca time to the NAO
%     ellipsed day. Here should be carefull since the start time of NAO
%     maybe different.

    if (sat==1 || sat==4 || sat==3) && ~strcmp(loc,'zhws')
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % unit days.
    elseif sat==4 || sat==3 && strcmp(loc,'zhws') % zhws 2019-01-1 00:00:00
        disp('zhu hai wan shan')
        pca_day=pca_sec/86400-(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 
    end  
    
    % interp1 time to get tide model values at TG and PCA points.
    tg_pca_ssh=interp1(sat_day,sat_tg,pca_day,'PCHIP');
    tg_qly_ssh=interp1(sat_day,tg_fes,pca_day,'PCHIP');
    tg_dif=tg_pca_ssh-tg_qly_ssh;

return