rem altimter jason-2 or HY-2 , PCA 
rem echo qly
rem echo    121.3853 36.2672   >coor.d
rem echo cst
rem echo 122.6968  37.3897 > coor.d
rem zmw
echo 114.3036 22.0549  > coor.d
echo 114.1479 21.9949  >> coor.d
echo 114.0294 22.1080  >> coor.d
rem gawk "{print $2, $1}" ..\test\s3a_check\pca_ssh.txt >> coor.d
echo "mean location of PCA"
rem gawk "{print $2, $1}" ..\test\s3a_check\pca_ssh.txt | gmt gmtmath STDIN -C0,1 MEAN -Sl =
grdtrack coor.d -G..\mss\zhws.nc >mss.tmp
rem gmt2kml coor.d -Gfred -Fs > mypoints.kml
pause