% This function is to do the trend analysis.

function [P]=trend_bias(bias,sat,min_cir,max_cir)
if sat==3
    x=bias(:,1);
    y=bias(:,2);
    [P,S]=polyfit(x,y,1);
    trend_year=P(1)*365/14;
    disp(['The trend of bias (a*x+b) is mm/y:',num2str(trend_year)])
    % [Y,delta]=polyconf(P,x,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%             if sat==4
                x1=min_cir:1:max_cir;
%             else
%                 x1=min_cir:10:max_cir;
%             end
    f=polyval(P,x1);
    figure (21)
    plot(x,y,'-ro',x1,f,'-')%绘图查看拟合效果
    hold on
    [Y,delta]=polyconf(P,x1,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
    plot(x1,Y+delta,'-*g')
    plot(x1,Y-delta,'-*g')%给出拟合的置信区间
    xlabel('Circle')
    ylabel('HY-2B Bias/m')
    
    %  保存趋势信息
    temp21=[x1',f'];
    
    save ..\test\hy2_check\hy2_trend.txt temp21 -ascii
% elseif sat==2
%     x=bias(:,1);
%     y=bias(:,2)*100;
%     [P,S]=polyfit(x,y,1);
%     % [Y,delta]=polyconf(P,x,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%     trend_year=P(1)*365/35;
%     disp(['The trend of bias (a*x+b) is m/y:',num2str(trend_year)])
%     x1=1:2:34;
%     f=polyval(P,x1);
%     figure (21)
%     plot(x,y,'-ro',x1,f,'-')%绘图查看拟合效果
%     hold on
%     [Y,delta]=polyconf(P,x1,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%     plot(x1,Y+delta,'-*g')
%     plot(x1,Y-delta,'-*g')%给出拟合的置信区间
%     xlabel('Circle')
%     ylabel('Saral Bias/cm')
%     
%     %  保存趋势信息
%     temp21=[x1',f'];
%     save saral_trend.txt temp21 -ascii 
    
% elseif sat==5
%     x=bias(:,1);
%     y=bias(:,2)*100;
%     [P,S]=polyfit(x,y,1);
%     trend_year=P(1)*365/27;
%     disp(['The trend of bias (a*x+b) is cm/y:',num2str(trend_year)])
%     % [Y,delta]=polyconf(P,x,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%     x1=min_cir:1:max_cir;
% 
%     f=polyval(P,x1);
%     figure (21)
%     plot(x,y,'-ro',x1,f,'-')%绘图查看拟合效果
%     hold on
%     [Y,delta]=polyconf(P,x1,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%     plot(x1,Y+delta,'-*g')
%     plot(x1,Y-delta,'-*g')%给出拟合的置信区间
%     xlabel('Circle')
%     ylabel('sentinel3-A Bias/cm')
%     
%     %  保存趋势信息
%     temp21=[x1',f'];
%     save ..\test\s3a_check\trend.txt temp21 -ascii
elseif sat==1 
    x=bias(:,1);
    y=bias(:,2);
    [P,S]=polyfit(x,y,1);
    trend_year=P(1)*36.5;% the cycle is 10 day. 36.5 is the cycles per year
    disp(['The trend of bias (a*x+b) is m/y:',num2str(trend_year)])
    % [Y,delta]=polyconf(P,x,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%             if sat==4
%                 x1=min_cir:1:max_cir;
%             else
                x1=min_cir:10:max_cir;
%             end
    f=polyval(P,x1);
    figure (21)
    plot(x,y,'-ro',x1,f,'-')%绘图查看拟合效果
    hold on
    [Y,delta]=polyconf(P,x1,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
    plot(x1,Y+delta,'-*g')
    plot(x1,Y-delta,'-*g')%给出拟合的置信区间
    xlabel('Circle')
    ylabel('Jason-2 Bias/m')
    
    %  保存趋势信息
    temp21=[x1',f'];
    save ..\test\ja2_check\ja2_trend.txt temp21 -ascii
    
elseif  sat==4
    x=bias(:,1);
    y=bias(:,2);
    [P,S]=polyfit(x,y,1);
    trend_year=P(1)*36.5;
    disp(['The trend of bias (a*x+b) is m/y:',num2str(trend_year)])
    % [Y,delta]=polyconf(P,x,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
%             if sat==4
                x1=x(1):1:x(end);
                
                
%             else
%                 x1=min_cir:10:max_cir;
%             end
    f=polyval(P,x1);
    figure (21)
    plot(x,y,'-ro',x1,f,'-')%绘图查看拟合效果
    hold on
    [Y,delta]=polyconf(P,x1,S);%给出回归Y的95%的置信区间为[Y-delta，Y+delta]
    plot(x1,Y+delta,'-*g')
    plot(x1,Y-delta,'-*g')%给出拟合的置信区间
    xlabel('Circle')
    ylabel('Jason-3 Bias/m')
    
    %  保存趋势信息
    temp21=[x1',f'];
    save ..\test\ja3_check\ja3_trend.txt temp21 -ascii
end

return