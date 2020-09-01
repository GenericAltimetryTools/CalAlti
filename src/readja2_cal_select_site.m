% Jason2 and Jason-3 are the same

function [pass_num,min_lat,max_lat,lat_gps,lon_gps,h_gnss]=readja2_cal_select_site(loc)

    switch lower(loc)
        case 'qly'
          disp('Your CAL site is: qianliyan')
          min_lat=36000000; % xlim([37.6 40]) for pass 9 YD
          max_lat=36500000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=153;% define the pass number
          lat_gps=36.2672;% 千里岩验潮站的坐标
          lon_gps=121.3853;
          
        case 'zh'
          disp('zhu hai')
          min_lat=21000000; % xlim([37.6 40]) for pass 9 YD
          max_lat=22200000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=153;% define the pass number
          
        case 'cst' % 成山头
          disp('Your CAL site is: chengshantou')
          min_lat=37640000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=39000000; % 
          pass_num=153;% define the pass number
          lat_gps=37.3897;% 成山头验潮站的坐标
          lon_gps=122.6968;
          
        case 'sdyt' % 
          disp('Your CAL site is: shandong yantai')
          min_lat=37500000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=40000000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=138;% define the pass number
          lat_gps=3.7482596e+01;% 成山头验潮站的坐标
          lon_gps=1.2143555e+02;
          h_gnss=9.2409290e+01-8.721705361659E+00;
      case 'fjpt' % 
          disp('Your CAL site is: Fujian pingtan')
          min_lat=24000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=25500000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=164;% define the pass number
          lat_gps=2.5502154e+01;% GNSS的坐标
          lon_gps=1.1976872e+02;% 1.1976872e+02 2.5502154e+01
          h_gnss=3.3686457e+01-1.467323506820E+01;
       case 'hisy' % 
          disp('Your CAL site is: Hainan sanya')
          min_lat=16000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18300000; % 
%           max_lat=17900000; % 
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=77;% define the pass number
          lat_gps=1.8235778e+01;% GNSS的坐标
          lon_gps=1.0953055e+02;% 1.0953055e+02 1.8235778e+01
          h_gnss=4.7004406e+01-(-1.097660858330E+01);
       case 'yong' % 
          disp('Your CAL site is: Yong xing dao P153')
          min_lat=15000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18000000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=153;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  
          h_gnss=8.3717570e+00-3.663055416951e+00;
       case 'yong2' % 
          disp('Your CAL site is: Yong xing dao P114')
          min_lat=16000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=19500000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=114;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  
          h_gnss=8.3717570e+00-3.663055416951e+00;
        case 'zmw' % zhimaowan
          disp('Your CAL site is: zhimaowan')
          min_lat=39000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=41000000; % 
          pass_num=138;% define the pass number    
          lat_gps=40.0094;% 芷锚湾验潮站的坐标
          lon_gps=119.9200;    

        case 'zhws' % 
          disp('Your CAL site is: zhuhai wanshan')
          min_lat=21000000; % 
          max_lat=22200000; % 
          pass_num=153;% define the pass number    
          lat_gps=21.9949;% GNSS的坐标
          lon_gps=114.1479;%
          
        otherwise
          disp('Unknown location.')
    end
    
    if exist('..\test\ja2_check\','dir')==0
        disp('creat new dir to save the temp files') 
        mkdir('..\test\ja2_check\');
    end
    
    if exist('..\test\ja3_check\','dir')==0
        disp('creat new dir to save the temp files') 
        mkdir('..\test\ja3_check\');
    end
return