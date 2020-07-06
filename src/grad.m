% call the GMT and system tools to calculate the MSS difference

function grad(lat_gps,lon_gps)

    fid44=fopen('..\test\s3a_check\coor.d','w');
    fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
    fclose('all');
    !gawk "{print $2, $1}" ..\test\s3a_check\pca_ssh.txt >> ..\test\s3a_check\coor.d
    
    tmp=gmt('gmtmath ..\test\s3a_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
    disp('mean location:')
    tmp
    
    % The input data is the DTU MSS model. Please download it from DTU
    % site.
    gmt('grdtrack ..\test\s3a_check\coor.d -GC:\Users\yangleir\Documents\dtu\qly.nc >  ..\test\s3a_check\ja3_all_dtu18_zmw.dat')
    gmt('gmt2kml  ..\test\s3a_check\coor.d -Gred+f -Fs >  ..\test\s3a_check\mypoints.kml')

    fclose('all');
    disp('Finish grad')
return