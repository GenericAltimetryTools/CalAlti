% Time transform from day to seconds
% This is useful in ploting figures by GMT

sec=(datenum('2018-10-1 00:00:00')-datenum('2000-1-1 00:00:00'))*86400
formatOut = 'yy/mm/dd';
t=datestr(sec/86400+datenum('2000-1-1 00:00:00'),formatOut)
t=datestr(sec/86400,formatOut)