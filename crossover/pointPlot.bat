rem 将点展开绘图，黑白
rem select crossover point with time difference less than 3 days.
gawk " NR>4 && $11>-259200*3 && $11< 259200*3 && $2>-50 && $2<50 && $13>-0.5 && $13<0.5 {print $1,$2,$13}" outs.txt > ja_t.d
gawk " NR>4 && $11>-259200*3 && $11< 259200*3 && $2>-50 && $2<50  && $13>-0.5 && $13<0.5 {print $1,$2,$13}" outn.txt >> ja_t.d

gmt gmtmath ja_t.d -Sl -Ca MEAN  = 
gmt gmtmath ja_t.d -Sl -Ca STD  = 

gmt psbasemap -R0/360/-67/67 -JM6i -P -K -Bx30 -By20 > distribution.ps
gmt pscoast -R -J -K -W1/0.25p -Dl -Glightyellow -P -A1000 -O >> distribution.ps

gmt psxy -R -J -O  out*.txt  -Sc0.01i -Gblack -K >> distribution.ps
rem plot points with time difference less than distribution days.
gmt psxy -R -J -O  ja_t.d  -Sc0.01i -Gred  >> distribution.ps

gmt psconvert distribution.ps -A -P -Tg
del *.hist* out*
pause



