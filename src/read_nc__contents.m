% This program writes out the variable names and lacations of NetCDF files.

% *************************************************************************
% Author:leiyang@fio.org.cn
% *************************************************************************

clear;
clc
format long

filepath='C:\Users\yangleir\Downloads\hy2b\IDR_2M\0007\H2B_OPER_IDR_2MC_0007_0001_20190121T200307_20190121T205522.nc'; % Here is the NC file location.
nc=netcdf.open(filepath,'NC_NOWRITE');
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(nc);% Determine numbers of the variable

fid1 = fopen('..\test\hy2b_IDR.txt', 'w'); % open the empty file to write out the data

for i=0:numvars-1
    [varname, xtype, varDimIDs, varAtts] = netcdf.inqVar(nc,i);
    hehe=mat2str(varname);
    fprintf(fid1,'%4d %4d %10s  \n',i,varDimIDs(1),hehe);
end

fclose(fid1); 

