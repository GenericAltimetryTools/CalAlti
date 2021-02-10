% Wet difference Calculation between  GNSS and Satellite radiomater.
% wet_cal_G_S
% -input: sat ID,dry ID, gnss PD, uncertainty of GNSS PD, location. And
% will call the 
% -output: the difference between GNSS and Satellite radiometers.


function [bias2,sig_g]=wet_cal_G_S(sat,dry,gnss_wet,z_delta,loc)

    tmp000=gnss_wet;
    % For CMONOC the format is :`2008.000000000 2524.90 209.70 17.50`
    % `time ZTD wet sig_td`. 
    % For China Ocean station GNSS, the format is `2010 01 01 00 00 00
    % 2349.51 33.41 1.51` : `YYYY MM DD hh mm ss ztd wetpd sigma_ztd`
    % For IGS, the format is `08 001 03000 2366.8 1.6`=`YY DDD Seconds dry
    % sigma`. The seconds is accumulated in one day with maximum value of
    % 85500. (15 minutes lost in IGS data)
    
    %% First, process  GNSS data. 
    % Here is to process the GNSS PD to get the standard format that could
    % be used next.
    % Be carefull, here is not~ in `if`.
    % 1、CMONOC
    if ~(strcmp(loc,'zmw')||strcmp(loc,'qly')||strcmp(loc,'bzmw') || strcmp(loc,'bzmw2') || strcmp(loc,'bqly') || strcmp(loc,'kmnm') || strcmp(loc,'twtf')||strcmp(loc,'twtf2')||strcmp(loc,'hkws') )
        % First, CMONOC sites.
        y_0=floor(tmp000(:,1)); % year
        da=tmp000(:,1)-y_0; % days/366

        z_delay=tmp000(:,3);  % wet PD of GNSS, excluding the dry. Format:240.60. 
        % The z_delay is computed by remove the dry PD from the ZPD. And
        % the dry PD is from the GNSS priori model. 
        % Be attention, this value is not so accurate.
        
        ztd_delay=tmp000(:,2);  % ZTD of GNSS,including the dry. Format: 2519.00
        % The ZTD is accurate. To subtract the dry PD from GDR or ERA5, the
        % accurate wet PD could be got.
        
        z_delay_sigma=tmp000(:,4);  % sigma of the wet PD of GNSS.
        % The z_delay_sigma is not uniform for GAMIT and Bernese. So Here
        % it dose not have big meaning. 

        % convert the time from year.. (as 2010.89773) to second refered to '2000-01-1 00:00:00'
        % First, calculate the seconds of the year refered to 2000.
        for i=2000:2030
           date_yj=[i 1 1 0 0 0];
           y_sec(i)=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
        end
        
        % Then, add the seconds of the days.
        sec=y_sec(y_0)'+da*366*24*60*60; % the time in unit of second. 
        % The 366 is defined by `# awk '{ printf ("%.9f %.2f %.2f %.2f \n",$1+($2-1+$3/24)/366,$4,$5,$6)}' tro$CT.d >tro$CT.d2`
        % $1 to $3 refered to `Yr  Doy Hr`. So 366 is determined when
        % creating the tro*.d2 files. It is correct even one year have 365
        % days or 366 days.
        
        g_w=z_delay; % GNSS wet PD
        g_ztd=ztd_delay; % GNSS ZTD

        tm2=round(sec); % GNSS time in second
     % 2、China Ocean station GNSS   
     elseif strcmp(loc,'zmw') || strcmp(loc,'qly') || strcmp(loc,'bzmw') ||strcmp(loc,'bzmw2') || strcmp(loc,'bqly')
        % Then, CGN sites. The time format is different with the CMONOC.
        
        time_tmp=floor(tmp000(:,1:6)); % `YYYY MM DD hh mm ss`
        sec=((datenum(time_tmp)-datenum('2000-01-1 00:00:00')))*86400;
        tm2=round(sec); % GNSS time in second   
        
        % remove the repeated data that maybe exited in CGN data files.
        [tm2_clean,ia,ic]=unique(tm2); % remove the duplicated data using unique.
        tm2=tm2_clean;
        
        z_delay=tmp000(ia,8);  % wet PD of GNSS, excluding the dry. Format:240.60
        ztd_delay=tmp000(ia,7);  % ZTD of GNSS,including the dry. Format: 2519.00
        z_delay_sigma=tmp000(ia,9);  % sigma of the wet PD of GNSS.
        
        g_w=z_delay; % GNSS wet PD
        g_ztd=ztd_delay; % GNSS ZTD
     % 3、IGS   
     elseif strcmp(loc,'kmnm') || strcmp(loc,'twtf')||strcmp(loc,'twtf2')||strcmp(loc,'hkws') % This is IGD data format 
        % Last, IGS sites
        
        y_0=tmp000(:,1)+2000; % year
        da=tmp000(:,2); % 
        sec_igs=tmp000(:,3); % 
        
        ztd_delay=tmp000(:,4);  % ZTD of GNSS,including the dry. Format: 2519.00
        z_delay_sigma=tmp000(:,5);  % sigma of the wet PD of GNSS.
        % No priori dry PD in the IGS file. So `dry=2` will not work for
        % IGS. Be aware about this. However, it dose not matter much,
        % because of the dry PD from priori is not accurate. Using `dry=1`
        % or `dry=3` will be fine.
        
        % convert the time from year.. (as 2010.89773) to second refered to '2000-01-1 00:00:00'
        for i=2000:2030
           date_yj=[i 1 1 0 0 0];
           y_sec(i)=((datenum(date_yj)-datenum('2000-01-1 00:00:00')))*86400;
        end
        
        sec=y_sec(y_0)'+(da-1)*24*60*60+sec_igs; % time in unit of second.
        % Here I found a bug related to the time. It should be
        % `sec=y_sec(y_0)'+(da-1)*24*60*60+sec_igs;` instead of
        % `sec=y_sec(y_0)'+(da)*24*60*60+sec_igs;` After fixed, the std
        % decreases from 27 to 16 for Jason-2.
             
        g_w=ztd_delay; % This is fake since there is no dry PD in IGS product.
        g_ztd=ztd_delay; % GNSS ZTD

        tm2=round(sec); % GNSS time in second        
    end
    
    %%  Then, load satellite radiometer data.
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
    
    pca_wet_ali=pca_wet(:,4);% radiometer wet delay. It is nagetive value
    w_ali_model=pca_wet_model(:,4);% model wet delay. Nagetive value
    w_ali_ztd=pca_ztd(:,4);% ZTD = radiometer wet delay + Dry model (GDR) value. Nagetive value
    % `dry=3` using the era5 dry pd; `dry=1` using the GDR dry pd.
    pca_dry_corrected=pca_ztd(:,4)-pca_wet(:,4); % This is the dry PD at the GNSS height.
    % If choose `dry=1`, it is form GDR. Else if `dry=3`, it is from era5
    % at the location of the GNSS sites and also at the GNSS height.
    
%     w_ali_ztd_era5=pca_ztd(:,5);% ZTD = radiometer wet delay + Dry model (ERA5) value. Nagetive value
    
    b=length(pca_wet_ali); % radiomater data length
    c=length(tm2); % GNSS data length
    
    tmp3(1:b)=0;
    
    %%  The time location in GNSS Wet PD stored in `tmp3`.
    for i=1:b
        n=0;
        for j=1:c-1
            
            if((pca_tim(i)<tm2(j+1)) && (pca_tim(i)>tm2(j)) || (pca_tim(i)==tm2(j)))
                n=j;
            end

        end
        tmp3(i)=n;% This is data location in the GNSS wet PD file.!!!
    end
    
    %% interp the wet PD of GNSS to the PCA time
    k=1;
    for i=1:b
        if tmp3(i)~=0 % 0 means no satellite passing that time
            loct=tmp3(i); % This is the location of data stored in GNSS file
            ssh_tg2=g_w(loct-1:loct+1);%  Three hours
            ztd_gnss_subset=g_ztd(loct-1:loct+1);%  Three hours
%             ssh_tg3=smooth(ssh_tg2,2,'rlowess');
            tt=tm2(loct-1:loct+1);% GNSS time
            t_pca=pca_tim(i); % SA time
            
            % 3600 is time of seconds. This is to ensure the GNSS data are
            % aviable near the satellite pca time before and after 1 hour.
            if abs(tm2(loct)-t_pca) < 3600 && abs(tm2(loct+1)-t_pca) < 3600 
                % Check the GNSS data around the PCA time. Data should be
                % exited in 1 hour before and after satellite passing.
                
            % if abs(ssh_tg2(3)-ssh_tg2(1))<20 % 去除短时间变化快的数据
                if z_delay_sigma(loct)<z_delta && abs(ssh_tg2(3)-ssh_tg2(1))<z_delta  % 去除短时间变化快的数据  
                    gnss_wet_one(k)=interp1(tt,ssh_tg2,t_pca,'nearest'); % This is GNSS wet PD Interpolated to the PCA time.
                    % The dry is from gnss model. Not accurate.
                    gnss_ztd(k)=interp1(tt,ztd_gnss_subset,t_pca,'nearest'); % This is GNSS ZTD Interpolated to the PCA time
                    % The dry in not exluded from ztd.
                    gnss_dry_era(k)=pca_dry_corrected(i); %This is the dry PD at the gnss site and height.
                    gnss_wet_two(k)=gnss_ztd(k)-(-gnss_dry_era(k));% GNSS wet PD by subtracting the era5 ddry PD.                    
                    
                    % Here we can select the method of Interpolation. The
                    % nearest and the linear are nearly same, meaning that
                    % the wet pd variation in 1 hour period is small.
                    
                    w_ali2(k)=pca_wet_ali(i); % radiometer wet PD at the PCA.
                    w_ali2_model(k)=w_ali_model(i); % model wet PD at the PCA.
                    
                    w_ali3(k)=w_ali_ztd(i); % ZTD at the PCA. Dry PD is the model value from GDR.
                    w_ali2_dry(k)= w_ali3(k)- w_ali2(k); % model dry
                    w_ali4(k)=w_ali2_model(k)+w_ali2_dry(k); % model ztd
                    
                    ttt(k)=pca_wet(i,5); % cycle number
                    tim2(k)=pca_wet(i,3); % time in sec
                    sig_pd(k)=z_delay_sigma(loct);% we do not interpolate it since it is nearly the same in 1 hour period.
%                     
%                     if dry==3
%                         [pressure_era5]=era5_dry_function();
%                         
%                     end
                    
                    k=k+1;
                end
            end
        end
    end


%%
% =========================================================================    
  % Get the bais between GNSS and radiometer or model.
  if k>1
      if dry==2
        bias=-w_ali2-(gnss_wet_one);% the result '-' means short,'+' means long
        bias_model=-w_ali2_model-(gnss_wet_one);% the result '-' means short,'+' means long
      elseif dry==1
        bias=-w_ali3-(gnss_ztd);% the result '-' means short,'+' means long      
        bias_model=-w_ali4-(gnss_ztd);% the result '-' means short,'+' means long      
      elseif dry==3 % The same with `dry=1`
%         bias=-w_ali3-(gnss_ztd);% the result '-' means short,'+' means long      
%         bias_model=-w_ali4-(gnss_ztd);% the result '-' means short,'+' means long      
        bias=-w_ali2-(gnss_wet_two);% the result '-' means short,'+' means long
        bias_model=-w_ali2_model-(gnss_wet_two);% the result '-' means short,'+' means long
        
      end
%     bias_model=-w_ali2_model-(tg_pca_ssh);% the result '-' means short,'+' means long
    bias2=[ttt' bias' tim2' bias_model' sig_pd']; % the `bias2` format is `cycle R-G(mm) time(s) M-G(mm) sigma_GNSS (mm)`
  else
%       disp('no data fullfill the requirement')
      error('no data fullfill the requirement,please check the input data')
  end
% =========================================================================   
%% Not useful 
sig_g=mean(sig_pd); % This is the mean value of GNSS wet PD uncertainty from the GAMIT or Bernese software.
Q=['The average uncertainty of the GNSS wet PD is:', num2str(sig_g)];
disp(Q);

return