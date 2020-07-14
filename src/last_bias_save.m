% 
function last_bias_save(sat)
    if sat==3
        load .\hy2_check\pca_ssh.txt;
        fid5 = fopen('bias_last_hy2.txt','w');
        load .\hy_2_bias.txt;
        bias_circ=hy_2_bias(:,1);
        bias_last=hy_2_bias(:,2);
    elseif sat==5
        load ..\test\s3a_check\pca_ssh.txt;
        fid5 = fopen('..\test\s3a_check\bias_last.txt','w');
        b=load ('..\test\s3a_check\s3a_bias.txt');
        bias_circ=b(:,1);
        bias_last=b(:,2);
    end
    if sat==1
        load ..\test\ja2_check\pca_ssh.txt;
        b=load ('..\test\ja2_check\ja2_bias.txt');
        fid5 = fopen('..\test\ja2_check\bias_last_ja2.txt','w');
        bias_circ=b(:,1);
        bias_last=b(:,2);
    end
    if sat==4
        load ..\test\ja3_check\pca_ssh.txt;
        b=load ('..\test\ja3_check\ja3_bias.txt');
        fid5 = fopen('..\test\ja3_check\bias_last_ja3.txt','w');
        bias_circ=b(:,1);
        bias_last=b(:,2);
    end
    
    if sat==2
        load .\saral_check\pca_ssh.txt;
        load .\saral_2_bias_2013_2016.txt;
        fid5 = fopen('bias_last_sa3.txt','w');
        bias_circ=saral_2_bias_2013_2016(:,1);
        bias_last=saral_2_bias_2013_2016(:,2);
    end
    
    sect=pca_ssh(:,3);
    lon=pca_ssh(:,2);
    lat=pca_ssh(:,1);
    circ=pca_ssh(:,5);
     
    tmp=datestr(sect/86400+datenum('2000-01-1 00:00:00'));% 时间格式转换
    ymd=datevec(tmp);
    tmp2=size(ymd);
    tmp3=size(bias_circ);
    z=0;
    
    fprintf(fid5,'%10s %10s %10s %10s %10s %5s %5s %5s %5s %5s %5s \n','lat','lon','circ','bias','time_sec','year','month','day','hour','min','sec');
    
    for i=1:tmp2(1)
        for j=1:tmp3
            if circ(i)==bias_circ(j)
                z=z+1;
                fprintf(fid5,'%10.5f %10.5f %10.5f %10.5f %10.0f %5d %5d %5d %5d %5d %5d \n',lat(i),lon(i),bias_circ(j),bias_last(j),sect(i),ymd(i,1),ymd(i,2),ymd(i,3),ymd(i,4),ymd(i,5),ymd(i,6));
            end
        end
    end    
    
return