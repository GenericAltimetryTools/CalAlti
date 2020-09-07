% spatial decorrelation of the wet delay measured by radiometer
% This function only fit the exp line.
% ###############################################
function [myfit]=spatial_dec(pass_num,min_cir,max_cir,sat)

% choose the dir
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

% make plot
% figure(50);
% hold on
% if ii==1

    lenpd_all=[]; %Find the max length file

    for i=min_cir:max_cir

        temp1=check_circle(i);% 调用函数，判断circle的位数。
        temp2=num2str(temp1);
        t1=check_circle(pass_num); % Here use the open ocean data. Such as Yong
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
% END find the max length file

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
    wet_rmse_out=[]; % accumulated RMSE

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
            points=temp6(:,3); % wet PD
            lenpd=length(points); % 
            lenpd_all(i)=lenpd;

            if std(points)<std_thr && lenpd>m-2 % remove bad data
                wet_rmse=[];
                for k=1:lenpd-3 % do not need the tail data
                    wet_pd=points(lenpd-(k+1):lenpd)-points(lenpd); % Here we only use the Yong site data. The points(lenpd) is treated as the fisrt data point.
                    % The `wet_pd` will be accumulated with k=k+1; 
                    wet_rmse(k,1)=latitude(lenpd-(k+1));
                    wet_rmse(k,2)=longitude(lenpd-(k+1));
                    wet_rmse(k,3)=rms(wet_pd);% Save the rms of each cycle to this matrix. Then we will calculate the mean value at each distance of all cycles.
                end
    %             plot(wet_rmse(:,3));
                wet_rmse_out(nm,:)=interp1(wet_rmse(:,1),wet_rmse(:,3),fliplr(latitude_s(1:m-3)),'pchip'); 
                size(wet_rmse_out);
                nm=nm+1;
            end
        end
    end

    % hold off
    % 

    tmp=mean(wet_rmse_out,1); % Mean value of all cycles
    % tmp2=std(wet_rmse_out(:,1));
    tmp3=std(wet_rmse_out,1);

    % plot(tmp)
    out=[longitude_s(1:m-3)' ;latitude_s(1:m-3)';tmp;tmp3]';
    % out=sortrows(out,2);
    input=flipud(out); % sort the altimeter data by increasing distance
    % Call the GMT to calculate the distance to the first point.
    lat=latitude_s(m);
    lon=longitude_s(m);

    % 109.4206/17.8906 This is the first point of the reference track.
    % dis = gmt ('mapproject -G+a+i+uk -fg',out); % This is refered to first
    % point of the out matrix

    order=strcat('mapproject -G',num2str(lon),'/',num2str(lat),'+i+uk -fg');
    dis = gmt (order,input); % This is GMT data structure. It contains the [distance and RMSE...etc

    % dis = gmt ('mapproject -G109.4206/17.8906+i+uk -fg',input); % This is refered to the first point of the reference track.
    % The difference is about 17km caused by 3 points.
    % figure (121)
    % plot(dis.data(1:m-3,4),dis.data(1:m-3,3));
% end
% Fit the data set by the formula proposed in 1. Wang, J.; Zhang, J.; Fan, C.; Wang, J. Validation of the “HY-2” altimeter wet tropospheric path delay correction based on radiosonde data. Acta Oceanol. Sin. 2014, 33, 48–53, doi:10.1007/s13131-014-0473-y.

    [myfit]=fit_dis(dis,m,sat); % Do the fit. and return the fit coefficient.

% estimate the distance to the coastline. Only the first point was
% processed.
% lat_boundary_min=min([latitude_s;lat_gps])-0.1;
% 
% lat_gps,lon_gps,
% lat=latitude_s(m);
% lon=longitude_s(m);
% 
% gmt grdmath
% gmt grdtrack

return
