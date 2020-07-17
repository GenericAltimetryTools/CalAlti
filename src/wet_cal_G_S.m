% calculate the difference of the wet delay between the GNSS and the
% radiomater

function [bias2]=wet_cal_G_S(sat,loc)

    if strcmp(loc,'sdyt')
        gnss_wet=load ('..\test\gnss_wet\troSDYT.d3');
    end

    tmp000=gnss_wet;
    y_0=floor(tmp000(:,1));
    da=tmp000(:,1)-y_0;
    z_delay=tmp000(:,3);  
    % time to second

    for i=2000:2030
       date_yj=[i 1 1 0 0 0];
       y_sec(i)=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
    end

    sec=y_sec(y_0)'+da*366*24*60*60;% 时间转为秒，以2010-1-1-0-0-0为基准
%     datestr (sec(1)/(24*3600)+datenum('2000-01-01 00:00:00.0'));validate
%     the time transform. It should be the first data time of the GNSS wet
%     delay.
    
    g_w=z_delay;
    tm2=round(sec); % GNSS
    
	
    if sat==1
            load ..\test\ja2_check\pca_wet.txt;
		elseif sat==2
            load .\saral_check\pca_wet.txt;
        elseif sat==3
            load .\hy2_check\pca_wet.txt;
		elseif sat==4
			load ..\test\ja3_check\pca_wet.txt;
    end
	
    
	pca_tim=round(pca_wet(:,3));% 这是Jason-2的时间
%     datestr (pca_tim(1)/(24*3600)+datenum('2000-01-01 00:00:00.0'));validate
%     the time transform. It should be the first data time of the satellite wet
%     delay.

    w_ali=pca_wet(:,4);
    b=length(w_ali); % radiomater
    c=length(tm2); %G NSS
    tmp3(1:b)=0;
    % 循环，寻找卫星过境的验潮站前后时刻。
    for i=1:b
        n=0;
        for j=1:c-1
            
            if((pca_tim(i)<tm2(j+1)) && (pca_tim(i)>tm2(j)) || (pca_tim(i)==tm2(j)))
                n=j;
            end

        end
        tmp3(i)=n;% 存储位置
    end
    
    % 下面是拟合
    tg_pca_ssh(1:b)=0;% 保存TG的PCA wet delay值
    for i=1:b
        if tmp3(i)~=0
            loct=tmp3(i);
            ssh_tg2=g_w(loct-1:loct+1);%  Three hours
%             ssh_tg3=smooth(ssh_tg2,2,'rlowess');
            tt=tm2(loct-1:loct+1);
            t_pca=pca_tim(i);
            tg_pca_ssh(i)=interp1(tt,ssh_tg2,t_pca,'linear');
        end
    end
    
  
    bias=-w_ali-(tg_pca_ssh');% 
    
    tmpp=bias;
    ttt=pca_wet(:,5);
    tim2=pca_wet(:,3);
    bias2=[ttt tmpp tim2];

return