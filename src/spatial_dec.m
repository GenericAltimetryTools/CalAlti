% spatial decorrelation of the wet delay measured by radiometer
% This function only fits the exp line.
% ###############################################
function [myfit]=spatial_dec(pass_num,min_cir,max_cir,sat)

%% choose the dir
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
%%  Find the max length file
    lenpd_all=[]; % Find the max length file

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
%         temp5= strcat('X',temp3,tmp);
        s=dir(temp4);    
        if exist(temp4,'file') && s.bytes~=0
           temp6=  load (temp4);
%             temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
            points=temp6(:,3);
            lenpd=length(points);
            lenpd_all(i)=lenpd;
        end
    end
% END find the max length file
%% allocate values from max file to latitude and longitude
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
%     temp5= strcat('X',temp3,tmp);
    temp6=load (temp4);
%     temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
    latitude_s=temp6(:,2);
    longitude_s=temp6(:,1);
%% calculate the accumulated RMSE
    nm=1;
    wet_rmse_out=[]; % accumulated RMSE

    for i=min_cir:max_cir % Loop all cycles

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
        s=dir(temp4);

        if exist(temp4,'file') && s.bytes~=0
            temp6=load (temp4);
            latitude=temp6(:,2);
            longitude=temp6(:,1);
            points=temp6(:,3); % wet PD
            lenpd=length(points); % length of this input file.(length of path delay data)
            lenpd_all(i)=lenpd;

            if std(points)<std_thr && lenpd>m-2 % remove bad data
                wet_rmse=[];
                for k=1:lenpd-3 % do not need the tail data
                    wet_pd=points(lenpd-(k+1):lenpd)-points(lenpd); % The points(lenpd) is treated as the fisrt data point.
                    % The `wet_pd` will be accumulated with k=k+1; 
                    % Dose here matter with the order? Such as from south
                    % to north or from north to south? The first point will
                    % be different for assending and desending passes.
                    wet_rmse(k,1)=latitude(lenpd-(k+1));
                    wet_rmse(k,2)=longitude(lenpd-(k+1));
                    wet_rmse(k,3)=rms(wet_pd);% Save the rms of each cycle to this matrix. Then we will calculate the mean value at each distance of all cycles.
                end
    %             plot(wet_rmse(:,3));
                wet_rmse_out(nm,:)=interp1(wet_rmse(:,1),wet_rmse(:,3),fliplr(latitude_s(1:m-3)),'pchip'); 
%                 size(wet_rmse_out);
                nm=nm+1;
            end
        end
    end
%% Plot Mean value of all cycles

    tmp=mean(wet_rmse_out,1); % Mean value of what? for all cycles.
    % This is the mean value for std at the specific latitude defined by
    % `latitude_s` (the standard pass latitude).
    
    % tmp2=std(wet_rmse_out(:,1));
    tmp3=std(wet_rmse_out,1);
    % This is the STD value for std at the specific latitude defined by
    % `latitude_s` (the standard pass latitude).    

    % plot(tmp)
    out=[longitude_s(1:m-3)' ;latitude_s(1:m-3)';tmp;tmp3]';
    % out=sortrows(out,2);
    input=flipud(out); % sort the altimeter data by increasing distance
    % Call the GMT to calculate the distance to the first point.
    lat=latitude_s(m); % This is the first point of the track. ?
    lon=longitude_s(m);

    order=strcat('mapproject -G',num2str(lon),'/',num2str(lat),'+i+uk -fg');
    dis = gmt (order,input); % This is GMT data structure. It contains the [distance and RMSE...etc
    % The 5th is the distance. The 1th to 4th are the `input` data.
    
    % Fit the data set by the formula proposed in 1. Wang, J.; Zhang, J.; Fan, C.; Wang, J. Validation of the “HY-2” altimeter wet tropospheric path delay correction based on radiosonde data. Acta Oceanol. Sin. 2014, 33, 48–53, doi:10.1007/s13131-014-0473-y.
    [myfit]=fit_dis(dis,m,sat); % Do the fit. and return the fit coefficient.

return
