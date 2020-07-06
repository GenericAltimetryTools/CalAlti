rem altimter jason-2 or HY-2 , PCA 
rem echo qly
rem echo    121.3853 36.2672   >coor.d
rem echo cst
rem echo 122.6968  37.3897 > coor.d
rem zmw
echo 119.9200 40.0094  > coor.d
gawk "{print $2, $1}" ..\test\s3a_check\pca_ssh.txt >> coor.d
echo "mean location of PCA"
gawk "{print $2, $1}" ..\test\s3a_check\pca_ssh.txt | gmt gmtmath STDIN -C0,1 MEAN -Sl =
grdtrack coor.d -GC:\Users\yangleir\Documents\dtu\DTU18MSS_1min.nc > ja3_all_dtu18_zmw.dat
gmt2kml coor.d -Gfred -Fs > mypoints.kml
pause