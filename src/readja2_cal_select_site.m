% Jason2 and Jason-3 are the same

function [pass_num,min_lat,max_lat,lat_gps,lon_gps,h_gnss]=readja2_cal_select_site(loc)

    switch lower(loc)
        case 'qly'
          disp('Your CAL site is: qianliyan')
          min_lat=34800000; % xlim([37.6 40]) for pass 9 YD
          max_lat=36900000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=153;% define the pass number
          lat_gps=36.2672;% 千里岩验潮站的坐标
          lon_gps=121.3853;
          h_gnss=86.1-10.1;
%           h_gnss=0;
          
        case 'zhws'
          disp('zhu hai wanshan')
          min_lat=21500000; % xlim([37.6 40]) for pass 9 YD
          max_lat=22000000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=153;% define the pass number
          lat_gps=22.108;% 验潮站的坐标
          lon_gps=114.0294;
          
        case 'cst' % 成山头
          disp('Your CAL site is: chengshantou')
          min_lat=37640000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=39000000; % 
          pass_num=153;% define the pass number
          lat_gps=37.3897;% 成山头验潮站的坐标
          lon_gps=122.6968;
          h_gnss=45.5-13.07;
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
          
      case 'gdzh' % 
          disp('Your CAL site is: Guangdong Zhuhai')
          min_lat=18000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=22200000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=153;% define the pass number
          lat_gps=2.2275301e+01;% GNSS的坐标
          lon_gps=1.1356688e+02 ;% 1.1976872e+02 2.5502154e+01
          h_gnss=5.0471732e+01+3.10586395383;     
      case 'lnhl' % 
          disp('Your CAL site is: Liaoning Huludao')
          min_lat=38000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=40800000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=77;% define the pass number
          lat_gps=40.687689;% GNSS的坐标
          lon_gps=120.8518 ;% 1.1976872e+02 2.5502154e+01
          h_gnss=4.2492700e+01-5.227;  
      case 'jsly' % 
          disp('Your CAL site is: Jiangsu Lianyun')
          min_lat=32000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=35600000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=62;% define the pass number
          lat_gps=34.722075;% GNSS的坐标
          lon_gps=119.46743;% 1.1976872e+02 2.5502154e+01
          h_gnss=1.3901039e+02-4.298;    
      case 'zjwz' % 
          disp('Your CAL site is: ZhwJiang wenzhou')
          min_lat=25000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=28000000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=240;% define the pass number
          lat_gps=27.934119;% GNSS的坐标
          lon_gps=120.7629	;% 1.1976872e+02 2.5502154e+01
          h_gnss=1.1317437e+02-14.012;              
      case 'gdst' % 
          disp('Your CAL site is: Guangdong Shantou')
          min_lat=21000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=23500000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=229;% define the pass number
          lat_gps=23.41788;% GNSS的坐标
          lon_gps=116.60307	 ;% 1.1976872e+02 2.5502154e+01
          h_gnss=3.1811380e+01-6.93370;    
          
       case 'hisy' % 
          disp('Your CAL site is: Hainan sanya')
          min_lat=15700000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18300000; % 
%           max_lat=17900000; % 
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=77;% define the pass number
          lat_gps=1.8235778e+01;% GNSS的坐标
          lon_gps=1.0953055e+02;% 1.0953055e+02 1.8235778e+01
          h_gnss=4.7004406e+01-(-9.6);
       case 'yong' % 
          disp('Your CAL site is: Yong xing dao P153')
          min_lat=14000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=19500000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=153;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  
          h_gnss=8.3717570e+00-3.663055416951e+00;
       case 'yong2' % 
          disp('Your CAL site is: Yong xing dao P114')
          min_lat=12000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=19500000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=114;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  
          h_gnss=8.3717570e+00-3.663055416951e+00;
          
        case 'zmw' % zhimaowan
          disp('Your CAL site is: zhimaowan')
          min_lat=37000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=40000000; % 
          pass_num=138;% define the pass number    
          lat_gps=40.0094;% 芷锚湾验潮站的坐标
          lon_gps=119.9200;    
          h_gnss=24-3;

        case 'twtf' % zhimaowan
          disp('Your CAL site is: twtf')
          min_lat=25000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=28000000; % 
          pass_num=051;% define the pass number    
          lat_gps=2.4953600e+01;% 芷锚湾验潮站的坐标
          lon_gps=1.2116450e+02;    
          h_gnss=2.0312200e+02-20.3;
          
%         case 'zhws' % 
%           disp('Your CAL site is: zhuhai wanshan')
%           min_lat=21000000; % 
%           max_lat=22200000; % 
%           pass_num=153;% define the pass number    
%           lat_gps=21.9949;% GNSS的坐标
%           lon_gps=114.1479;%
          
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