function writegrid(y,x,z,name,ny,nx)
filename=name;

nccreate(filename,'latitude','Dimensions',{'latitude' nx});
ncwriteatt(filename, 'latitude', 'standard_name', 'latitude');
ncwriteatt(filename, 'latitude', 'long_name', 'latitude');
ncwriteatt(filename, 'latitude', 'units', 'degree');
ncwriteatt(filename, 'latitude', '_CoordinateAxisType', 'latitude');
% ncwriteatt(filename,'/','standard_name','latitude');
nccreate(filename,'longitude','Dimensions',{'longitude' ny});
ncwriteatt(filename, 'longitude', 'standard_name', 'longitude');
ncwriteatt(filename, 'longitude', 'long_name', 'longitude');
ncwriteatt(filename, 'longitude', 'units', 'degree');
ncwriteatt(filename, 'longitude', '_CoordinateAxisType', 'longitude');

nccreate(filename,'Q','datatype','double','Dimensions',{'longitude' ny 'latitude' nx});
ncwriteatt(filename, 'Q', 'standard_name', 'ssh');
ncwriteatt(filename, 'Q', 'long_name', 'pressure at sea surface level');
ncwriteatt(filename, 'Q', 'units', 'pa');

ncwrite(filename,'latitude',x);
ncwrite(filename,'longitude',y);

ncwrite(filename,'Q',z);

% ncdisp(filename);
return 
end