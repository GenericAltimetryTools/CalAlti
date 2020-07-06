% This program writes out the variable names and lacations of NetCDF files.

% *************************************************************************
% Author:leiyang@fio.org.cn
% *************************************************************************

clear;
clc
format long

filepath='..\data\JA3_GPN_2PdP156_012_20200503_185841_20200503_195454.nc'; % Here is the NC file location.
nc=netcdf.open(filepath,'NC_NOWRITE');
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(nc);% Determine numbers of the variable

fid1 = fopen('..\test\j3_GDR.txt', 'w'); % open the empty file to write out the data

for i=0:numvars-1
    [varname, xtype, varDimIDs, varAtts] = netcdf.inqVar(nc,i);
    hehe=mat2str(varname);
    fprintf(fid1,'%4d %4d %10s  \n',i,varDimIDs(1),hehe);
end

fclose(fid1); 

