% Test fes2014 

cd C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\src
time_in=datenum(2021,11,06,0,0,0):1/(24*6):datenum(2021,11,7,0,0,0);%%%1/24表示1小时,/(24*6)表示10min
lat_t(1:length(time_in))=36.0;
lon_t(1:length(time_in))=121.0;
% time_in=1/86400+datenum('2000-1-1 00:00:00');
[series1]=fes2014(lat_t,lon_t,time_in);
plot(series1)