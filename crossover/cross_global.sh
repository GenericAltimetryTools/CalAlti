#!/usr/bin/env bash

export X2SYS_HOME=.
gmt set TIME_UNIT s

gmt gmtset FORMAT_DATE_OUT jjj
gmt gmtset MAP_FRAME_WIDTH = 0.02c FORMAT_GEO_MAP = dddF
gmt gmtset FONT_ANNOT_PRIMARY	= 7p
gmt gmtset FONT_LABEL 7 MAP_LABEL_OFFSET 5p

# 去重，HY-2数据中有重复的位置。和数据制作有关系.sort 按照时间先后排列，规范数据格式。筛选出半球数据。分别计算交叉点。

awk '!a[$3]++' hy2b.txt | sort -k 3  | gmt gmtselect  -R0/360/-60/0 >order.dat

# gmt info order.dat

# 初始化x2sys，可以仅运行一次。
gmt x2sys_init CROSSHY2 -Dxys -Edat -V -I1  -G -Ndk -Wd100 -F 
# 计算文件的自交叉点，-Qi
gmt x2sys_cross -TCROSSHY2  order.dat  -Qi -W2 -R  > outs.txt

# 北半球的交叉点计算
awk '!a[$3]++' hy2b.txt | sort -k 3  | gmt gmtselect  -R0/360/0/60 >order2.dat
gmt x2sys_cross -TCROSSHY2  -Qi -W2 -R order2.dat > outn.txt
# make plot
gmt psbasemap -R0/360/-60/60 -JM6i -P -K -Bx30 -By20 > crossover.ps
gmt pscoast -R -J -K -W1/0.25p -Dl -Glightyellow -P -A1000 -O >> crossover.ps
gmt psxy -R -J -O  order*.dat  -Sc0.01i -Gblack -K >> crossover.ps
gmt psxy -R -J -O  out*.txt  -Sc0.03i -Gred  >> crossover.ps

# make plot
awk ' NR>4 && $11>-259200*3 && $11< 259200*3 && $2>-50 && $2<50 && $13>-0.5 && $13<0.5 {print $1,$2,$13}' outs.txt > ja_t.d
awk ' NR>4 && $11>-259200*3 && $11< 259200*3 && $2>-50 && $2<50  && $13>-0.5 && $13<0.5 {print $1,$2,$13}' outn.txt >> ja_t.d

gmt gmtmath ja_t.d -Sl -Ca MEAN  = 
gmt gmtmath ja_t.d -Sl -Ca STD  = 

gmt psbasemap -R0/360/-67/67 -JM6i -P -K -Bx30 -By20 > distribution.ps
gmt pscoast -R -J -K -W1/0.25p -Dl -Glightyellow -P -A1000 -O >> distribution.ps

gmt psxy -R -J -O  out*.txt  -Sc0.01i -Gblack -K >> distribution.ps
rem plot points with time difference less than distribution days.
gmt psxy -R -J -O  ja_t.d  -Sc0.01i -Gred  >> distribution.ps

gmt psconvert distribution.ps -A -P -Tg
gmt psconvert crossover.ps -A -P -Tg
rm *.hist* order*.dat out* ja_t*