#!/usr/bin/env bash
export X2SYS_HOME=.
gmt set TIME_UNIT s

# 去重，HY-2数据中有重复的位置。和数据制作有关系.sort 按照时间先后排列，规范数据格式。筛选出半球数据。分别计算交叉点。
# gmt select test2.txt -R104/124/0/25 > hy2b.txt
awk '!a[$3]++' hy2b.txt | sort -k 3 >0063_1.dat

# gmt info 0063_1.dat

# 初始化x2sys，可以仅运行一次。
gmt x2sys_init CROSSHY2 -Dxys -Edat -V -I1  -G -Ndk -Wd100 -F 
# 计算文件的自交叉点，-Qi
gmt x2sys_cross -TCROSSHY2  0063_1.dat  -Qi -W2 -R  > outs.txt

# make plot
gmt psbasemap -R104/124/0/25 -JM6i -P -K -Bx30 -By20 > test.ps
gmt pscoast -R -J -K -W1/0.25p -Dl -Glightyellow -P -A1000 -O >> test.ps
gmt psxy -R -J -O  0063_*.dat  -Sc0.01i -Gblack -K >> test.ps
gmt psxy -R -J -O  out*.txt  -Sc0.03i -Gred  >> test.ps

gmt psconvert test.ps -A -P -Tg
rm *.hist* 0063*.dat 