% 
% This program will determine the pass number,CAL site position, data
% boundary that based on the input 'loc'(location of the site).
% One can add sites of their own by specifying the pass number, sites
% location and satellite data boundary.
% ========================================================================

function [pass_num,min_lat,max_lat,lat_gps,lon_gps]=reads3a_cal_select_site(loc)
% Here has qly,zh,qh,zmw,cst.
switch lower(loc)
   case 'qly'
      disp('Your CAL site is: qianliyan')
      min_lat=36000000; % xlim([37.6 40]) for pass 9 YD
      max_lat=36500000; % xlim([36 36.7]) for pass 147 QLY
      pass_num=223;% define the pass number
      lat_gps=36.2672;% 千里岩验潮站的坐标
      lon_gps=121.3853;  
   case 'zh'
      disp('Your CAL site is: zhu hai')
      min_lat=21000000; % xlim([37.6 40]) for pass 9 YD
      max_lat=22200000; % xlim([36 36.7]) for pass 147 QLY
      pass_num=0;% define the pass number
   case 'qh'
      disp('Your CAL site is: qing hai hu')
      min_lat=36500000; % xlim([37.6 40]) for pass 9 YD
      max_lat=37200000; % xlim([36 36.7]) for pass 147 QLY
      pass_num=0;% define the pass number
   case 'zmw'
      disp('Your CAL site is: zimaowan')
      min_lat=38000000; % xlim([37.6 40]) for pass 9 YD
      max_lat=40100000; % xlim([36 36.7]) for pass 147 QLY
      pass_num=317;% define the pass number
      lat_gps=40.0094;% 芷锚湾验潮站的坐标
      lon_gps=119.9200;  
   case 'cst'
      disp('Your CAL site is: chengshantou')
      min_lat=37000000; % xlim([37.6 40]) for pass 9 YD
      max_lat=38000000; % xlim([36 36.7]) for pass 147 QLY
      pass_num=160;% define the pass number
      lat_gps=37.3897;% 成山头验潮站的坐标
      lon_gps=122.6968;       
   otherwise
      disp('Your CAL site is: Unknown location.')
end
return