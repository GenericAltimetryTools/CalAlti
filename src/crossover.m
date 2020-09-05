% crossover

% First step: read data from nc files. Here take the HY-2B l2p from aviso
% for example.
% define input parameters
clear ;
temp='..\test\hy2_check\';
str=[temp '*.dat'];
delete(str);

dir_0='D:\aviso_hy2_c2_l2p\version_02_00';
min_cir=68; % 
max_cir=68; % 
min_lat=-0*1E6; % Unit degree
max_lat=50*1E6;
min_lon=140*1E6;
max_lon=200*1E6;

read_hy2a_l2p(min_cir,max_cir,min_lat,max_lat,min_lon,max_lon,dir_0); % You may need the read_nc__contents.m first.

% Second step: call GMT to plot the ssh data and have a qucik look.
% Now it only works for HY-2A. Will be improved in the future.
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path
for i=min_cir:max_cir
        
    cir=i;
    temp1=check_circle(cir);% 调用函数，判断circle的位数。
    temp2=num2str(temp1);
    temp3=temp2(2:5);% 组成三位数的字符串。
    str=['*' temp3 '*.dat']; % only get the specified cycle.
    namelist = ls(fullfile(temp,str));% 这里ls可以和dir替换
    len=size(namelist);

    % call GMT
    psname=[' ../temp/cir',num2str(cir),'.ps'];
    mi_lon=floor(min_lon/1E6-1);
    ma_lon=ceil(max_lon/1E6+1);
    mi_lat=floor(min_lat/1E6-1);
    ma_lat=ceil(max_lat/1E6+1);
    bound=[' -R',num2str(mi_lon),'/',num2str(ma_lon),'/',num2str(mi_lat),'/',num2str(ma_lat)];
    order=['pscoast',bound,' -JM10c -Dl -A10000/0/1 -Slightblue  -K -P >',psname];
    gmt(order); 

    for  n=1:len
        filepath=strcat(temp,namelist(n,:));
        s=dir(filepath);
        if s.bytes~=0
%             s.bytes
            order=['psxy -R -J ',filepath,'  -Sc1p -Gblack -O -K >>',psname];
            gmt(order);
        else
            delete(filepath);
        end
    end

    order=['pscoast',bound,' -J -Dl -A10000/0/1 -Bag -BSWEN+t"HY-2B pass" -Glightyellow -O -t50 >> ',psname];
    gmt(order); 
    gmt('psconvert', psname, ' -Tf -A');
end

% Call x2sys to calculate the difference at the crossover points.
