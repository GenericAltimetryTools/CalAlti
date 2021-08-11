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
error=sqrt(2.9^2+0.3^2+2^2+0.7^2+0.8^2+1^2);

sqrt(3.5^2+2^2);

