% calculate the Kouba coefficient from the predefined model. 
% -input:time,lat,lon
% -output:kouba parameter

function [pressure_era5]=kouba_wet_parameter(tim_pca,lon_gps,lat_gps)
    %% First, transform the time to YYYYMMDD
    formatOut = 'yyyy/mm/dd HH:MM:SS';
    t=datestr(tim_pca/86400+datenum('2000-1-1 00:00:00'),formatOut);
    disp(t)
    year=t(1:4);
    m=t(6:7);
    d=t(9:10);
    h=t(12:13);h=str2double(h);
    min=t(15:16);min=str2double(min);    
    
return