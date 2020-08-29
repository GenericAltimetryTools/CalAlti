% Plot map with GMT (mainly pswiggle).
% Plot the wet pd slope to check the land influence.

% Author: Yang Lei
% 2020-08-25

function plot_gmt_grid(sat)

if sat==1
    temp='..\test\ja2_check\';
elseif sat==4
    temp='..\test\ja3_check\';
elseif sat==3
    temp='../test/hy2_check/';    
end

% temp1=check_circle(cir);% 调用函数，判断circle的位数。
% temp2=num2str(temp1);
% temp3=temp2(2:5);% 组成三位数的字符串。
str='*_*.txt'; % only get the specified cycle.
namelist = ls(fullfile(temp,str));% 这里ls可以和dir替换
len=size(namelist);

k=1;
for  n=1:len
    
    filepath=strcat(temp,namelist(n,:));
    if k==1
        order=['select -o0,1,4 ',filepath,'   >  ../temp/out.txt'];
        gmt(order); 
    else
%         !gawk "{print $1,$2,-$3+$4}" ..\test\hy2_check\0013_0385.txt > ..\test\hy2_check\out.txt 
        order=['select -o0,1,4 ',filepath,'   >>  ../temp/out.txt'];
        gmt(order); 
    end    
    k=k+1;
    
    Q=['The number is:' num2str(k)];
    disp(Q)

end

% call GMT
% blockmean and surface 
gmt ('blockmean -R0/360/-81/81  ../temp/out.txt -I20m >  ../temp/tmp.d')
gmt ('surface ../temp/tmp.d -R0/360/-81/81 -I20m -G../temp/gridded.nc -T0.25')
gmt ('makecpt -Crainbow -T-40/40/1 > ../temp/t.cpt')

gmt ('grdimage ../temp/gridded.nc -Ei -Rg -JA180/10/8c -K -C../temp/t.cpt > ../temp/grid.ps')
gmt ('pscoast  -R -J -Dl -A10000/0/1 -Bag -Gwhite -W0.1p  -O >> ../temp/grid.ps')
gmt ('psscale -DjBC+o0c/-0.8c+w2.8i/0.08ih -R -J -C../temp/t.cpt -Bxaf -By+lmm -I -O  >>  ../temp/grid.ps')
% gmt ('psconvert  ../temp/grid.ps  -Tf -A ');

return