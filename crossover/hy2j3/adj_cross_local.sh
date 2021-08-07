#!/usr/bin/env bash

export X2SYS_HOME=.
rm -rf CROSSHY2
gmt set TIME_UNIT s

gmt gmtset FORMAT_DATE_OUT jjj
gmt gmtset MAP_FRAME_WIDTH = 0.02c FORMAT_GEO_MAP = dddF
gmt gmtset FONT_ANNOT_PRIMARY	= 7p
gmt gmtset FONT_LABEL 7 MAP_LABEL_OFFSET 5p
R=-R121/122/36:00/37:10
# 
gmt x2sys_init CROSSHY2 -Dxys -Edat -G -F $R

echo "data" >> CROSSHY2/CROSSHY2_paths.txt
(cd data; ls *.dat) > hy2.lis
# 
gmt x2sys_cross -TCROSSHY2  =hy2.lis  -Qe -Ia -V $R  > outs.txt

awk ' NR>3 && $11>-86400*3 && $11< 86400*3 && $17>-0.1 && $17<0.1 {print $1,$2,$17}' outs.txt > hy_t.d

gmt gmtmath hy_t.d -Sl -Ca MEAN  = 
gmt gmtmath hy_t.d -Sl -Ca STD  = 
# plot
gmt psbasemap $R -JM6c -P -K -Ba > crossover.ps
gmt pscoast -R -J -K -W1/0.25p -Df -Glightyellow -P -A1000 -O >> crossover.ps
gmt psxy -R -J -O  data/*.dat  -W0.1 -Gblack -K >> crossover.ps
gmt psxy -R -J -O  hy_t.d  -Sc0.03i -Gred  >> crossover.ps

gmt psconvert crossover.ps -A -P -Tg
rm *.hist*  *.eps  *.cpt