% Tandem J2/3 compare

oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

% f=fopen('C:\Users\yangleir\Documents\rads\J3\j3p0153c000.asc'); %以只读模式打开混合格式文本文件
% 
% k=[];
% for i=0:23
%     c=num2str(1000+i);
%     c2=num2str(1280+i);
%     fname=strcat('j3p0153c',c(2:4),'.asc');
%     fname2=strcat('j2p0153c',c2(2:4),'.asc');
%     order=['gmtselect -R118/124/36/37 C:\Users\yangleir\Documents\rads\J3\',fname,' -h+d12 -i2,1,3 -sa'];
%     temp = gmt(order);
%     order=['gmtselect -R118/124/36/37  C:\Users\yangleir\Documents\rads\J2\',fname2,' -h+d12 -i2,1,3 -sa'];
%     temp2 = gmt(order);
% 
%     psname='..\temp\test.ps';
%     order=['pscoast -R121/122/36/37 -JM3i  -Bga -BSWen -Df -W0.1 -Glightyellow -K > ',psname];
%     gmt(order);  
% 
%     order=['psxy -J -R -Sc0.2c -Wred -O -K >> ',psname];
%     gmt(order,[121.386 36.2681]) % The diameter is 50km based on the projection scalor.
% 
%     order=['psxy -J -R -Sc0.1c -O -K >> ',psname];
%     gmt(order,temp.data) % The diameter is 50km based on the projection scalor.
%     order=['psxy -J -R -Sc0.05c -Wblue -O -K >> ',psname];
%     gmt(order,temp2.data) % The diameter is 50km based on the projection scalor.
% %     i
%     if (~isempty(temp)) && (~isempty(temp2))
%         i
%         y1=interp1(temp.data(:,2),temp.data(:,3),temp2.data(:,2),'spline');
%         dif=y1-temp2.data(:,3);
% 
%         k(i+1)=mean(dif);
%     end  
% end
% 
% s=std(k);
% plot(k)
% mean(k)

%% Jason-2/3 at the tendem phase
% read Jason-3 SSH
pass_num=153;
min_cir=0;
max_cir=23;
min_lat=34000000;
max_lat=37000000;
dir_0='C:\Users\yangleir\Documents\aviso\Jason3\';% data directory 
tg_cal_read_jason3(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0)

% read Jason-2 SSH
dir_0='C:\Users\yangleir\Documents\aviso\Jason2\';% data directory 
min_cir=280;
max_cir=303;
tg_cal_read_jason(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0)

%% 

k=[];
for i=0:23
    c=num2str(1000+i);
    c2=num2str(1280+i);
    fname=strcat(c(2:4),'_153.dat');
    fname2=strcat(c2(2:4),'_153.dat');
    order=['gmtselect -R118/124/34/37 C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\ja3_check\',fname,' -i0,1,5 -sa'];
    temp = gmt(order);
    order=['gmtselect -R118/124/35/36.5  C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\ja2_check\',fname2,' -i0,1,5 -sa'];
    temp2 = gmt(order);

    psname=strcat('..\temp\test_',num2str(i),'.ps');
    order=['pscoast -R121/122/36/37 -JM3i  -Bga -BSWen -Df -W0.1 -Glightyellow -K > ',psname];
    gmt(order);  

    order=['psxy -J -R -Sc0.2c -Wred -O -K >> ',psname];
    gmt(order,[121.386 36.2681]) % The diameter is 50km based on the projection scalor.

    order=['psxy -J -R -Sc0.1c -O -K >> ',psname];
    gmt(order,temp.data) % The diameter is 50km based on the projection scalor.
    order=['psxy -J -R -Sc0.05c -Wblue -O -K >> ',psname];
    gmt(order,temp2.data) % The diameter is 50km based on the projection scalor.
%     i
    if (~isempty(temp)) && (~isempty(temp2))
        i
        y1=interp1(temp.data(:,2),temp.data(:,3),temp2.data(:,2),'spline');
        lon1=interp1(temp.data(:,2),temp.data(:,1),temp2.data(:,2),'linear');
        
        mss1=gmt('grdtrack  -G..\mss\qly.nc',[lon1 temp2.data(:,2)]);
        mss2=gmt('grdtrack  -G..\mss\qly.nc',[temp2.data(:,1) temp2.data(:,2)]);
        
        d_mss=mss1.data-mss2.data;
        d_mss_mean=mean(d_mss);
        dif=y1-temp2.data(:,3);

        k(i+1)=mean(dif);
    end  
end

std(k)
plot(k)
mean(k)
