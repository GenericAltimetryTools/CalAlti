% call the GMT and system tools to calculate the MSS difference

function grad(lat_gps,lon_gps,sat,loc)

if strcmp(loc,'cst') || strcmp(loc,'qly') || strcmp(loc,'bqly') || strcmp(loc,'zmw') ||  strcmp(loc,'bzmw')
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
        gmt('grdtrack ..\test\s3a_check\coor.d -G..\mss\qly.nc >  ..\test\s3a_check\dtu18_qly.dat')
        gmt('gmt2kml  ..\test\s3a_check\coor.d -Gred+f -Fs >  ..\test\s3a_check\mypoints.kml')

    elseif sat==1
        disp('------ja2----')
        fid44=fopen('..\test\ja2_check\coor.d','w');

        fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
        fclose('all');
        !gawk "{print $2, $1}" ..\test\ja2_check\pca_ssh.txt >> ..\test\ja2_check\coor.d

        tmp=gmt('gmtmath ..\test\ja2_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
        disp(['mean location:',num2str(tmp.data)]);
%         tmp.data

        % The input data is the DTU MSS model. Please download it from DTU
        % site.
        gmt('grdtrack ..\test\ja2_check\coor.d -G..\mss\qly.nc >  ..\test\ja2_check\dtu18_qly.dat')
        gmt('gmt2kml  ..\test\ja2_check\coor.d -Gred+f -Fs >  ..\test\ja2_check\mypoints.kml')
        
    elseif sat==4
        disp('------ja3----')
        fid44=fopen('..\test\ja3_check\coor.d','w');

        fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
        fclose('all');
        !gawk "{print $2, $1}" ..\test\ja3_check\pca_ssh.txt >> ..\test\ja3_check\coor.d

        tmp=gmt('gmtmath ..\test\ja3_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
%         disp('mean location:')
%         tmp

        % The input data is the DTU MSS model. Please download it from DTU
        % site.
        gmt('grdtrack ..\test\ja3_check\coor.d -G..\mss\qly.nc >  ..\test\ja3_check\dtu18_qly.dat')
        gmt('gmt2kml  ..\test\ja3_check\coor.d -Gred+f -Fs >  ..\test\ja3_check\mypoints.kml')
        
    elseif sat==3
        disp('------HY2B----')
        fid44=fopen('..\test\hy2_check\coor.d','w');

        fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
        fclose('all');
        !gawk "{print $2, $1}" ..\test\hy2_check\pca_ssh.txt >> ..\test\hy2_check\coor.d

        tmp=gmt('gmtmath ..\test\hy2_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
%         disp('mean location:')
%         tmp

        % The input data is the DTU MSS model. Please download it from DTU
        % site.
        gmt('grdtrack ..\test\hy2_check\coor.d -G..\mss\qly.nc >  ..\test\hy2_check\dtu18.dat')
        gmt('gmt2kml  ..\test\hy2_check\coor.d -Gred+f -Fs >  ..\test\hy2_check\mypoints.kml')
            
    end
end

if strcmp(loc,'zhws') % Only calibration for Jason-3 and HY-2B because of the data time span.
    if sat==4
        disp('------ja3----')
        fid44=fopen('..\test\ja3_check\coor.d','w');

        fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
        fclose('all');
        !gawk "{print $2, $1}" ..\test\ja3_check\pca_ssh.txt >> ..\test\ja3_check\coor.d

        tmp=gmt('gmtmath ..\test\ja3_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
%         disp('mean location:')
%         tmp

        % The input data is the DTU MSS model. Please download it from DTU
        % site.
        gmt('grdtrack ..\test\ja3_check\coor.d -G..\mss\zhws.nc >  ..\test\ja3_check\dtu18_zhws.dat')
        gmt('gmt2kml  ..\test\ja3_check\coor.d -Gred+f -Fs >  ..\test\ja3_check\mypoints.kml')
    elseif sat==3
        disp('------HY2B----')
        fid44=fopen('..\test\hy2_check\coor.d','w');

        fprintf(fid44,'%9.6f %9.6f\n',lon_gps,lat_gps);% 
        fclose('all');
        !gawk "{print $2, $1}" ..\test\hy2_check\pca_ssh.txt >> ..\test\hy2_check\coor.d

        tmp=gmt('gmtmath ..\test\hy2_check\pca_ssh.txt -C1,0 MEAN -Sl ='); % Use the GMT to calculate the mean location of PCA points
%         disp('mean location:')
%         tmp

        % The input data is the DTU MSS model. Please download it from DTU
        % site.
        gmt('grdtrack ..\test\hy2_check\coor.d -G..\mss\zhws.nc >  ..\test\hy2_check\dtu18_zhws.dat')
        gmt('gmt2kml  ..\test\hy2_check\coor.d -Gred+f -Fs >  ..\test\hy2_check\mypoints.kml')
    end
end

    disp(['mean location:',num2str(tmp.data)]);
    fclose('all');
    disp('Finish grad')
return