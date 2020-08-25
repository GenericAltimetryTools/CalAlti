% Plot map with GMT (mainly pswiggle).
% Plot the wet pd slope to check the land influence.

% Author: Yang Lei
% 2020-08-25

function plot_gmt_pass(cir,sat)

if sat==1

    temp='..\test\ja2_check\';
elseif sat==4
    temp='..\test\ja3_check\';
elseif sat==3
    temp='..\test\hy2_check\';    
end

temp1=check_circle(cir);% 调用函数，判断circle的位数。
temp2=num2str(temp1);
temp3=temp2(2:5);% 组成三位数的字符串。
str=[temp3 '*.txt']; % only get the specified cycle.
namelist = ls(fullfile(temp,str));% 这里ls可以和dir替换
len=size(namelist);

% call GMT
psname=[' wetg',num2str(cir),'.ps'];
bound=' -R0/360/-85/85';
order=['pscoast',bound,' -Jj1:250000000 -Dl -A10000/0/1 -Slightblue  -K -P >',psname];
gmt(order); 

for  n=1:len
    
    filepath=strcat(temp,namelist(n,:));
    order=['psxy -R -J ',filepath,'  -W0.1p,black -O -K >>',psname];
    gmt(order); 
end

order=['pscoast',bound,' -J -Dl -A10000/0/1 -Bag -BSWEN+t"HY-2B pass" -Glightyellow -O >> ',psname];
gmt(order); 
gmt('psconvert', psname, ' -Tf -A');

return