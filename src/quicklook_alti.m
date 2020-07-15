% Plot the altimeter data and have a quick look of the data
function quicklook_alti(min_cir,max_cir,min_lat,max_lat,pass_num,sat)
% ###############################################
% draw figure for statistic 
if sat==5
    disp('------Sa3----')
    load ..\test\s3a_check\ponits_circle.txt
    load  ..\test\s3a_check\ponits_number.txt
    fid4=fopen('..\test\s3a_check\statistic.txt','w');
    temp='..\test\s3a_check\';
elseif sat==1
    disp('------Jason-2----')
    load ..\test\ja2_check\ponits_circle.txt
    load  ..\test\ja2_check\ponits_number.txt
    fid4=fopen('..\test\ja2_check\statistic.txt','w');
    temp='..\test\ja2_check\';
elseif sat==4
    disp('------Jason-3----')
    load ..\test\ja3_check\ponits_circle.txt
    load  ..\test\ja3_check\ponits_number.txt
    fid4=fopen('..\test\ja3_check\statistic.txt','w');
    temp='..\test\ja3_check\';
end

latitude=ponits_circle(:,1);
points=ponits_circle(:,2);
cir_number=ponits_number(:,2);
circle=ponits_number(:,1);

figure(1);
hold on

plot(latitude,points,'o')
xlabel('latitude/\circ')
ylabel('Cycle number')
ylim([min(points) max(points)]);
xlim([min_lat/1E6 max_lat/1E6])

for i=1:length(circle)
text(36.48,circle(i),num2str(cir_number(i)),'FontSize',10)
end

grid on
hold off
% *************************************************************************
% 绘图SSH每周期观测值，以及均值

a(1:(max_cir-min_cir+1))=0;% 存储SSH

figure(2);
hold on
for i=min_cir:max_cir
% for i= [200] % 只处理一个周期的一个pass数据，例如i [200] 表示200周期

        
        temp1=check_circle(i);% 调用函数，判断circle的位数。
        temp2=num2str(temp1);
        temp3=temp2(3:5);% 组成三位数的字符串。
        tmp=strcat('_',num2str(pass_num));
        temp4= strcat(temp,temp3,tmp,'.dat');
        temp5= strcat('X',temp3,tmp);
    if exist(temp4,'file')
        load (temp4)
        temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
        
        if size(temp6)~=0
            latitude=temp6(:,2);
            ssh_=temp6(:,5);
            a(i-min_cir+1)=mean(ssh_);% 计算SSH均值
%           b(i-min_cir+1)=std(points);% 计算std
            fprintf(fid4,'%12d %12.6f \n',i,a(i-min_cir+1));% 保存

            plot(latitude,ssh_,'-o')
            xlabel('Latitude/\circ')
            ylabel('SSH/m') 
        end
    end
end 

fclose(fid4);

xlim([min_lat/1E6 max_lat/1E6])

hold off

% clear all
figure (3)
temp5= strcat(temp,'statistic.txt');
load (temp5)
plot(statistic(:,1),statistic(:,2),'-o');
xlabel('cycle bumber')
ylabel('MSSH/mm')
legend('Mean')


return