% Plot map with GMT (mainly pswiggle).
% Plot the wet pd slope to check the land influence.

% Add the second order derivative,2021-28 

% Author: Yang Lei
% 2020-08-20

function plot_gmt(pass_num,min_cir,max_cir,sat)

disp('Making GMT figure...');

if sat==1
    temp='..\test\ja2_check\';
elseif sat==4
    temp='..\test\ja3_check\';
elseif sat==3
    temp='..\test\hy2_check\';    
end

%% Find the best pass. (data not missed)
for i=min_cir:max_cir
        temp1=check_circle(i);% 调用函数，判断circle的位数。
        temp2=num2str(temp1);
        if sat==3
            temp3=temp2(2:5);% 组成三位数的字符串。
        else
            temp3=temp2(3:5);% 组成三位数的字符串。
        end        
        t1=check_circle(pass_num);
        t2=num2str(t1);
        if sat==3
            temp31=t2(2:5);% 组成三位数的字符串。
        else
            temp31=t2(3:5);% 组成三位数的字符串。
        end        
        tmp=strcat('_',temp31);
        temp4= strcat(temp,temp3,tmp,'.txt');
%         temp5= strcat('X',temp3,tmp);
        s=dir(temp4);
    if exist(temp4,'file') && s.bytes~=0
%         temp4;
%         disp(temp4);
        temp6=load (temp4);
%         temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        lent(i)=length(temp6(:,3));% As for HY-2B, many radiometer measurements were lost and matix values are 0.
    end
    
end 

[ma,location]=max(lent); % `ma` is the max of the points number.  
i=location; % The index of The best circle (with maximum data).

%%
temp1=check_circle(i);% 调用函数，判断circle的位数。
temp2=num2str(temp1);
if sat==3
    temp3=temp2(2:5);% 组成三位数的字符串。
else
    temp3=temp2(3:5);% 组成三位数的字符串。
end

t1=check_circle(pass_num);
t2=num2str(t1);

if sat==3
    temp31=t2(2:5);% 组成三位数的字符串。
else
    temp31=t2(3:5);% 组成三位数的字符串。
end
tmp=strcat('_',temp31);
temp4= strcat(temp,temp3,tmp,'.txt'); % This is the file contains the max number of points.

full_pass=load (temp4);

%% Plot slope along tracks for each cycle using GMT.
s_lat=full_pass(2:ma-1,2); % remove the head and tail.
s_lon=full_pass(2:ma-1,1);
% wet_full=full_pass(:,3); % wet pd
% wet_full_f=wet_full-mean(wet_full);% remove mean 
% wet_ful_f_plot=[full_pass(:,1:2) wet_full_f];

k=1;
d=[]; % Must clear the array in each loop.
y=[];

for i=min_cir:max_cir
% for i= [200] % 只处理一个周期的一个pass数据，例如i [200] 表示200周期
% i

    temp1=check_circle(i);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    if sat==3
        temp3=temp2(2:5);% 组成三位数的字符串。
    else
        temp3=temp2(3:5);% 组成三位数的字符串。
    end

    t1=check_circle(pass_num);
    t2=num2str(t1);
    if sat==3
        temp31=t2(2:5);% 组成三位数的字符串。
    else
        temp31=t2(3:5);% 组成三位数的字符串。
    end        

    tmp=strcat('_',temp31);
    temp4= strcat(temp,temp3,tmp,'.txt');
%     temp5= strcat('X',temp3,tmp);
    s=dir(temp4);
    
    if exist(temp4,'file') && s.bytes~=0 
        temp6=load (temp4);
        latitude=temp6(:,2);
        longitude=temp6(:,1);
        points=temp6(:,3);
        
        for ii=2:length(points) % Calculate the slope of 1Hz Wet PD data along satellite tracks.
            dy=points(ii)-points(ii-1); 
            dx=latitude(ii)-latitude(ii-1);
            % calculate distanse
            if ii==2 % just run one time
                order=strcat('mapproject -G',num2str(longitude(ii-1)),'/',num2str(latitude(ii-1)),'+i+uk -fg');
                input=[longitude(ii) latitude(ii)];
                dis = gmt (order,input); 
                dist=dis.data(3);
            end
%             d(ii-1)=dy/dx; % slope value accoding to delta latitude degree. 
            d(ii-1)=dy/dist; % slope value accoding to delta distance km. 
            y(ii-1)=(latitude(ii)+latitude(ii-1))/2; % mean location according the slope.
        end

        slope_inter=interp1(y',d',s_lat,'pchip'); % `s_lat` is reference latitude from the pass with max numbers.
        d=[]; % Must clear the array in each loop.
        y=[];
        
        slope=[s_lon s_lat slope_inter]; % store data
        
        errors=std(slope_inter); % For filter bad data.

        if k==1 % Here only plot the coastlines of map. Just one time with no loop.
            
            gmt('gmtset MAP_FRAME_WIDTH = 0.02c FONT_LABEL 7 MAP_LABEL_OFFSET 5p ')
            gmt('gmtset FORMAT_GEO_MAP = ddd:mm:ssF')
            info=gmt('info -I0.01 ',temp6); % Format: GMT stucture 1X1

            bound=char(info.text); % Example: '-R108.55/109.6/15.72/18.3'
            len_b=length(bound);
            bounds= strsplit(bound(3:len_b),'/');
            bounds=str2num(char(bounds));
            mi_lon=floor(bounds(1)-1);
            ma_lon=ceil((bounds(2))+1);
            mi_lat=floor((bounds(3))-0.5);
            ma_lat=ceil((bounds(4))+0.5);
            
            bound=['-R',num2str(mi_lon),'/',num2str(ma_lon),'/',num2str(mi_lat),'/',num2str(ma_lat)];
            order=['pscoast ',bound,' -JM3i  -Bga -BSWen -Df -W1 -Glightyellow -K > ../temp/test.ps'];
%             -Jm122/37/1:5000000
            gmt(order);  
        end
        
        if errors<150 % This is a filter 
            slope_mean(k,:)=slope_inter; % 2D array contain the cycle index and slope profiles.
            k=k+1;
            gmt('pswiggle  -R -J  -Z1 -Wthinnest,red -O -K -t70 >> ../temp/test.ps ', slope); % Plot with `k` loop.
        end     

    end 
end

%% the mean profile of the WPD slope
s=mean(slope_mean,1); % This is the mean profile of wet PD slope.
slopes=[s_lon s_lat s']; % store
points=s';
latitude=s_lat;

d=[]; % Must clear the array in each loop.
y=[];
%% calculate the second order derivative.(acceleration)
for ii=2:length(slopes) % Calculate the slope of 1Hz Wet PD data along satellite tracks.
    dy=points(ii)-points(ii-1); 
%     dx=latitude(ii)-latitude(ii-1);
    
    % calculate distanse
    if ii==2 % just run one time
        order=strcat('mapproject -G',num2str(s_lon(ii-1)),'/',num2str(s_lat(ii-1)),'+i+uk -fg');
        input=[s_lon(ii) s_lat(ii)];
        dis = gmt (order,input); 
        dist=dis.data(3);    
    end
    d(ii-1)=dy/dist; % slope value
    y(ii-1)=(s_lat(ii)+s_lat(ii-1))/2; % mean location according the slope.
end

slope_inter=interp1(y',d',s_lat,'pchip');
slope_group=[s_lon s_lat slope_inter]; % store data

%% GMT plot
gmt('psxy -J -R -W1.67c,black -O -K -t70 >> ../temp/test.ps',full_pass(:,1:3)) % The diameter is 50km based on the projection scalor.
order='psxy  -J -R -Sc0.2c -Gblack -O  -K >> ../temp/test.ps';
% cpt = gmt('makecpt -Crainbow -E24', wet_full);
gmt(order,full_pass(:,1:3));
%% Plot the 50 km line
order=['grdmath ',bound,' -A10000/0/4 -Dl -I2m LDISTG = ../temp/dist_to_gshhg_hn2.nc']; % calculate the distance from grid points to coastline
gmt(order); % Here is the Bug for some locations.

gmt('grdsample ../temp/dist_to_gshhg_hn2.nc -R -I0.5m -G../temp/file2_hn2.nc')
gmt('grdlandmask -R -Dl -A10000/0/4 -I0.5m -N1/-1 -G../temp/land_mask.nc');
gmt('grdmath ../temp/file2_hn2.nc ../temp/land_mask.nc MUL = ../temp/file.nc' )

outdis=gmt('grdcontour ../temp/file.nc -R -C50, -D'); % plot the 35 or 50km line
gmt('psxy -R -J -W4p,green  -K -O >> ../temp/test.ps',outdis.data)
gmt('psxy ../test/gnssinfo/points_latlon.txt2 -R -J -Sa0.4c -Glightgray -K -O >> ../temp/test.ps');
gmt('pswiggle  -R -J  -Z1 -W2p,yellow  -O -K >> ../temp/test.ps ', slopes)
gmt('pswiggle  -R -J  -Z0.1 -W2p,24/75/167,  -O -K >> ../temp/test.ps ', slope_group)
gmt('pstext  ../test/gnssinfo/points_latlon.txt2 -R -J -F+f7p,black+jTL -O  -Gwhite -D0.2/0.1 >> ../temp/test.ps')
%% convert PS to PDF
gmt('psconvert ../temp/test.ps -P -Tf -A')

return