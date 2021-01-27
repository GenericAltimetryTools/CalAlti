% statistic for wet PD
clear all
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
% =========================================================================
% Part 1

% %Jason-2
% tmp=[15.5,15.0,10.8,12.7,12.3];
% std(tmp)
% mean(tmp)
% 
% tmp=1./tmp.^2;
% tmp=sum(tmp)
% 
% % tmp=1/15.5^2+1/15.0^2+1/10.8^2+1/12.7^2+1/12.3^2;
% averg=1/15.5^2/tmp*(-5.7)+1/15.0^2/tmp*(-4.0)+1/10.8^2/tmp*(3.2)+1/12.7^2/tmp*(-9.5)+1/12.3^2/tmp*(-11.5)
% 
% % Jason3
% tmp=[13.6,11.1,13.3,11.7,9.8]
% std(tmp)
% mean(tmp)
% 
% tmp=1./tmp.^2;
% tmpp=sum(tmp)
% tmppp=tmp/tmpp;
% % sum(tmppp)
% bias=[-6.6, -7.5, -0.2, -15.0, -12.6];
% averg=sum(tmppp.*bias);
% mean(bias)
% 
% % HY-2B
% tmp=[15.9,10.8,14.6,6.9,18.1,12.0,11,11.8]
% std(tmp)
% mean(tmp)
% 
% tmp=1./tmp.^2;
% tmpp=sum(tmp)
% tmppp=tmp/tmpp;
% % sum(tmppp)
% bias=[-3.6, -4, -8.6, -7.4, -8,-15.6,-17.4,-16.2];
% averg=sum(tmppp.*bias);
% mean(bias)
% % add weight 
% 
% % get the mean of the sigma R of AMR and CMR.
% bias_last_ja2=[14.5, 7.8, 12.5, 11.5, 10.2, 14.5, 13.5, 16.3, 16.4, 12.0, 6.8, 9.3];
% mean(bias_last_ja2)
% bias_last_ja3=[9.0, 8.3, 5.7, 6.3, 11.3, 13.6, 12.5, 16.8, 17.0, 12.4, 8.9, 5.5];
% mean(bias_last_ja3)
% bias_last_hy2=[8.9, 9.4, 12.0, 16.9, 16.9, 14.0, 12.5, 11.0, 10.3, 7.3, 9.2, 18.7, 17.9, 7.0, 14.5, 13.0, 15.5, 13.0, 7.9, 10.8, 15.0];
% mean(bias_last_hy2)
% =========================================================================
% Part 2

% calculate the sigma0 of radiometers
% Jason-2
dwidth=20;
namelist = ls(fullfile('..\test\ja2_check','jason_2_bias_wet_dis_function_*.txt'));% 这里ls可以和dir替换
temp=size(namelist);
file_num=temp(1);
figure (12345)
k=0;
for nm=1:file_num
%     Q=['Jason-2 :',namelist(nm,:)];
%     disp(Q);
    
    filepath=strcat('..\test\ja2_check\',namelist(nm,:));
    sigma0_dist=load (filepath);
    plot(sigma0_dist(:,1),sigma0_dist(:,3));hold on;
    length_sig=length(sigma0_dist);
    output(k+1:k+length_sig,1:3)=sigma0_dist; % store the sigma0 of all sites. Sigma0 vs distance
    k=k+length_sig;
end
hold off

figure (1235)
output2=sortrows(output,1);
plot(output2(:,1),output2(:,3));
% Do fitting
x=output2(1:k,1);
y=output2(1:k,3);
y2 = fillmissing(y,'movmedian',3);
y = low_pass_filter(y2, 2,dwidth,1);

myfittype = fittype('a - b*exp(-x/c)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'});
myfit = fit(x,y,myfittype,'StartPoint',[1 1 200]);

figure (124)
plot(myfit,x,y);

% calculate the sigma(0) at the 0 km, which is the radiometer RMS
spa=myfit.a - myfit.b*exp(-0/myfit.c);
sigma_r=sqrt(spa^2-5^2);
disp(['The radiometer rms is estimated to be:',num2str(sigma_r)])

myfit_value=myfit.a - myfit.b*exp(-x/myfit.c);
out=[x' ;y';myfit_value']';
figure (125)
plot(x,y,'.');hold on;
plot(x,myfit_value)

save ..\test\ja2_check\distance_sig_fit.txt out -ASCII % 保存结果数据

% % J3
namelist = ls(fullfile('..\test\ja3_check','jason_3_bias_wet_dis_function_*.txt'));% 这里ls可以和dir替换
temp=size(namelist);
file_num=temp(1);
figure (12345)
k=0;
for nm=1:file_num
%     Q=['Jason-3 :',namelist(nm,:)];
%     disp(Q);
    
    filepath=strcat('..\test\ja3_check\',namelist(nm,:));
    sigma0_dist=load (filepath);
    plot(sigma0_dist(:,1),sigma0_dist(:,3));hold on;
    length_sig=length(sigma0_dist);
    output(k+1:k+length_sig,1:3)=sigma0_dist; % store the sigma0 of all sites. Sigma0 vs distance
    k=k+length_sig;
end
hold off

figure (1235)
output2=sortrows(output,1);
plot(output2(:,1),output2(:,3));
% Do fitting
x=output2(1:k,1);
y=output2(1:k,3);
% y = fillmissing(y,'movmedian',3);
y2 = fillmissing(y,'movmedian',3);
y = low_pass_filter(y2, 2,dwidth,1);
myfittype = fittype('a - b*exp(-x/c)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'});
myfit = fit(x,y,myfittype,'StartPoint',[1 1 200]);

figure (124)
plot(myfit,x,y);

% calculate the sigma(0) at the 0 km, which is the radiometer RMS
spa=myfit.a - myfit.b*exp(-0/myfit.c);
sigma_r=sqrt(spa^2-5^2);
disp(['The radiometer rms is estimated to be:',num2str(sigma_r)])

myfit_value=myfit.a - myfit.b*exp(-x/myfit.c);
out=[x' ;y';myfit_value']';
figure (125)
plot(x,y,'.');hold on;
plot(x,myfit_value)

save ..\test\ja3_check\distance_sig_fit.txt out -ASCII % 保存结果数据


% HY-2B
namelist = ls(fullfile('..\test\hy2_check','hy2_bias_wet_dis_function_*.txt'));% 这里ls可以和dir替换
temp=size(namelist);
file_num=temp(1);
figure (12345)
k=0;
for nm=1:file_num
%     Q=['HY2-B :',namelist(nm,:)];
%     disp(Q);
    
    filepath=strcat('..\test\hy2_check\',namelist(nm,:));
    sigma0_dist=load (filepath);
    plot(sigma0_dist(:,1),sigma0_dist(:,3));hold on;
    length_sig=length(sigma0_dist);
    output(k+1:k+length_sig,1:3)=sigma0_dist; % store the sigma0 of all sites. Sigma0 vs distance
    k=k+length_sig;
end
hold off

figure (1235)
output2=sortrows(output,1);
plot(output2(:,1),output2(:,3));
% Do fitting
x=output2(2:k-1,1);
y=output2(2:k-1,3);
y2 = fillmissing(y,'movmedian',3);
y = low_pass_filter(y2, 2,dwidth,1);
myfittype = fittype('a - b*exp(-x/c)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'});
myfit = fit(x,y,myfittype,'StartPoint',[1 1 200]);

figure (124)
plot(myfit,x,y);

% calculate the sigma(0) at the 0 km, which is the radiometer RMS
spa=myfit.a - myfit.b*exp(-0/myfit.c);
sigma_r=sqrt(spa^2-5^2);
disp(['The radiometer rms is estimated to be:',num2str(sigma_r)])

myfit_value=myfit.a - myfit.b*exp(-x/myfit.c);
out=[x' ;y';myfit_value']';
figure (125)
plot(x,y,'.');hold on;
plot(x,myfit_value)

save ..\test\hy2_check\distance_sig_fit.txt out -ASCII % 保存结果数据

% GMT plot
% % gmt()
% j2=load('..\test\ja2_check\distance_sig_fit.txt');
% j3=load('..\test\ja3_check\distance_sig_fit.txt');
% h2=load('..\test\hy2_check\distance_sig_fit.txt');
% 
% gmt('gmtset FONT_ANNOT_PRIMARY=7p MAP_FRAME_PEN=thinner,black FONT_LABEL=7p,4,black FONT_ANNOT_SECONDARY=7p')
% gmt('gmtset MAP_FRAME_WIDTH=0.01c')
% gmt('gmtset FONT_LABEL=7 MAP_LABEL_OFFSET=5p')
% % gmt gmtset MAP_GRID_PEN_PRIMARY	= 0.1p,0/0/0,2_1_0.25_1:0
% order=['psbasemap -R0/400/0/35 -JX5/5  -Bga -BSWen  -K -Bpx+l"Spatial Distance/km"  -Bpy+l"STD of AMR/CMR-GNSS  Wet PD/mm" > ../temp/dist_sigma.ps '];
% gmt(order);  
% 
% gmt('psxy -R -J -W0.05p,blue, -Sc0.01 -Gblue -K -O  >> ../temp/dist_sigma.ps ',j2(:,[1,2]));
% gmt('psxy -R -J -W0.5p,red, -K -O >> ../temp/dist_sigma.ps ',j2(:,[1,3]));
% gmt('psxy -R -J -W0.5p,blue, -Sc0.01 -Gblue -K -O  >> ../temp/dist_sigma.ps ',j3(:,[1,2]));
% gmt('psxy -R -J -W0.5p,red, -K -O >> ../temp/dist_sigma.ps ',j3(:,[1,3]));
% gmt('psxy -R -J -W0.5p,blue, -Sc0.01 -Gblue -K -O  >> ../temp/dist_sigma.ps ',h2(:,[1,2]));
% gmt('psxy -R -J -W0.5p,red,  -O >> ../temp/dist_sigma.ps ',h2(:,[1,3]));
% 
% gmt('psconvert ../temp/dist_sigma.ps -P -Tf -A')

