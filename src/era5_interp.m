% read ERA5 mean sea level pressure

% *************************************************************************
% -Input: pca time, GNSS sites location, ERA5 nc files contain pressure at mean sea level
% -Output: pressure at the pca time at the GNSS sites.

% Author:leiyang@fio.org.cn
% 2021-01-25
% *************************************************************************

function [k1,k2,dir_era]=era5_interp(lon_gps,lat_gps)

    if lat_gps > 34
        dir_era='..\data\era5\north\';
    elseif (lat_gps > 23) && (lat_gps < 34)
        dir_era='..\data\era5\middle\';
    elseif lat_gps < 23
        dir_era='..\data\era5\south\';
    end
    namelist = ls(fullfile(dir_era,'*.nc'));
    filepath_era= strcat(dir_era,namelist(1,:)); % Full path
    % Load nc file from dir

    %%
    % Read nc file
%     ncdisp(filepath_era) % Show nc infomation.
    lat=ncread(filepath_era,'latitude'); % 1d
    lon=ncread(filepath_era,'longitude'); % 1d

    %%

        k1=0;
        for i=1:length(lat)
            if lat(i)>=lat_gps && lat(i+1)<lat_gps
                k1=i;
                break
            end
        end

        k2=0;
        for i=1:length(lon)
            if lon(i)<=lon_gps && lon(i+1)>lon_gps
                k2=i;
                break
            end
        end

return