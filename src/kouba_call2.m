% Three subfuntions are provided
% -kouba, least square fit
% -kouba2, using the single level as the surface wet PD of earth.
% -kouba3, only use the pressure level data.
% I suggest the kouba3 and kouba funtion.

% This function will loop the coordinate of coastline resampled of 300km.
% Just run one years data to speed up.

%%

clear;
clc;

format long

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

coastline=load('..\data\era5\coastline\coastal.d3');
len_coastline=length(coastline);
step=5;

% DO coordinates loop
for c=1:len_coastline
    lat_gps=coastline(c,2);%
    lon_gps=coastline(c,1);%  
    X = ['Location : ',num2str(lat_gps),', ' num2str(lon_gps),' N=',num2str(c)];
    disp(X)

    if lat_gps>=34
        area='north';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
        namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
        temp=size(namelist);
        file_num=temp(1);

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
            % Filter data
            temp=std(kouba_p);

            if temp<500
                kouba_p_day(c,nm)=mean(kouba_p);
            else
                kouba_p_day(c,nm)=-9999;
            end  
            kouba_p_day_std(c,nm)=temp;
        end

    elseif lat_gps>23 && lat_gps<=33
        area='middle';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
        namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
        temp=size(namelist);
        file_num=temp(1);        

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
            % Filter data
            temp=std(kouba_p);

            if temp<500
                kouba_p_day(c,nm)=mean(kouba_p);
            else
                kouba_p_day(c,nm)=-9999;
            end  
            kouba_p_day_std(c,nm)=temp;
        end


    elseif lat_gps>=15.5 && lat_gps<=23
        area='south';
        dir_nm=strcat('..\data\era5\4d\',area,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
        namelist = ls(fullfile(dir_nm,'*.nc'));% 这里ls可以和dir替换
        temp=size(namelist);
        file_num=temp(1);

        for nm=1:step:length(namelist)

            filepath=strcat(dir_nm,namelist(nm,:));
%             disp(filepath)
            [kouba_p]=kouba3(filepath,lon_gps,lat_gps);
            % Filter data
            temp=std(kouba_p);

            if temp<500
                kouba_p_day(c,nm)=mean(kouba_p);
            else
                kouba_p_day(c,nm)=-9999;
            end  
            kouba_p_day_std(c,nm)=temp;
        end
        
    else
        disp('out side of the research extent');
    end
    
end

% select 
kouba_p_day2=[];
kouba_p_day_std2=[];
fid4=fopen('../temp/kouba_coast.txt','w');

for c=1:len_coastline
    c
    k=1;
    lat_gps=coastline(c,2);%
    lon_gps=coastline(c,1);%  
    
    for nm=1:step:length(namelist)
        if kouba_p_day(c,nm)>100 && kouba_p_day(c,nm)<6000
            kouba_p_day2(k)=kouba_p_day(c,nm);
%             kouba_p_day_std2(c,k)=kouba_p_day_std(c,nm);
            k=k+1;
        end
    end
    
   kouba_m=mean(kouba_p_day2);
%        
   fprintf(fid4,'%12.6f %12.6f %12.6f \n',lon_gps,lat_gps,kouba_m);
%    out(c)=[lon_gps lat_gps kouba_m];
end
fclose('all');

load ../temp/kouba_coast.txt
plot(kouba_coast(:,3))

