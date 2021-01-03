% Statistic of HY-2B
format long
clear all

% Check the impact of data length on the trend estimation.
bias = load ('..\test\ja2_check\bias_last_ja2_qly.txt');
bias = load ('C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_ja2_qly.txt');
x1=bias(:,5)/(365*86400); % This time is same with next line 
x=bias(:,3)/(36.5); % cycle to year
y=bias(:,4)*1000; % meter to mm. 
trend_year=[];
for i=2:length(x)-1
    [P,S]=polyfit(x(2:i+1),y(2:i+1),1);
    trend_year(i)=P(1);% second to year
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year(i))])
end
figure (1)
plot(trend_year(10:length(x)-1))
% semilogy(trend_year)
[P,S]=polyfit(x,y,1);
disp(['The trend of bias (a*x+b) is mm/y:',num2str(P)])

% Check STD and mean
mean_bias=[];
std_bias=[];
for i=1:length(x)-1
    mean_bias(i)=mean(y(1:i+1));% second to year
    std_bias(i)=std(y(1:i+1));
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(mean_bias(i))])
end
figure (2)
plot(mean_bias(1:length(x)-1));hold on
plot(std_bias(1:length(x)-1))


 