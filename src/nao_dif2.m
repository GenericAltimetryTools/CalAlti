%Calculate the tide difference between different locations.(One point is
%satellte altimter PCA point, another point is the tide station.)
%The input parameter is the sat and loc. The output is the tide difference
%between PCA and tide station.

% Call FES programs (Matlab) directly. In `fes_dif.m`, I use the output
% file of the FES2014 model. Here call FES.

% Need to load cood.d pca_ssh.txt
% Get the lat lon of tide gauge and PCA, time(seconds) of PCA
% Give them to NAO programs.


function [tg_dif]=nao_dif2(sat)

    disp('=============call NAO99jb=============')       

    if sat==3
        load ..\test\hy2_check\pca_ssh.txt;
        load ..\test\hy2_check\coor.d;        
    elseif sat==1
        load ..\test\ja2_check\pca_ssh.txt;
        load ..\test\ja2_check\coor.d;
    elseif sat==4
        load ..\test\ja3_check\pca_ssh.txt;
        load ..\test\ja3_check\coor.d; 
    end
    
    lat_t=coor(1,2); % tg lat
    lon_t=coor(1,1);% tg lon
    lat_pca=pca_ssh(:,1); % pca lat
    lon_pca=pca_ssh(:,2); % pca lon
    time_pca=pca_ssh(:,3); % pca time

    % Now we got the location and time of PCA.
    for i=1:length(pca_ssh)
        [t_t]=nao99jb(lat_t,lon_t,time_pca(i));% unit cm         
        t_tg(i)=t_t;
        [t_p]=nao99jb(lat_pca(i),lon_pca(i),time_pca(i));% unit cm         
        t_pca(i)=t_p;            
    end
    
    tg_dif=t_pca-t_tg;

return