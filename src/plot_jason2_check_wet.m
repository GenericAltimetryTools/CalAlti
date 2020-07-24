% ###############################################
% draw figure for statistic 
function plot_jason2_check_wet(pass_num,min_cir,max_cir,sat)

min_y=0;%Y轴范围的初始值，后面有判断改变此值
max_y=-600;
a(1:(max_cir-min_cir+1))=0;% 存储radio和model差异均值
b(1:(max_cir-min_cir+1))=0;% 存储radio和model差异std
if sat==1
    fid4=fopen('..\test\ja2_check\statistic.txt','w');
    temp='..\test\ja2_check\';
elseif sat==4
    fid4=fopen('..\test\ja3_check\statistic.txt','w');
    temp='..\test\ja3_check\';
end
figure(5);
hold on

for i=min_cir:max_cir
% for i= [200] % 只处理一个周期的一个pass数据，例如i [200] 表示200周期
i;
        
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
        load (temp4)
        temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        latitude=temp6(:,2);
        points=temp6(:,3);
        points_m=temp6(:,4);
        r_m=points-points_m;
        
        a(i-min_cir+1)=mean(points-points_m);% 计算观测值和模型值的差值均值
        b(i-min_cir+1)=std(points-points_m);% 计算std
        fprintf(fid4,'%12d %12.6f %12.6f\n',i,a(i-min_cir+1),b(i-min_cir+1));% 保存

        plot(latitude,points,'-o')
%         plot(latitude,r_m,'-o')
%         plot(latitude,points,'-',latitude,points_m,'+-r')
        xlabel('Latitude/°')
        ylabel('Wet troposhere delay from Jason-2 AMR/mm')

        % 判断Y轴最大最小范围
        %radiometer和model同判断
        if ((min_y>min(points))|| (min_y>min(points_m)))
            if min(points)>=min(points_m)
                min_y=min(points_m);
            else
                min_y=min(points);
            end
        end
        if (max_y<max(points) || max_y<max(points_m))
            if max(points)>=max(points_m)
                max_y=max(points);
            else
                max_y=max(points_m);
            end
        end
        % radiometer only
    %      if min_y>min(points)
    %          min_y=min(points);
    %      end
    %     if max_y<max(points) 
    %         max_y=max(points);
    %     end
    end
end 
fclose(fid4);
hold off

figure (6)
if sat==1
    load ..\test\ja2_check\statistic.txt
elseif sat==4
    load ..\test\ja3_check\statistic.txt
end
w_m=statistic(:,2);
% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% 三倍中误差，剔除粗差
hehe=std(w_m);% tmpp表示需要修正的数据，ttt没有实质作用。
hehe2=mean(w_m);
hehe3=hehe2+3*hehe;
hehe4=hehe2-3*hehe;
[n]=find(w_m(:,1)>hehe3);
statistic(n,1)=NaN;
[n]=find(w_m(:,1)<hehe4);
statistic(n)=NaN;
statistic(any(isnan(statistic), 2),:) = [];%把NaN的行去掉
% &%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sat==1
    save ..\test\ja2_check\ja2_wet_m_model.txt statistic -ascii
elseif sat==4
    save ..\test\ja3_check\ja3_wet_m_model.txt statistic -ascii
end

plot(statistic(:,1),-statistic(:,2),'-o',statistic(:,1),statistic(:,3),'-ro');
disp('mean of radiometer and model wet dely')
-mean (statistic(:,2)) % Be attention the -. Nagetive means shorter.
disp('STD of radiometer and model wet dely')
mean (statistic(:,3))

xlabel('周期')
ylabel('辐射计-Model的湿延迟/mm')
legend('Mean','Std')

return