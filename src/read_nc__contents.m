% This program writes out the names and lacations of parameters stored in
% Netcdf files. This program is not limited to satellite altimetry and
% could be used for any Netcdf products.
% -This is the prerequisite to use Matlab for processing the NetCDF fiels.
% -Run it one time for each kind data is enough.
% -It will output a text file containing the required information.

% -------------------------------------------------------------------------
% The output information looks like this example:
%    0    0     'time'  
%    1    0 'latitude'  
%    2    0 'longitude'  
%    3    0 'altitude'  
%    4    0    'range'  
%    5    0 'wet_tropospheric_correction'  
%    6    0 'wet_tropospheric_correction_model'  
%    7    0 'dry_tropospheric_correction_model'  
%    8    0 'dynamic_atmospheric_correction'  
%    9    0 'ocean_tide_height'  
%   10    0 'solid_earth_tide'  
%   11    0 'pole_tide'  
%   12    0 'sea_state_bias'  
%   13    0 'ionospheric_correction'  
%   14    0 'mean_sea_surface'  
%   15    0 'sea_level_anomaly'  
%   16    0 'inter_mission_bias'  
%   17    0 'validation_flag'  
% -------------------------------------------------------------------------

% Then, you can read the data based on these parameters. Like read the
% latitude:
% `lat=netcdf.getVar(nc,3);%10-6`

% *************************************************************************
% Author:leiyang@fio.org.cn
% 2020-08-15
% *************************************************************************

clear;
clc;
format long

filepath='C:\Users\yangleir\Downloads\hy2b\IDR_2M\0007\H2B_OPER_IDR_2MC_0007_0001_20190121T200307_20190121T205522.nc'; % Here is the NC file location.
nc=netcdf.open(filepath,'NC_NOWRITE');
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(nc);% Determine numbers of the variable

fid1 = fopen('..\test\hy2b_IDR_008.txt', 'w'); % open the empty file to write out the data

for i=0:numvars-1
    [varname, xtype, varDimIDs, varAtts] = netcdf.inqVar(nc,i);
    out=mat2str(varname);
    fprintf(fid1,'%4d %4d %10s  \n',i,varDimIDs(1),out);
end

fclose(fid1); 

