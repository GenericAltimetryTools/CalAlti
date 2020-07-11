% 测高的s时间转为年月日时分秒
function [ymd]=sec2ydm(sat)
    if sat==3
        load .\hy2_check\pca_ssh.txt;
        fid5 = fopen('pcatime_hy2.txt','w');
    elseif sat==1
        load .\ja2_check\pca_ssh.txt;
        fid5 = fopen('pcatime_ja2.txt','w');
    end
    sect=pca_ssh(:,3);
    lon=pca_ssh(:,2);
    lat=pca_ssh(:,1);
    circ=pca_ssh(:,5);
    mean(lon)
    mean(lat)
    tmp=datestr(sect/86400+datenum('2000-01-1 00:00:00'));% 时间格式转换
    ymd=datevec(tmp);
    tmp2=size(ymd);

    for i=1:tmp2(1)
            fprintf(fid5,'%10.5f %10.5f %10.5f %10.5f %10d %5d %5d %5d %5d %5d \n',lat(i),lon(i),circ(i),sect(i),ymd(i,1),ymd(i,2),ymd(i,3),ymd(i,4),ymd(i,5),ymd(i,6));
    end
    
    
return