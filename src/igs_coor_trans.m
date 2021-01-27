% transform IGS coordinate to normal
% +161544.30	 -0613139.11	 -25.0 TO   -6.1527531e+01   1.6262306e+01  -2.5000000e+01
format long
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path


load ../test/gnssinfo/igs_xyz.dat
lat=igs_xyz(:,1);
lon=igs_xyz(:,2);
height=igs_xyz(:,3);

lat_sec=mod(abs(lat),100);

lat_min=(mod(abs(lat),10000)-mod(abs(lat),100))/100;
lat_d=(abs(lat)-mod(abs(lat),10000))/10000;
lat_normal=(lat_sec/3600+lat_min/60+lat_d).*sign(lat);

lon_sec=mod(abs(lon),100);
lon_min=(mod(abs(lon),10000)-mod(abs(lon),100))/100;
lon_d=(abs(lon)-mod(abs(lon),10000))/10000;
lon_normal=(lon_sec/3600+lon_min/60+lon_d).*sign(lon);

out=[lon_normal lat_normal height];
% save ('../test/gnssinfo/igs_coor_normal.txt','out','-ascii')

% call GMT

% gmt psbasemap
gmt ('set MAP_ANNOT_OBLIQUE=45 FONT_TITLE=10p')
gmt ('pscoast -R0/360/-83/83 -JM10c -Dl -A10000/0/1 -Bag  -K -Glightyellow -W0.01p  > ../temp/igs.ps')
gmt ('psxy -R -J -Sc0.02 -Gred -O -K >> ../temp/igs.ps',out)
% gmt ('2kml -Gred+f -Fs >  ../temp/mypoints.kml',out)

% gmt select

