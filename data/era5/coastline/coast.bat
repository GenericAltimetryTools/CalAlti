REM             GMT EXAMPLE xxxx
REM             2019-04-14 leiyang@fio.org.cn
REM Purpose:    Using grdmath to show the distance from GSHHG  coastline data
REM
gmt gmtset FORMAT_GEO_MAP = dddF MAP_FRAME_WIDTH=2p
gmt gmtset FONT_ANNOT_PRIMARY 7p,Helvetica,black FONT_LABEL 7p,Helvetica,black 

set ps=coast.ps

gmt kml2gmt coa_s.kml >coa_s.d

gmt pscoast  -R100/130/15/45 -JM10c -Dc -A20000/0/1 -Ba --FONT_TITLE=10p -K -Swhite -W0.1p --MAP_ANNOT_OBLIQUE=45  > %ps%

gmt pscoast -R100/125/15/45 -M -W1/0.1p -Dc  > coastal.txt
gmt sample1d coastal.txt -T100k -AR > coastal.d
gawk "!/>/ {print $1,$2}" coastal.d >coastal.d2
gmt select coastal.d2 -Fcoa_s.d -fg >coastal.d3

gmt psxy -R100/130/15/45 -J coastal.txt -W0.1p,red -O -K >>%ps%
gmt psxy -R100/130/15/45 -J coastal.txt -Sc0.1c -O -K >>%ps%
gmt psxy -R100/130/15/45 -J coastal.d3 -Sc0.1c -Gred -O  >>%ps%


gmt psconvert %ps%  -A -P -Tf
del gmt.* *.d *.d2
pause