% Plot map with GMT
% Plot the wet pd slope to check the land influence.

% Author: Yang Lei
% 2020-08-20

function plot_gmt(pass_num,min_cir,max_cir,sat)

if sat==1
%     fid4=fopen('..\test\ja2_check\statistic.txt','w');
    temp='..\test\ja2_check\';
elseif sat==4
%     fid4=fopen('..\test\ja3_check\statistic.txt','w');
    temp='..\test\ja3_check\';
end

% Find the best pass. (data not missed)
for i=min_cir:max_cir
        temp1=check_circle(i);% 调用函数，判断circle的位数。
        temp2=num2str(temp1);
        temp3=temp2(3:5);% 组成三位数的字符串。
        t1=check_circle(pass_num);
        t2=num2str(t1);
        t3=t2(3:5);% 组成三位数的字符串。
        tmp=strcat('_',t3);
        temp4= strcat(temp,temp3,tmp,'.txt');
        temp5= strcat('X',temp3,tmp);
        s=dir(temp4);
    if exist(temp4,'file') && s.bytes~=0
%         temp4;
        disp(temp4);
        load (temp4)
        temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        lent(i)=length(temp6(:,3));
    end
    
end 

[ma,location]=max(lent);
i=location; % The best circle.
temp1=check_circle(i);% 调用函数，判断circle的位数。
temp2=num2str(temp1);
temp3=temp2(3:5);% 组成三位数的字符串。
t1=check_circle(pass_num);
t2=num2str(t1);
t3=t2(3:5);% 组成三位数的字符串。
tmp=strcat('_',t3);
temp4= strcat(temp,temp3,tmp,'.txt');
temp5= strcat('X',temp3,tmp);
load (temp4);
full_pass=eval(temp5);

% Interpolate coordinates
s_lat=full_pass(2:ma-1,2); % remove the head and tail.
s_lon=full_pass(2:ma-1,1);
wet_full=full_pass(:,3);
wet_full_f=wet_full-mean(wet_full);
wet_ful_f_plot=[full_pass(:,1:2) wet_full_f];

k=1;
d=[]; % Must clear the array in each loop.
y=[];
for i=min_cir:max_cir
% for i= [200] % 只处理一个周期的一个pass数据，例如i [200] 表示200周期
% i
        
        temp1=check_circle(i);% 调用函数，判断circle的位数。
        temp2=num2str(temp1);
        temp3=temp2(3:5);% 组成三位数的字符串。
        t1=check_circle(pass_num);
        t2=num2str(t1);
        t3=t2(3:5);% 组成三位数的字符串。
        tmp=strcat('_',t3);
        temp4= strcat(temp,temp3,tmp,'.txt');
        temp5= strcat('X',temp3,tmp);
        s=dir(temp4);
    if exist(temp4,'file') && s.bytes~=0 
%         temp4;
%         disp(temp4);
        load (temp4)
        temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        latitude=temp6(:,2);
        longitude=temp6(:,1);
        points=temp6(:,3);
        for ii=2:length(points)
            dy=points(ii)-points(ii-1);
            dx=latitude(ii)-latitude(ii-1);
            d(ii-1)=dy/dx;%斜率
            y(ii-1)=(latitude(ii)+latitude(ii-1))/2;
%             x(ii-1)=(longitude(ii)+longitude(ii-1))/2;
        end
%         length(d)
%         length(y)
        slope_inter=interp1(y',d',s_lat,'pchip');
        d=[]; % Must clear the array in each loop.
        y=[];
        
        slope=[s_lon s_lat slope_inter];
        
        errors=std(slope_inter);

%     


        if k==1 % Here I only plot one pass. You can change it 
            gmt('gmtset MAP_FRAME_WIDTH = 0.02c FONT_LABEL 7 MAP_LABEL_OFFSET 5p ')
            gmt('gmtset FORMAT_GEO_MAP = ddd:mm:ssF')
            info=gmt('info -I0.01 ',temp6); 
            order=['pscoast ',char(info.text),' -Jm122/37/1:2500000  -Bga -Df -Gnavy -K > test.ps'];
            gmt(order);        
        end
        
        if errors<150
            slope_mean(k,:)=slope_inter;
            k=k+1;
            gmt('pswiggle  -R -J  -Z50 -Wthinnest,red -O -K >> test.ps ', slope)
        end     

    end 
end 

s=mean(slope_mean,1);
slopes=[s_lon s_lat s'];
order='psxy  -J -R -Sc0.2c -O  -C -K >> test.ps';
cpt = gmt('makecpt -Crainbow -E24', wet_full);
gmt(order,full_pass(:,1:3),cpt);   
gmt('psxy -J -R -W2c,black -O -K -t70 >> test.ps',full_pass(:,1:3)) % The diameter is 50km based on the projection scalor.
gmt('pswiggle  -R -J  -Z50 -W2p,blue  -O  >> test.ps ', slopes)
% gmt('pswiggle  -R -J  -Z10 -W2p,green  -O  >> test.ps ', wet_ful_f_plot)
gmt('psconvert test.ps -P -Tg -A')
return