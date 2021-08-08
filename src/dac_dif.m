%Calculate the tide difference between different locations.(One point is
%satellte altimter PCA point, another point is the tide station.)
%The input parameter is the sat and loc. The output is the tide difference
%between PCA and tide station.

% Call FES programs (Matlab) directly. In `fes_dif.m`, I use the output
% file of the FES2014 model. Here call FES.

% Need to load cood.d pca_ssh.txt
% Get the lat lon of tide gauge and PCA, time(seconds) of PCA
% Give them to FES2014 programs.


function dac_diff_value=dac_dif(sat)

    disp('=============correcting dac=============')       

    if sat==3
        load ..\test\hy2_check\pca_ssh.txt;
        load ..\test\hy2_check\coor.d;
    elseif sat==1
        load ..\test\ja2_check\pca_ssh.txt;
        load ..\test\ja2_check\coor.d;
    elseif sat==4
        load ..\test\ja3_check\pca_ssh.txt;
        load ..\test\ja3_check\coor.d;  
    elseif sat==5
        load ..\test\s3a_check\pca_ssh.txt;
        load ..\test\s3a_check\coor.d;  
        
    end

    lat_t(1:length(pca_ssh))=coor(1,2); % tg latitude. This is a matrix of same values.
    lon_t(1:length(pca_ssh))=coor(1,1);% tg longitude.
    
    lat_pca=pca_ssh(:,1); % pca lat
    lon_pca=pca_ssh(:,2); % pca lon
    time_pca=pca_ssh(:,3); % pca time

    time_pca_trans=time_pca/86400+datenum('2000-1-1 00:00:00');% Time unit input to the FES2014 is days.
    
    % days_ref=datenum('2011-1-1 00:00:00')-datenum('1950-1-1 00:00:00');% The result is 22280, which is the 
    % ellipsed days of the "2011-1-1" since "1950-1-1". Also it is the file
    % names of the DAC filesof day "2011-1-1". "dac_dif_22280_00.nc".
    
    formatOut = 'yyyy/mm/dd HH:MM:SS';
    t=datestr(time_pca_trans,formatOut);
    
    days=time_pca_trans-datenum('1950-1-1 00:00:00');
    days=floor(days);
    dac_diff_value=[];
    
    for j=1:length(time_pca_trans)
        year=t(j,1:4);
        mm=str2num(t(j,15:16));
        h=str2num(t(j,12:13))+mm/60;
        
        temp(1:4)=0;
        for jj=0:6:18
            temp(jj/6+1)=abs(jj-h);
        end
        [values,index]=min(temp);
        hh=num2str((index-1)*6+100);
        hh=hh(2:3);
        days_ok=num2str(days(j));
        
        dir_nm0='C:\Users\yangleir\Documents\aviso\dac\'; % 
        dir_nm=strcat(dir_nm0,year,'\dac_dif_',days_ok,'_',hh,'.nc');
        
        order=['grdtrack -G',dir_nm];
        tmp=gmt(order,[lon_t(j) lat_t(j);lon_pca(j) lat_pca(j)]);% Qianliyan points 121.386 36.2681;121.34804723	36.2688465032;121.1852 36.2407
        
        dac_diff_value(j)=tmp.data(2,3)-tmp.data(1,3);% PCA-TG. 
    end
    %%
    dac_dif_mean=mean(dac_diff_value);
    dac_dif_std=std(dac_diff_value);
    Q=['Mean of DAC diff=',num2str(dac_dif_mean),' + - ',num2str(dac_dif_std)];
    disp(Q)
    
return