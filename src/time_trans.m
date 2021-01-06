% Time transform from day to seconds
% This is useful in ploting figures by GMT

sec=(datenum('2018-10-1 12:24:45')-datenum('2000-1-1 00:00:00'))*86400
formatOut = 'yyyy/mm/dd HH:MM:SS';
t=datestr(sec/86400+datenum('2000-1-1 00:00:00'),formatOut)
year=t(1:4)
m=t(6:7)
d=t(9:10)
h=t(12:13)
m=t(15:16)
% s=t(16:17)

