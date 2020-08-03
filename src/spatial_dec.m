% spatial decorrelation of the wet delay measured by radiometer

% ###############################################
function spa=spatial_dec(pass_num,min_cir,max_cir,sat,dis_0)

if sat==1
    temp='..\test\ja2_check\';
    std_thr=20;
elseif sat==4
    temp='..\test\ja3_check\';
    std_thr=20;
elseif sat==3
    temp='..\test\hy2_check\';
    std_thr=100;
end

figure(50);
hold on

lenpd_all=[];

for i=min_cir:max_cir
       
    temp1=check_circle(i);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    t1=check_circle(pass_num);
    t2=num2str(t1);
    
    if sat==3
        temp3=temp2(2:5);% 组成三位数的字符串。
        t3=t2(2:5);% 组成三位数的字符串。
    elseif sat==1 || sat==4
        temp3=temp2(3:5);% 组成三位数的字符串。
        t3=t2(3:5);% 组成三位数的字符串。
    end
    
    tmp=strcat('_',t3);
    temp4= strcat(temp,temp3,tmp,'.txt');
    temp5= strcat('X',temp3,tmp);
    s=dir(temp4);    
    if exist(temp4,'file') && s.bytes~=0
        load (temp4);
        temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        points=temp6(:,3);
        lenpd=length(points);
        lenpd_all(i)=lenpd;
    end
end

[m,index]=max(lenpd_all);
temp1=check_circle(index);% 调用函数，判断circle的位数。
temp2=num2str(temp1);
t1=check_circle(pass_num);
t2=num2str(t1);
if sat==3
    temp3=temp2(2:5);% 组成三位数的字符串。
    t3=t2(2:5);% 组成三位数的字符串。
elseif sat==1 || sat==4
    temp3=temp2(3:5);% 组成三位数的字符串。
    t3=t2(3:5);% 组成三位数的字符串。
end

tmp=strcat('_',t3);
temp4= strcat(temp,temp3,tmp,'.txt');
temp5= strcat('X',temp3,tmp);
load (temp4);
temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
latitude_s=temp6(:,2);
longitude_s=temp6(:,1);

nm=1;
wet_rmse_out=[];



for i=min_cir:max_cir
       
    temp1=check_circle(i);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    
    t1=check_circle(pass_num);
    t2=num2str(t1);
    
    if sat==3
        temp3=temp2(2:5);% 组成三位数的字符串。
        t3=t2(2:5);% 组成三位数的字符串。
    elseif sat==1 || sat==4
        temp3=temp2(3:5);% 组成三位数的字符串。
        t3=t2(3:5);% 组成三位数的字符串。
    end

%     temp3=temp2(3:5);% 组成三位数的字符串。
%     
%     t3=t2(3:5);% 组成三位数的字符串。
    tmp=strcat('_',t3);
    temp4= strcat(temp,temp3,tmp,'.txt');
    temp5= strcat('X',temp3,tmp);
    s=dir(temp4);
        
    if exist(temp4,'file') && s.bytes~=0
        load (temp4);
        temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        
        latitude=temp6(:,2);
        longitude=temp6(:,1);
        points=temp6(:,3);
        lenpd=length(points);
        lenpd_all(i)=lenpd;
       
        if std(points)<std_thr && lenpd>m-2
            wet_rmse=[];
            for k=1:lenpd-3
                wet_pd=points(lenpd-(k+1):lenpd)-points(lenpd);
                wet_rmse(k,1)=latitude(lenpd-(k+1));
                wet_rmse(k,2)=longitude(lenpd-(k+1));
                wet_rmse(k,3)=rms(wet_pd);
            end
            plot(wet_rmse(:,3));
            wet_rmse_out(nm,:)=interp1(wet_rmse(:,1),wet_rmse(:,3),fliplr(latitude_s(1:m-3)),'pchip'); 
            size(wet_rmse_out);
            nm=nm+1;
        end
    end
end

hold off
% 

tmp=mean(wet_rmse_out,1);
% tmp2=std(wet_rmse_out(:,1));
tmp3=std(wet_rmse_out,1);
% plot(tmp)
out=[longitude_s(1:m-3)' ;latitude_s(1:m-3)';tmp;tmp3]';
% out=sortrows(out,2);
input=flipud(out); % sort the data by increasing distance

if sat==1
    save ..\test\ja2_check\distance.txt out -ASCII % 保存结果数据
elseif sat==4
    save ..\test\ja3_check\distance.txt out -ASCII % 保存结果数据
elseif sat==3
    save ..\test\hy2_check\distance.txt out -ASCII % 保存结果数据    
end

% Call the GMT to calculate the distance to the first point.
lat=latitude_s(m);
lon=longitude_s(m);

% 109.4206/17.8906 This is the first point of the reference track.
% dis = gmt ('mapproject -G+a+i+uk -fg',out); % This is refered to first
% point of the out matrix

order=strcat('mapproject -G',num2str(lon),'/',num2str(lat),'+i+uk -fg');
dis = gmt (order,input);

% dis = gmt ('mapproject -G109.4206/17.8906+i+uk -fg',input); % This is refered to the first point of the reference track.
% The difference is about 17km caused by 3 points.
% figure (121)
% plot(dis.data(1:m-3,4),dis.data(1:m-3,3));

% Fit the data set by the formula proposed in 1. Wang, J.; Zhang, J.; Fan, C.; Wang, J. Validation of the “HY-2” altimeter wet tropospheric path delay correction based on radiosonde data. Acta Oceanol. Sin. 2014, 33, 48–53, doi:10.1007/s13131-014-0473-y.

spa=fit_dis(dis,m,dis_0);

return
