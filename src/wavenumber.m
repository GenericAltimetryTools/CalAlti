%% wavenumber spectrum

oldpath = path; % Add GMT path. The GMT is available from https://github.com/GenericMappingTools/gmt
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
%% Jason1
file=ls ('C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\HY2B_Cross_validation\ja2\j2*asc.txt');
file_num=length(file);
k=1;
for n=1:150
    filepath=strcat('C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\HY2B_Cross_validation\ja2\',file(n,:))
    ssa=load (filepath);
    if size(ssa)~= 0 
        data=[ssa(:,5) ssa(:,3)];
        data2=gmt('sample1d  -Fn -T5.858',data);
        Sx = dat2spec(data2.data,64);%
        f1(:,k)=Sx.w/2/pi;
        p1(:,k)=Sx.S*2*pi;
        loglog(Sx.w/2/pi,Sx.S*2*pi,'red'); hold on
        k=k+1;
        index(k)=n;
    end
end
ff1=mean(f1,2);
pp1=mean(p1,2);
std3=std(p1,0,2);

% 90:257
pp1_timeseries=mean(p1(90:257,:),1);
plot(pp1_timeseries)
mean(pp1_timeseries);
std(pp1_timeseries);
% temp2=[pp1_timeseries;index];
% 
% Sx = dat2spec(temp2,64);%
% plot(Sx.w/2/pi,Sx.S*2*pi,'red'); 
        
%% Jason2
file=ls ('C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\HY2B_Cross_validation\ja2\j1*asc.txt');
file_num=length(file);

for n=1:36
    filepath=strcat('C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\HY2B_Cross_validation\ja2\',file(n,:))
    ssa=load (filepath);
    if size(ssa)~= 0 
        data=[ssa(:,5) ssa(:,3)];
        data2=gmt('sample1d  -Fn -T5.858',data);
        Sx = dat2spec(data2.data,64);%
        f2(:,n)=Sx.w/2/pi;
        p2(:,n)=Sx.S*2*pi;
        loglog(Sx.w/2/pi,Sx.S*2*pi,'blue'); hold on
    end
end

ff2=mean(f2,2);
pp2=mean(p2,2);



% read HY-2B SSH
dir_0='D:\hy2b\GDR_2P\';%
min_lat=-50000000; %
max_lat=30000000; %
min_cir=2;% cycle 5 have problems
max_cir=54;%
%           pass_num=319;% define the pass number
pass_num=pass_2ato2b(126);   % 333£»195;85

% tg_cal_read_hy2(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0);

%% HY-2B
file=ls ('C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\hy2_check\*_0367.dat');
file2=ls ('C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\hy2_check\*_0119.dat');
file5=ls ('C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\hy2_check\*_0298.dat');
file4=ls ('C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\hy2_check\*_0257.dat');
file3=[file;file2;file4;file5];
file_num=length(file3);


k=1;
f3=[];p3=[];
for n=1:file_num
    filepath=strcat('C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\test\hy2_check\',file3(n,:))
    ssa=load (filepath);
    ellip=gmt('mapproject  -fg -Gn+a+i+uk -i0,1,5',ssa);
    if size(ssa)~= 0 
        data=[ellip.data(:,5) ellip.data(:,3)];
        data2=gmt('sample1d  -Fn -T6.4',data);
%         Sx = dat2spec(data2.data,64);%
        Sx = dat2spec(data,64);%

        if mean(Sx.S(40:254))*2*pi<0.12/(2*pi) % filter bad data.
            loglog(Sx.w/2/pi,Sx.S*2*pi,'yellow'); hold on
            f3(:,k)=Sx.w/2/pi;
            p3(:,k)=Sx.S*2*pi;
            k=k+1;
        end
    end
end

ff3=mean(f3,2);
pp3=mean(p3,2);
std3=std(p3,0,2)
%% Plot 
figure (2);
loglog(ff2,pp2,'blue',ff1,pp1,'red',ff3,pp3,'black',ff1,std3,'black'); hold on

%% Noise level of altimeter
noise=sqrt(90*(1/2/5.858));% Jason
noise=sqrt(90*(1/2/6.4));% HY-2B
%% Out
out=[ff1 pp1 ff2 pp2 ff3 pp3];
save psd.txt out -ascii
%% calculate the error budget.
error=sqrt(2.6^2+0.3^2+2^2+0.7^2+1.2^2+1^2);

noise_cal=sqrt(4.8^2-(0.3^2+2^2+0.7^2+1.3^2+1^2)-0.5^2);
noise_cal=sqrt(2.8^2-(0.3^2+2^2+0.7^2+1.2^2+1^2)-0.5^2);
noise_cal=sqrt(3.4^2-(0.3^2+2^2+0.7^2+1.3^2+1^2)-0.5^2);

sqrt(4.7^2+5.5^2+4.1^2+3.6^2)/2;
noise_cal=sqrt(4.2^2-(0.3^2+2^2+0.7^2+1.1^2+1^2)-0.5);

mean(0.4+0.1-1.2+1.2)
mean(-0.1+0.1-0.4+1.1)
a=[5.1,8.3,5.5,3.9];rms(a)
a=[4.7,4.9,4.1,3.6];rms(a)
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2_zhws.txt
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2_zmw1.txt
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2_zmw2.txt
load C:\Users\yangleir\Documents\jianguoyun\Documents\reseach\J-STARS\figures\bias\bias_last_hy2_qly.txt

hy2=[bias_last_hy2_qly; bias_last_hy2_zhws; bias_last_hy2_zmw2; bias_last_hy2_zmw1];
std(hy2(:,4))
mean(hy2(:,4))

bias_last_hy2_zhws(:,4)=bias_last_hy2_zhws(:,4)-mean(bias_last_hy2_zhws(:,4));
bias_last_hy2_zmw1(:,4)=bias_last_hy2_zmw1(:,4)-mean(bias_last_hy2_zmw1(:,4));
bias_last_hy2_zmw2(:,4)=bias_last_hy2_zmw2(:,4)-mean(bias_last_hy2_zmw2(:,4));
bias_last_hy2_qly(:,4)=bias_last_hy2_qly(:,4)-mean(bias_last_hy2_qly(:,4));
hy2=[bias_last_hy2_qly; bias_last_hy2_zhws; bias_last_hy2_zmw2; bias_last_hy2_zmw1];
std(hy2(:,4));

hy2new=sortrows(hy2,5);
plot(hy2new(:,5),hy2new(:,4));
temp=[hy2new(:,5),hy2new(:,4)];

Sx = dat2spec(temp,64);
plot(1./(Sx.w/2/pi)/(365*24*3600),Sx.S*2*pi,'red'); 


a=[3.0,3.5,4.0,4.6,4.3,4.5,4.0,3.9,3.7,4.0,4.1,3.8,3.6,3.4,3.4,3.7];rms(a)
a=[3.3,2.9,3.3,3.2,3.3,2.4,2.4,2.8,2.5];b=rms(a)
noise_cal=sqrt(b^2-(0.3^2+2^2+0.7^2+1.4^2+1^2)-0.5^2)

%% estimate the noise level of TDdata. Try
clear
tg=load ('..\tg_xinxizx\zmw\zmw.oneyear');
tmp000=tg;
tmp1=tmp000(:,1); %yyyymmddHHMM
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
hh=str2num(tmp(:,9:10));
ff=str2num(tmp(:,11:12));
ss(1:length(ff))=0;
ss=ss';
ssh=tmp000(:,2)/100;
date_yj = [yyyy  mm dd hh ff ss];

t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);%
tm2=round(t3*86400);
data=[tm2 ssh];

Sx = dat2spec(data(1:2000,:),64);
loglog(Sx.w/2/pi,Sx.S*2*pi,'red'); 

sqrt(0.16*1/(600*2));% Noise of ZMW. Close to 1cm
sqrt(0.011*0.0016);% Noise of ZMW. Close to 1cm

sqrt(0.01*1/(300*2));% Noise of ZMW. For 5 min, close to 0.5 cm

%
clear
tg=load ('..\tg_xinxizx\qly\QLY_2011_2018_clean.txt');
tmp000=tg;
tmp1=tmp000(:,1); %yyyymmddHHMM
tmp=num2str(tmp1);
yyyy=str2num(tmp(:,1:4));
mm=str2num(tmp(:,5:6));
dd=str2num(tmp(:,7:8));
hh=str2num(tmp(:,9:10));
ff=str2num(tmp(:,11:12));
ss(1:length(ff))=0;
ss=ss';
ssh=tmp000(:,2)/100;
date_yj = [yyyy  mm dd hh ff ss];

t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);%
tm2=round(t3*86400);
data=[tm2 ssh];

Sx = dat2spec(data,64);
loglog(Sx.w/2/pi,Sx.S*2*pi,'red'); 

sqrt(0.11*1/(600*2));% Noise of QLY. Close to 1cm




