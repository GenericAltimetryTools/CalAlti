%Calculate the tide difference between different locations.(One point is
%satellte altimter PCA point, another point is the tide station.)
%The input parameter is the sat and loc. The output is the tide difference
%between PCA and tide station.

% Call FES programs (Matlab) directly. In `fes_dif.m`, I use the output
% file of the FES2014 model. Here call FES.

% Need to load cood.d pca_ssh.txt
% Get the lat lon of tide gauge and PCA, time(seconds) of PCA
% Give them to FES2014 programs.


function [tg_dif]=fes_dif2(sat,loc)

    disp('=============call fes2014=============')       

    if sat==3
        load ..\test\hy2_check\pca_ssh.txt;
        load ..\test\hy2_check\coor.d;
        lat_t(1:length(pca_ssh))=coor(1,2); % tg lat
        lon_t(1:length(pca_ssh))=coor(1,1);% tg lon
        lat_pca=pca_ssh(:,1); % pca lat
        lon_pca=pca_ssh(:,2); % pca lon
        time_pca=pca_ssh(:,3); % pca time

        time_pca_trans=time_pca/86400+datenum('2000-1-1 00:00:00');

        % Now we got the location and time of PCA. 
        [t_tg]=fes2014(lat_t,lon_t,time_pca_trans);
        [t_pca]=fes2014(lat_pca,lon_pca,time_pca_trans);
    elseif sat==1
        load ..\test\ja2_check\pca_ssh.txt;
        load ..\test\ja2_check\coor.d;
        lat_t(1:length(pca_ssh))=coor(1,2); % tg lat
        lon_t(1:length(pca_ssh))=coor(1,1);% tg lon
        lat_pca=pca_ssh(:,1); % pca lat
        lon_pca=pca_ssh(:,2); % pca lon
        time_pca=pca_ssh(:,3); % pca time

        time_pca_trans=time_pca/86400+datenum('2000-1-1 00:00:00');

        % Now we got the location and time of PCA. 
        [t_tg]=fes2014(lat_t,lon_t,time_pca_trans);
        [t_pca]=fes2014(lat_pca,lon_pca,time_pca_trans);

    elseif sat==4
        load ..\test\ja3_check\pca_ssh.txt;
        load ..\test\ja3_check\coor.d;
        lat_t(1:length(pca_ssh))=coor(1,2); % tg lat
        lon_t(1:length(pca_ssh))=coor(1,1);% tg lon
        lat_pca=pca_ssh(:,1); % pca lat
        lon_pca=pca_ssh(:,2); % pca lon
        time_pca=pca_ssh(:,3); % pca time

        time_pca_trans=time_pca/86400+datenum('2000-1-1 00:00:00');

        % Now we got the location and time of PCA. 
        [t_tg]=fes2014(lat_t,lon_t,time_pca_trans);
        [t_pca]=fes2014(lat_pca,lon_pca,time_pca_trans);     
    end

    tg_dif=t_pca-t_tg;

return