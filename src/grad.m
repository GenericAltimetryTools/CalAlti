% call the GMT and system tools to calculate the MSS difference

function grad(lat_gps,lon_gps,sat)
if sat==5
    disp('------Sa3----')
    fid44=fopen('..\test\s3a_check\coor.d','w');
    fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
    fclose('all');
    !gawk "{print $2, $1}" ..\test\s3a_check\pca_ssh.txt >> ..\test\s3a_check\coor.d
    
    tmp=gmt('gmtmath ..\test\s3a_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
    disp('mean location:')
    tmp
    
    % The input data is the DTU MSS model. Please download it from DTU
    % site.
    gmt('grdtrack ..\test\s3a_check\coor.d -GC:\Users\yangleir\Documents\dtu\qly.nc >  ..\test\s3a_check\dtu18_qly.dat')
    gmt('gmt2kml  ..\test\s3a_check\coor.d -Gred+f -Fs >  ..\test\s3a_check\mypoints.kml')
    
elseif sat==1
    disp('------ja2----')
    fid44=fopen('..\test\ja2_check\coor.d','w');
    
    fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
    fclose('all');
    !gawk "{print $2, $1}" ..\test\ja2_check\pca_ssh.txt >> ..\test\ja2_check\coor.d
    
    tmp=gmt('gmtmath ..\test\ja2_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
    disp('mean location:')
    tmp
    
    % The input data is the DTU MSS model. Please download it from DTU
    % site.
    gmt('grdtrack ..\test\ja2_check\coor.d -GC:\Users\yangleir\Documents\dtu\qly.nc >  ..\test\ja2_check\dtu18_qly.dat')
    gmt('gmt2kml  ..\test\ja2_check\coor.d -Gred+f -Fs >  ..\test\ja2_check\mypoints.kml')
end


    fclose('all');
    disp('Finish grad')
return