% calculate the difference of the wet delay between the GNSS and the
% radiomater. 


function [bias2,sig_g]=wet_cal_G_S(sat,dry,gnss_wet,z_delta,loc)
% 
% % `z_delta` is a  threshold value  to remove the fast changing data. Unit
% % is `mm`. It is not the same for each site and given by subjectively.
%     if strcmp(loc,'sdyt')
%         gnss_wet=load ('..\test\gnss_wet\troSDYT.d3');
%         z_delta=15;
%     elseif strcmp(loc,'fjpt')
%         gnss_wet=load ('..\test\gnss_wet\troFJPT.d3');
%         z_delta=15;
%     elseif strcmp(loc,'hisy') || strcmp(loc,'hisy2')
%         gnss_wet=load ('..\test\gnss_wet\troHISY.d3');
%         z_delta=15;
%     elseif strcmp(loc,'yong')||strcmp(loc,'yong2')
%         gnss_wet=load ('..\test\gnss_wet\troYONG.d3'); 
%         z_delta=20;
%     elseif strcmp(loc,'sdrc')||strcmp(loc,'sdrc2')
%         gnss_wet=load ('..\test\gnss_wet\troSDRC.d3'); 
%         z_delta=20;   
%     elseif strcmp(loc,'sdqd')
%         gnss_wet=load ('..\test\gnss_wet\troSDQD.d3'); 
%         z_delta=20;           
%     elseif strcmp(loc,'gdst')
%         gnss_wet=load ('..\test\gnss_wet\troGDST.d3'); 
%         z_delta=20;       
%     elseif strcmp(loc,'gdzh')
%         gnss_wet=load ('..\test\gnss_wet\troGDZH.d3'); 
%         z_delta=20;               
%     end

    tmp000=gnss_wet; % The format is :`2008.000000000 2524.90 209.70 17.50`
    % `time ZTD wet sig_td` for CMONOC. 
    % For China Ocean station GNSS, the format is `2010 01 01 00 00 00
    % 2349.51 33.41 1.51` : `YYYY MM DD hh mm ss ztd wetpd sigma_ztd`
    
    if ~(strcmp(loc,'zmw')||strcmp(loc,'qly'))
        y_0=floor(tmp000(:,1)); % year
        da=tmp000(:,1)-y_0; % 

        z_delay=tmp000(:,3);  % ZTD of GNSS,including the dry. Format: 2519.00
        ztd_delay=tmp000(:,2);  % wet PD of GNSS, excluding the dry. Format:240.60
        z_delay_sigma=tmp000(:,4);  % sigma of the wet PD of GNSS.

        % convert the time from year.. (as 2010.89773) to second refered to '2000-01-1 00:00:00'
        for i=2000:2030
           date_yj=[i 1 1 0 0 0];
           y_sec(i)=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
        end
        sec=y_sec(y_0)'+da*366*24*60*60; % time in unit of second. 
        % The 366 is defined by `# awk '{ printf ("%.9f %.2f %.2f %.2f \n",$1+($2-1+$3/24)/366,$4,$5,$6)}' tro$CT.d >tro$CT.d2`
        % $1 to $3 refered to `Yr  Doy Hr`
        
        g_w=z_delay; % GNSS wet PD
        g_ztd=ztd_delay; % GNSS ZTD

        tm2=round(sec); % GNSS time in second
        
    elseif strcmp(loc,'zmw') || strcmp(loc,'qly')
        time_tmp=floor(tmp000(:,1:6)); % `YYYY MM DD hh mm ss`
        sec=((datenum(time_tmp)-datenum('2000-01-1 00:00:00')))*86400;
        tm2=round(sec); % GNSS time in second        
        % remove the repeated data
        [tm2_clean,ia,ic]=unique(tm2);
        tm2=tm2_clean;
        z_delay=tmp000(ia,8);  % wet PD of GNSS, excluding the dry. Format:240.60
        ztd_delay=tmp000(ia,7);  % ZTD of GNSS,including the dry. Format: 2519.00
        z_delay_sigma=tmp000(ia,9);  % sigma of the wet PD of GNSS.
        % convert the time from year.. (as 2010.89773) to second refered to '2000-01-1 00:00:00'
        g_w=z_delay; % GNSS wet PD
        g_ztd=ztd_delay; % GNSS ZTD


        
    end
% load the satellite radiometer wet PD according to `sat`. The file format
% is `17.000000   111.896498 316774654.998892  -171.578105  56`, which
% means `lat lon time(s) wet_pd(negtive) cycle`.
    if sat==1
            pca_wet=load ('..\test\ja2_check\pca_wet.txt');
            pca_wet_model=load ('..\test\ja2_check\pca_wet_model.txt');
            pca_ztd=load ('..\test\ja2_check\pca_ztd.txt');
		elseif sat==2
            pca_wet=load ('..\test\saral_check\pca_wet.txt');
        elseif sat==3
            pca_wet=load ('..\test\hy2_check\pca_wet.txt');
            pca_wet_model=load ('..\test\hy2_check\pca_wet_model.txt');
            pca_ztd=load ('..\test\hy2_check\pca_ztd.txt');         
		elseif sat==4
			pca_wet=load ('..\test\ja3_check\pca_wet.txt');
            pca_wet_model=load ('..\test\ja3_check\pca_wet_model.txt');
            pca_ztd=load ('..\test\ja3_check\pca_ztd.txt');
            
    end
    
	pca_tim=round(pca_wet(:,3));% satellite time (s)
    w_ali=pca_wet(:,4);% radiometer wet delay. It is nagetive value
    w_ali_model=pca_wet_model(:,4);% model wet delay. Nagetive value
    w_ali_ztd=pca_ztd(:,4);% ZTD = model wet delay + Dry model value. Nagetive value
    
    b=length(w_ali); % radiomater data length
    c=length(tm2); % GNSS data length
    
    tmp3(1:b)=0;
    % Find the time of satellite passing. The time location will be stored in `tmp3`.
    for i=1:b
        n=0;
        for j=1:c-1
            
            if((pca_tim(i)<tm2(j+1)) && (pca_tim(i)>tm2(j)) || (pca_tim(i)==tm2(j)))
                n=j;
            end

        end
        tmp3(i)=n;% This is data location in the GNSS wet PD file.!!!
    end
    
    % 下面是拟合
%     tg_pca_ssh(1:b)=0;% 保存PCA wet delay值
    k=1;
    for i=1:b
        if tmp3(i)~=0 % 0 means no satellite passing that time
            loct=tmp3(i); % This is the location of data stored in GNSS file
            ssh_tg2=g_w(loct-1:loct+1);%  Three hours
            ztd_gnss_subset=g_ztd(loct-1:loct+1);%  Three hours
%             ssh_tg3=smooth(ssh_tg2,2,'rlowess');
            tt=tm2(loct-1:loct+1);
            t_pca=pca_tim(i);
            
            % 3600 is time of seconds. This is to ensure the GNSS data are
            % aviable near the satellite pca time before and after 1 hour.
            if abs(tm2(loct)-t_pca) < 3600 && abs(tm2(loct+1)-t_pca) < 3600 
                % Check the GNSS data around the PCA time. Data should be
                % exited in 1 hour before and after satellite passing.
                
    %             if abs(ssh_tg2(3)-ssh_tg2(1))<20 % 去除短时间变化快的数据
                if z_delay_sigma(loct)<z_delta && abs(ssh_tg2(3)-ssh_tg2(1))<z_delta  % 去除短时间变化快的数据  
                    tg_pca_ssh(k)=interp1(tt,ssh_tg2,t_pca,'nearest'); % This is GNSS wet PD Interpolated to the PCA time.
                    tg_pca_ztd(k)=interp1(tt,ztd_gnss_subset,t_pca,'nearest'); % This is GNSS ZTD Interpolated to the PCA time

                    % Here we can select the method of Interpolation. The
                    % nearest and the linear are nearly same, meaning that
                    % the wet pd variation in 1 hour period is small.
                    w_ali2(k)=w_ali(i); % radiometer wet PD at the PCA.
                    w_ali2_model(k)=w_ali_model(i); % model wet PD at the PCA.
                    
                    w_ali3(k)=w_ali_ztd(i); % ZTD at the PCA. Dry PD is the model value from GDR.
                    w_ali2_dry(k)= w_ali3(k)- w_ali2(k); % model dry
                    w_ali4(k)=w_ali2_model(k)+w_ali2_dry(k); % model ztd
                    
                    ttt(k)=pca_wet(i,5); % cycle number
                    tim2(k)=pca_wet(i,3); % time in sec
                    sig_pd(k)=z_delay_sigma(loct);% we do not interpolate it since it is nearly the same in 1 hour period.
                     k=k+1;
                end
            end
        end
    end
    
% =========================================================================    
  % Get the bais between GNSS and radiometer or model.
  if k>1
      if dry==2
        bias=-w_ali2-(tg_pca_ssh);% the result '-' means short,'+' means long
        bias_model=-w_ali2_model-(tg_pca_ssh);% the result '-' means short,'+' means long
      elseif dry==1
        bias=-w_ali3-(tg_pca_ztd);% the result '-' means short,'+' means long      
        bias_model=-w_ali4-(tg_pca_ztd);% the result '-' means short,'+' means long        
      end
%     bias_model=-w_ali2_model-(tg_pca_ssh);% the result '-' means short,'+' means long
    bias2=[ttt' bias' tim2' bias_model' sig_pd']; % the `bias2` format is `cycle R-G(mm) time(s) M-G(mm) sigma_GNSS (mm)`
  else
%       disp('no data fullfill the requirement')
      error('no data fullfill the requirement,please check the input data')
  end
% =========================================================================   

sig_g=mean(sig_pd); % This is the mean value of GNSS wet PD uncertainty from the GAMIT software.
Q=['The average uncertainty of the GNSS wet PD is:', num2str(sig_g)];
disp(Q);

return