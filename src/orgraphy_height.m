% orography height calculated from the EAR5 geopotential data at the sea
% surface level.
function [oro_suface]=orgraphy_height(lon_gps,lat_gps)

temp=gmt ('grdtrack  -G..\data\era5\orography_cn.nc',[lon_gps,lat_gps]);
oro_suface=temp.data(3)/9.80665;

return