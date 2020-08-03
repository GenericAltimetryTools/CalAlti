function spa=fit_dis(dis,m,dis_0)
    x=dis.data(1:m-3,5);
    y=dis.data(1:m-3,3);
    myfittype = fittype('a - b*exp(-x/c)',...
        'dependent',{'y'},'independent',{'x'},...
        'coefficients',{'a','b','c'})
    myfit = fit(x,y,myfittype,'StartPoint',[1 1 200]);
    figure (121)
    plot(myfit,x,y);hold on 
    errorbar(x,y,dis.data(1:m-3,4),'o')
    % 
    spa=myfit.a - myfit.b*exp(-dis_0/myfit.c);
    disp(['The spatial rms is estimated to be:',num2str(spa)])
return
