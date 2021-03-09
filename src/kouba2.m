% This is also kouba function for calculating the delay coefficient. It is
% more fast than least square method when use the inverse of the kouba
% function.
% It use the single level as the surface wet PD of earth.

% -input: filename
% -output: kouba parameter
function [kouba_p]=kouba2(filename,filepath2,lon1,lat1,oro_suface)
    %% pessure level
    filepath=filename;
    lat_gps=lat1;
    lon_gps=lon1;
    lat=ncread(filepath,'latitude'); % 1d
    lon=ncread(filepath,'longitude'); % 1d
%     time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
    geo=ncread(filepath,'z'); % 4D:lon,lat,level,time
    hum=ncread(filepath,'q'); % 
    air_t=ncread(filepath,'t'); % 
    level=ncread(filepath,'level'); % pressure level
    geo_h=geo/9.80665; % transform the geopotential to height.
    %% Single level at the orography

    filepath=filepath2;
    % ncdisp(filepath) % Show nc infomation.
    lat_or=ncread(filepath,'latitude'); % 1d
    lon_or=ncread(filepath,'longitude'); % 1d
%     time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
    t2m=ncread(filepath,'t2m'); % 
    tcwv=ncread(filepath,'tcwv'); % 

    
   %% interpolation of value to GNSS sites

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

%         X = ['latitude: ',num2str(k1),' longitude: ',num2str(k2)];
%         disp(X)


        k3=0;
        for i=1:length(lat_or)
            if lat_or(i)>=lat_gps && lat_or(i+1)<lat_gps
                k3=i;
                break
            end
        end

        k4=0;
        for i=1:length(lon_or)
            if lon_or(i)<=lon_gps && lon_or(i+1)>lon_gps
                k4=i;
                break
            end
        end

    %% calculate the Kouba parameter using least squares.

    % First, get the WPD at each level.

    for ii=0:7 % hour
        k=1;
        for i=2:23

            hum_gnss=hum(k2,k1,1:i,ii+1);% the 00:00 h
            air_gnss=air_t(k2,k1,1:i,ii+1);
            len=i;
            hum_gnss=reshape(hum_gnss,len,1);
            air_gnss=reshape(air_gnss,len,1);
            % plot(level,hum_gnss)
            wet_pd(ii+1,k)=(1.116454*1e-3*trapz(double(level(1:i)),hum_gnss)+17.66543828*trapz(double(level(1:i)),hum_gnss./air_gnss))*(1+0.0026*cosd(2*lat_gps));
            geo_height(ii+1,k)=geo_h(k2,k1,i,ii+1);
            k=k+1;
        end
        
        % calculate kouba from pressure level era5 data. Use the last
        % N (N coule be 5 level from the surface about 1000m).
        for nn=1:2
            kouba_tmp(nn)=(geo_height(ii+1,k-nn-1)-geo_height(ii+1,k-nn))/log(wet_pd(ii+1,k-nn)/wet_pd(ii+1,k-nn-1));% 2000 is not perfect
        end
        kouba_p(ii+1)=mean(kouba_tmp);% 2000 is not perfect
        
%         % wet PD calculated from the orography (earth surface)
%         t2m_ii=t2m(k4,k3,ii+1);% the 00:00 h
%         tcwv_ii=tcwv(k4,k3,ii+1);
%         tm=50.440+0.789*t2m_ii;
%         wet_pd_or_ii=(0.101995+1725.55/tm)*(tcwv_ii/1000);% wet PD at the orography.
%         kouba_from_orography=(oro_suface-geo_height(ii+1,k-1))/log(wet_pd(ii+1,k-1)/wet_pd_or_ii);% This is kouba from inverse formula.
%       
%         kouba_p(ii+1)=kouba_from_orography;% 

    
    end
   
    
return