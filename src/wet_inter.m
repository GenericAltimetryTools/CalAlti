% DO:
% - Load satellite wet PD files.
% - Interpolation of the SA wet delay to the comparison point.
% - Calculate the dry PD at GNSS site.
% - Call `wet_cal_G_S` to calculate bias/STD between GNSS and radiometer
% - Output the mean and STD to files as a function of the distance

% No process on the GNSS in this main function.

function [bias_std,bias2,sig_g,dis]=wet_inter(min_cir,max_cir,pass_num,sat,loc,lat_compare,lon_gps,lat_gps,dry,h_gnss,myfit,gnss_wet,z_delta)

    % ------------------------------------------------------------------------
    % `dis` is distance from GNSS site to the comparison point. It is
    % calculated by GMT.
    % `sig_g` is the uncertainty of GNSS wet output from GAMIT. I do not use it.
    % Instead I use 5mm as the uncertainty for the GNSS wet. Here  `sig_g` is a
    % value for precision of inner coincidence.
    % ------------------------------------------------------------------------
    %     lat3=lat_compare;

    temp11=check_circle(pass_num);% 调用函数，判断circle的位数。
    temp21=num2str(temp11);
    
    if sat==3
        temp31=temp21(2:5);% 组成三位数的字符串。
    else
        temp31=temp21(3:5);% 组成三位数的字符串。
    end
    
    % loop the `lat3`, save the STD of bias to matrix.
    % Here the loop is set to 1. Means no loop.
    % loop is not a good method to get the best validation location. I use the slope method instead. 
    tmp=length(lat_compare); % here `tmp=1`.
    sig_bias_r_g=[];
    mea_bias_r_g=[];
    dis_bias_r_g=[];
    
    % allocate the kouba coefficient from the ERA5
  
    if  strcmp(loc,'lnhl')
        kouba=load('../data/era5/results/kouba_site_1_season.txt');
    elseif  strcmp(loc,'lndd')
        kouba=load('../data/era5/results/kouba_site_2_season.txt');

    elseif  strcmp(loc,'lnjz')
        kouba=load('../data/era5/results/kouba_site_3_season.txt');

    elseif  strcmp(loc,'sdyt')
        kouba=load('../data/era5/results/kouba_site_4_season.txt');
    elseif  strcmp(loc,'sdrc')
        kouba=load('../data/era5/results/kouba_site_5_season.txt');
    elseif  strcmp(loc,'sdqd')
        kouba=load('../data/era5/results/kouba_site_6_season.txt');    
    elseif  strcmp(loc,'jsly')
        kouba=load('../data/era5/results/kouba_site_11_season.txt');      
    elseif  strcmp(loc,'lnhl')
        kouba=load('../data/era5/results/kouba_site_11_season.txt');      
    elseif  strcmp(loc,'jsly')
        kouba=load('../data/era5/results/kouba_site_7_season.txt');      
    elseif  strcmp(loc,'zjwz')
        kouba=load('../data/era5/results/kouba_site_8_season.txt');     
    elseif  strcmp(loc,'fjpt')
        kouba=load('../data/era5/results/kouba_site_9_season.txt');           
    elseif  strcmp(loc,'xiam')
        kouba=load('../data/era5/results/kouba_site_11_season.txt');         
    elseif  strcmp(loc,'gdst')
        kouba=load('../data/era5/results/kouba_site_12_season.txt');  
    elseif  strcmp(loc,'gdzh')
        kouba=load('../data/era5/results/kouba_site_13_season.txt');  
    elseif  strcmp(loc,'gxbh')
        kouba=load('../data/era5/results/kouba_site_14_season.txt');  
    elseif  strcmp(loc,'hisy')
        kouba=load('../data/era5/results/kouba_site_15_season.txt');  
    elseif  strcmp(loc,'yong')
        kouba=load('../data/era5/results/kouba_site_16_season.txt');  
    elseif  strcmp(loc,'zmw')|| strcmp(loc,'bzmw')
        kouba=load('../data/era5/results/kouba_site_17_season.txt');  
    elseif  strcmp(loc,'qly')|| strcmp(loc,'bqly')
        kouba=load('../data/era5/results/kouba_site_18_season.txt');  
    elseif  strcmp(loc,'twtf')
        kouba=load('../data/era5/results/kouba_site_26_season.txt');  % seasonal for one year (averaged from 5 year)
        kouba2=load('../data/era5/results/kouba_site_26.txt');  % daily (five year)
    elseif  strcmp(loc,'kmnm')
        kouba=load('../data/era5/results/kouba_site_27_season.txt');  
             
    else        
        disp('!!!!!!!!!!!!!!!!!no GNSS wet PD was found!!!!!!!!!!!!!!!')
        error('Please check the GNSS wet PD file for this site');        
    end 
    

    % Call Kouba function
                    
    % loop the comparison location `lat_compare`. This is to check the land
    % comtamination where apprears. Try different distances between GNSS 
    % comparison point. `tmp` is the length of the matrix of `lat_compare`.
    for ii=1:tmp
        lat3=lat_compare(ii);% This is the latitude of the comparison point.
        % The longitude is not give by input and it is determined by the 
        % interp1. 
        
        % Define the  names of the output files. These files will be called
        % by the sub-function `wet_cal_G_S.m`.
        if sat==1
            fid4=fopen('..\test\ja2_check\pca_wet.txt','w');
            fid5=fopen('..\test\ja2_check\pca_wet_model.txt','w');
            fid6=fopen('..\test\ja2_check\pca_ztd.txt','w');
            temp='..\test\ja2_check\';
        elseif sat==4
            fid4=fopen('..\test\ja3_check\pca_wet.txt','w');
            fid5=fopen('..\test\ja3_check\pca_wet_model.txt','w');
            fid6=fopen('..\test\ja3_check\pca_ztd.txt','w');
            temp='..\test\ja3_check\';
        elseif sat==3
            fid4=fopen('..\test\hy2_check\pca_wet.txt','w');
            fid5=fopen('..\test\hy2_check\pca_wet_model.txt','w');
            fid6=fopen('..\test\hy2_check\pca_ztd.txt','w');
            temp='..\test\hy2_check\';
        end  
        
        % get the wet PD of radiometer at the comparison point by `pchip` interpolation
        for i=min_cir:max_cir
            
                temp1=check_circle(i);% 
                temp2=num2str(temp1);
                if sat==3
                    temp3=temp2(2:5);% 
                else
                    temp3=temp2(3:5);% 
                end
                tmp=strcat('_',temp31);
                temp4= strcat(temp,temp3,tmp,'.txt'); % Full path

            if exist(temp4,'file') % load the along track WPD for each cycle 

                temp6=load (temp4); %load the SA wet PD file
                aa=size(temp6);

                if aa(1)>10 % 表示有效点数大于20个，占总数的一半。这个值可以更具总数多少修改。

                    lon3=interp1(temp6(:,2),temp6(:,1),lat3,'pchip'); % SA longitude
                    tim_pca=interp1(temp6(:,2),temp6(:,5),lat3,'pchip'); % SA time

                    % This is to use the daily (not season kouba from 2010-2014) for reducing the STD
%                     t_temp=tim_pca/86400-(datenum('2009-10-1 00:00:00')-datenum('2000-1-1 00:00:00'));% 
%                     kouba_coefficient=interp1(kouba2(:,1),kouba2(:,2),t_temp,'pchip'); % Get the kouba at the VAL day.                    
                    % However, result prove that the STD can not be
                    % reduced by the daily kuoba. And it is almost the same
                    % with the seasonal kouba. Since using the seasonal
                    % kouba is more convinent, I will use it in in this
                    % program.
                    
                    % This is the season kouba. It was created by the average of five year's data. 
                    formatOut2 = 'yyyy-mm-dd';
                    t_temp=datestr(tim_pca/86400+datenum('2000-1-1 00:00:00'),formatOut2);
                    t3_temp=datetime(t_temp);
                    doy=day(t3_temp,'dayofyear');
                    kouba_coefficient=kouba(doy);

%                     kouba_coefficient=2000;
                    pca_wet=interp1(temp6(:,2),temp6(:,3),lat3,'nearest');% WPD of satellite altimeters at PCA locations
                    % Add geoid height coorection
%                     kouba_coefficient=mean(kouba);
                    
                    pca_wet_height=pca_wet*exp(0-h_gnss/kouba_coefficient);% Here the h_gnss is the diff between GNSS and geoid.
                    % The parameter 2000 needs to be investaged as
                    % revieweres said it is diverse according to season and location. 
                    
                    pca_wet=pca_wet_height; % This is the SA Wet PD converted to the GNSS height.
                    
                    pca_wet_model=interp1(temp6(:,2),temp6(:,4),lat3,'pchip'); % Model from GDR
                    
                    % 
                    if dry==1 
                        pca_dry=interp1(temp6(:,2),temp6(:,6),lat_gps,'pchip'); % Model from GDR
                        pressure_gdr=(pca_dry*1e-3)*(1-0.00266*cosd(2*lat_gps))/(2.277*(1e-3));  % Here negelact the ocean dynamic Height effect. unit mm
                        [pressure_gdr]=dry_height(pressure_gdr,h_gnss);% Pressure correction due to GNSS height
                        pca_dry_corrected=pressure_gdr*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);% Dry PD Unit is mm.
                        
                        % Here I regard the pressure at the comparison point as
                        % the pressure at the GNSS site.(At the same height
                        % level)

                        % pressure_gdr is the pressure derived from GDR dry PD
                        % using the inverse formula. Unit is hPa. Refer to real
                        % ssh and regrad as mean sea level. However, the
                        % reviewers said that this is not correct because the
                        % pressure is not the same between comparison point and
                        % GNSS site. Reviewers suggested to use the ERA5 instead. 

                        % The reason I use the GDR pressure is that the
                        % pressure should be stable in small regions such as 
                        % distance small than 100km. However, this may
                        % introduce small errors less than 5 mm. As suggested by the
                        % reviewwes, the ERA5 is better.
                    end
                    
                    % Here is the pressure from the ERA5 model. Just run
                    % one time at the GNSS site. It need the input of the
                    % pca time. It will not change as the pca changes
                    % within very short time span.(satellite speed is about
                    % 6km/s).
                    if dry==3 && ii==1 

                        [pressure_era5]=era5_dry_function(tim_pca,lon_gps,lat_gps);
                        [pressure_era5_gnss_height]=dry_height(pressure_era5,h_gnss)/100;%unit hPa.
%                         pca_dry_era5_gnss_height=-pressure_era5_gnss_height*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);
                        pca_dry_corrected=-pressure_era5_gnss_height*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);% Dry PD Unit is mm.
                        
                    end 
                    
                    if dry==2
                        pca_dry_corrected=0;% Not use
                    end

%                     pca_dry_corrected=pressure_gdr*2.277/(1-0.00266*cosd(2*lat_gps)-0.28*(1e-6)*h_gnss);% Dry PD Unit is mm.
                    % 
                    pca_ztd=pca_wet+pca_dry_corrected;% This the Zenith tro delay at the GNSS height from the SA data.
                    % pca_ztd will be compared with the GNSS ZTD.
                    
    %                 tmp=datestr(tim_pca/86400+datenum('2000-01-1 00:00:00'))%
    %                 trasform the seconds to normal data format
    
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet,i);% save wet_R pd at PCA
                    fprintf(fid5,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet_model,i);%  save wet_model pd at PCA
                    fprintf(fid6,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ztd,i);%  save ZTD of SA at PCA

                end

            end

        end 
        
        % Compare and get the orignal bais between GNSS and radiometer. May contain abnormal values
        [bias2,sig_g]=wet_cal_G_S(sat,dry,gnss_wet,z_delta,loc);% the `bias2` format is `cycle R-G(mm) time(s) M-G(mm) sigma_GNSS (mm)`
        % three sigma0 editting to remove the abnormal values. Save data to
        % file. Also give the trend estimation for both radiometer and
        % model.
        
        %% Compute the distance between GNSS sites and PCA points.
        % The distance is changing folowing the loop of the PCA points with
        % the latitude changing.
        input=[lon_gps lat_gps]; % The GNSS sites coordinate
        order=strcat('mapproject -G',num2str(lon3),'/',num2str(lat3),'+i+uk -fg'); % The PCA coordinate
        dis = gmt (order,input);% Use GMT to calculate the distance in unit of km.
       
        % 
        Q=['===========finish interp at latitude:', num2str(lat3),'; distance to GNSS site:============',num2str(dis.data(3))];
        disp(Q);
        dis_bias_r_g(ii)=dis.data(3); % This is the distance value.
        
        % The `spa` is the  spatial rms. It should be zero when the distance is close to 0.
        % But due to the noise, it is not 0 (very close to 0).
        spa=myfit.a - myfit.b*exp(-dis_bias_r_g(ii)/myfit.c); % The myfit is from the input.
        disp(['The spatial rms of the radiometer is estimated to be:',num2str(spa)])   
        %% Compute the WPD difference due to the natural trend.
         % The prepared WPD grid data was from ECMWF model using the RADS.
         wpd_gps=gmt('grdtrack  -G../data/ecmwf/wpd.nc  ',input);
         wpd_sa=gmt('grdtrack  -G../data/ecmwf/wpd.nc  ',[lon3 lat3]);
         wpd_d=wpd_sa.data(3)-wpd_gps.data(3);% The wpd difference （SA-GPS）
         
        %% remove the outliers through 3 delta, 
        % Dispaly the KEY RESULT: mean bias and STD. 
        % Condisder the WDP difference `wpd_d` between GNSS and the SA.
        [bias_std,bias_mean]=wet_filter_save(bias2,sat,min_cir,max_cir,dis_bias_r_g(ii),loc,wpd_d);
        sig_bias_r_g(ii)=bias_std; %  This is return value
        mea_bias_r_g(ii)=bias_mean;  

        [sig_r]=sigma_r(bias_std,sig_g,spa); % Estiamte the STD of the radiometer.
        % BE care, this method are not used now. 
        % The STD of the radiometer are calculated through program of
        % `paper_tgrs_wet_statis.m`.
    end
    
    %% test 
    figure('Name','Wet PD bias and STD changing with distance','NumberTitle','off');
    plot(dis_bias_r_g,sig_bias_r_g);hold on
    plot(dis_bias_r_g,mea_bias_r_g);hold off
    output_dis=[dis_bias_r_g' mea_bias_r_g' sig_bias_r_g'];
    
    %% output the mean and STD as a function of the distance.
    % This output is useful to estimate the radiometer STD at the zero
    % distance.
    
    if sat==1
        filename1=strcat('..\test\ja2_check\jason_2_bias_wet_dis_function_',loc,'.txt');
        save(filename1,'output_dis','-ASCII') % 保存结果数据        
        
%         save ..\test\ja2_check\jason_2_bias_wet_dis_function.txt output_dis -ASCII % 保存结果数据
    elseif sat==4
        filename1=strcat('..\test\ja3_check\jason_3_bias_wet_dis_function_',loc,'.txt');
        save(filename1,'output_dis','-ASCII') % 保存结果数据           
%         save ..\test\ja3_check\jason_3_bias_wet_dis_function.txt output_dis -ASCII % 保存结果数据
    elseif sat==3
%         save ..\test\hy2_check\hy2_bias_dis_function.txt output_dis -ASCII % 保存结果数据
        filename1=strcat('..\test\hy2_check\hy2_bias_wet_dis_function_',loc,'.txt');
        save(filename1,'output_dis','-ASCII') % 保存结果数据          
    end
    
    fclose('all');
    
return