% Call NAO99
% This program need to rewrite. At present we do not use it the CAL loop.
% the tide model data (ascii) has already been output.
function nao99(tbd,tbd,tbd)
    
    % 1,Read 
    load ..\test\s3a_check\pca_ssh.txt;
    pca_tim=round(pca_ssh(:,3));

    formatOut =30; % format 20181125T132757
    pca_times=datestr (pca_tim/(24*3600)+datenum('2000-01-01 00:00:00.0'),formatOut);
    fid100 = fopen('..\test\s3a_check\pca_loc_tim_to_nao.txt','w');
    for i=1:length(pca_tim)
        fprintf(fid100,'%8.6f %9.6f %15s\n',pca_ssh(i,1),pca_ssh(i,2),pca_times(i,:));%WGS-84Õ÷«Ú
    end

    
    % 2, out put the lat lon and pca_time to one txt file(lat,lon,time)
    % 3, write a subfunction of fortran to read the txt
    % 4,loop in fortran and out put result of tide value at pca time.
    
    
    % call nao fortran program
    cd ../tide/
    !gfortran naotestj.f -o naotestj
    !naotestj.exe
    
    fclose('all');
return
