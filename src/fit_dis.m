function spa=fit_dis(dis,m,dis_0,sat)
    x=dis.data(1:m-3,5);
    y=dis.data(1:m-3,3);
    myfittype = fittype('a - b*exp(-x/c)',...
        'dependent',{'y'},'independent',{'x'},...
        'coefficients',{'a','b','c'});
    myfit = fit(x,y,myfittype,'StartPoint',[1 1 200]);
    figure (121)
    plot(myfit,x,y);hold on 
%     errorbar(x,y,dis.data(1:m-3,4),'o'); % add error bar
    % 
    spa=myfit.a - myfit.b*exp(-dis_0/myfit.c);
    myfit_value=myfit.a - myfit.b*exp(-x/myfit.c);
    disp(['The spatial rms is estimated to be:',num2str(spa)])
    out=[x' ;y';dis.data(1:m-3,4)';myfit_value']';
    if sat==1
        save ..\test\ja2_check\distance.txt out -ASCII % 保存结果数据
    elseif sat==4
        save ..\test\ja3_check\distance.txt out -ASCII % 保存结果数据
    elseif sat==3
        save ..\test\hy2_check\distance.txt out -ASCII % 保存结果数据    
    end
return
