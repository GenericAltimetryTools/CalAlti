% 计算PCA
function [lat3,lon3,tim_pca]=pca(a1,a2,a3)

% a1：输入文件（经纬度，时间，SSH_i），a2输入验潮站纬度，a3输入验潮站经度
% lat3,lon3,time_pca输出的PCA点的坐标和时间

tmp=load (a1);
len=length(tmp(:,1));
lon=tmp(:,1);
lat=tmp(:,2);

% 确定浮标两侧的侧高点
% n表示与GPS浮标点相邻的一点，lat(i)表示在GPS下侧的点的纬度。
n=1;
% 下面的循环有升轨和降轨之区别，但是整体对程序没有影响。
% 下面的循环即使没有判断出i的位置，也可以进行下面的处理。即默认n=1
% 此处，下一步还是要做修正，升轨和降轨要分开对待。
if lat(1) < lat(2)
    for i=1:len-1
       if(lat(i)<a2) && (lat(i+1)>a2) %|| ((lat(i)>a2) && (lat(i+1)<a2))   
            n=i;
        end
    end
end

if lat(1) > lat(2)
    for i=1:len-1
       if (lat(i)>a2) && (lat(i+1)<a2)
            n=i;
        end
    end
end

% haha=datestr (tmp(n+1,3)/(24*3600)+datenum('2000-01-01 00:00:00.0'));
% tim_pca=tmp(n+1,3); % 时间

a=atan((lat(n+1)-lat(n))/(lon(n+1)-lon(n)));%锐角角度，90°减去方位角
k1=((lat(n+1)-lat(n))/(lon(n+1)-lon(n)));%锐角角度，90°减去方位角
k2=-1/k1;

b1=lat(n)-k1*lon(n);
b2=a2-k2*a3;

lon3=(b2-b1)/(k1-k2);% 即PCA经纬度
lat3=k2*lon3+b2;

% 找到最近的PCA点之后，再次确定PCA点的时间。
if lat(1) < lat(2)
    for i=1:len-1
        if((lat(i)<lat3) && (lat(i+1)>lat3) )
          n=i;
        end
    end
end

if lat(1) > lat(2)
    for i=1:len-1
        if((lat(i)>lat3) && (lat(i+1)<lat3) )
          n=i;
        end
    end
end

tim_pca=tmp(n+1,3); % 时间,精确到秒，不必再用小数点。这里的时间主要是对验潮站起作用，而1s的水位变化可忽略

return