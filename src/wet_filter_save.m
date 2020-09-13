% -Remove the outliers based on 3 sigma.
% -Plot 
% -Save to file
% The output format : cycle bias time(seconds)

function [bias_std,bias_mean]=wet_filter_save(bias2,sat,min_cir,max_cir,lat3,loc)

    tmpp=bias2(:,2);
    ttt=bias2(:,1);
    tim2=bias2(:,3);
%     std(tmpp)

    [tmpp,ttt,tim2]=three_sigma_delete2(tmpp,ttt,tim2);% 为了保存时间信息，改了中误差剔除程序为three_sigma_delete2，原为three_sigma_delete
    [tmpp,ttt,tim2]=three_sigma_delete2(tmpp,ttt,tim2);
    [tmpp,ttt,tim2]=three_sigma_delete2(tmpp,ttt,tim2);
    % [tmpp,ttt,tim2]=three_sigma_delete2(tmpp,ttt,tim2);
    bias2_radio=[ttt tmpp tim2];

    % plot(bias2(:,1),bias2(:,2),'+')

    bias_mean=mean (bias2_radio(:,2));
    bias_std=std(bias2_radio(:,2));
%     bias_std=rms(bias2_radio(:,2));    
    Q=['wet PD of radiometer-gnss:',' Mean: ', num2str(bias_mean),' STD:',num2str(bias_std)];
    disp(Q);
    %=====================================================================
    bias_model=bias2(:,4);
    ttt=bias2(:,1);
    tim2=bias2(:,3);
    
    [bias_model,ttt,tim2]=three_sigma_delete2(bias_model,ttt,tim2);% 为了保存时间信息，改了中误差剔除程序为three_sigma_delete2，原为three_sigma_delete
    [bias_model,ttt,tim2]=three_sigma_delete2(bias_model,ttt,tim2);
    [bias_model,ttt,tim2]=three_sigma_delete2(bias_model,ttt,tim2);
    % [tmpp,ttt,tim2]=three_sigma_delete2(tmpp,ttt,tim2);
    bias2_model=[ttt bias_model tim2];

    % plot(bias2(:,1),bias2(:,2),'+')
    bias_mean_m=mean (bias2_model(:,2));
    bias_std_m=std(bias2_model(:,2));% std
%     bias_std_m=rms(bias2_model(:,2));% rms. Choose `std` or `rms`?
    Q=['wet PD of model-gnss:',' Mean: ', num2str(bias_mean_m),' STD:',num2str(bias_std_m),'  No:',num2str(length(bias_model))];
    disp(Q);
    %=====================================================================

    % plot_bias(bias2,sat)
    % The names of saved files are changed according to the `lat3`.
if sat==1
    filename1=strcat('..\test\ja2_check\jason_2_bias_wet_new_',loc,num2str(lat3),'.txt');
    save(filename1,'bias2_radio','-ASCII') % 保存结果数据
    filename2=strcat('..\test\ja2_check\jason_2_bias_wet_model_new_',loc,num2str(lat3),'.txt');    
    save(filename2,'bias2_model','-ASCII') % 保存结果数据    
%     save ..\test\ja2_check\jason_2_bias_wet_model_new.txt bias2_model -ASCII % 保存结果数据
elseif sat==4
    filename1=strcat('..\test\ja3_check\jason_3_bias_wet_new_',loc,num2str(lat3),'.txt');
    save(filename1,'bias2_radio','-ASCII') % 保存结果数据
    filename2=strcat('..\test\ja3_check\jason_3_bias_wet_model_new_',loc,num2str(lat3),'.txt');    
    save(filename2,'bias2_model','-ASCII') % 保存结果数据  
    
%     save ..\test\ja3_check\jason_3_bias_wet_new.txt bias2_radio -ASCII % 保存结果数据
%     save ..\test\ja3_check\jason_3_bias_wet_model_new.txt bias2_model -ASCII % 保存结果数据
elseif sat==3
    filename1=strcat('..\test\hy2_check\hy2_bias_wet_new_',loc,num2str(lat3),'.txt');
    save(filename1,'bias2_radio','-ASCII') % 保存结果数据
    filename2=strcat('..\test\hy2_check\hy2_bias_wet_model_new_',loc,num2str(lat3),'.txt');    
    save(filename2,'bias2_model','-ASCII') % 保存结果数据  
    
%     save ..\test\hy2_check\hy2_bias_wet_new.txt bias2_radio -ASCII % 保存结果数据
%     save ..\test\hy2_check\hy2_bias_wet_model_new.txt bias2_model -ASCII % 保存结果数据
    
end
    % 趋势分析
    disp('Radiometer-GNSS');
    [P]=trend_bias(bias2_radio,sat,min_cir,max_cir);
    disp('Model-GNSS');
    [P]=trend_bias(bias2_model,sat,min_cir,max_cir);
return