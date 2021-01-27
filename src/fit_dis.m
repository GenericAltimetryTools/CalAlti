% Fit the function of the rmse refer to distance
function [myfit]=fit_dis(dis,m,sat)

    x=dis.data(1:m-3,5);
    y=dis.data(1:m-3,3);
    
    myfittype = fittype('a - b*exp(-x/c)',...
        'dependent',{'y'},'independent',{'x'},...
        'coefficients',{'a','b','c'});
    
    myfit = fit(x,y,myfittype,'StartPoint',[1 1 200]);

    figure('Name','Accumulated RMS','NumberTitle','off');

    plot(myfit,x,y);hold on 

    myfit_value=myfit.a - myfit.b*exp(-x/myfit.c);
    out=[x' ;y';dis.data(1:m-3,4)';myfit_value']';
    
    if sat==1
        save ..\test\ja2_check\distance.txt out -ASCII % 保存结果数据
    elseif sat==4
        save ..\test\ja3_check\distance.txt out -ASCII % 保存结果数据
    elseif sat==3
        save ..\test\hy2_check\distance.txt out -ASCII % 保存结果数据    
    end
return
