function [pass_num,min_lat,max_lat,lat_gps,lon_gps]=readhy2_cal_select_site(loc)

    switch lower(loc)
        case 'qly'
          disp('qianliyan HY-2A P147')
          min_lat=35000000; % xlim([37.6 40]) for pass 9 YD
          max_lat=36700000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=147;% define the pass number
          lat_gps=36.2672;% 千里岩验潮站的坐标
          lon_gps=121.3853;

		case 'cst300' % 
          disp('chenshantou')
          min_lat=36500000; % 
          max_lat=39000000; % 
          pass_num=300;% define the pass number
          lat_gps=37.3897;% 成山头验潮站的坐标
          lon_gps=122.6968;
          
		case 'cst009' % 
          disp('chenshantou')
          min_lat=36500000; % 
          max_lat=37400000; % 
          pass_num=9;% define the pass number
          lat_gps=37.3897;% 成山头验潮站的坐标
          lon_gps=122.6968;
          
        case 'zmw' % zhimaowan
          disp('zhimaowan')
          min_lat=38500000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=39900000; % 
          pass_num=147;% define the pass number    
          lat_gps=40.0094;% 芷锚湾验潮站的坐标
          lon_gps=119.9200;   

        case 'zh'
          disp('zhu hai')
          min_lat=21000000; % xlim([37.6 40]) for pass 9 YD
          max_lat=22200000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=203;% define the pass number

        case 'sdyt' % shandong YanTai
          disp('Your CAL site is: shandong yantai')
          min_lat=37500000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=38500000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=224;% define the pass number
          lat_gps=3.7482596e+01;% 成山头验潮站的坐标
          lon_gps=1.2143555e+02;

        case 'sdqd' % shandong YanTai
          disp('Your CAL site is: shandong qingdao')
          min_lat=35000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=36100000; % 
          pass_num=224;% define the pass number
          lat_gps=3.6076699e+01;% 
          lon_gps=1.2030390e+02 ;%1.2030390e+02 3.6076699e+01
          
        case 'sdrc' % shandong YanTai
          disp('Your CAL site is: shandong rongcheng P181')
          min_lat=34000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=37300000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=181;% define the pass number
          lat_gps=3.7170242e+01 ;% 成山头验潮站的坐标
          lon_gps=1.2242075e+02;% 
          
        case 'sdrc2' % shandong YanTai
          disp('Your CAL site is: shandong rongcheng P128')
          min_lat=36000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=37300000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=86;% define the pass number
          lat_gps=3.7170242e+01 ;% 成山头验潮站的坐标
          lon_gps=1.2242075e+02;%  
          
          
       case 'hisy' % shandong YanTai
          disp('Your CAL site is: Hainan sanya')
          min_lat=16000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18200000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=17;% define the pass number
          lat_gps=1.8235778e+01;% GNSS的坐标
          lon_gps=1.0953055e+02;% 1.0953055e+02 1.8235778e+01

       case 'hisy2' % shandong YanTai
          disp('Your CAL site is: Hainan sanya')
          min_lat=16000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=17900000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=252;% define the pass number
          lat_gps=1.8235778e+01;% GNSS的坐标
          lon_gps=1.0953055e+02;% 1.0953055e+02 1.8235778e+01
          
       case 'yong' % shandong YanTai
          disp('Your CAL site is:Yongxing Dao')
          min_lat=15000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18000000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=265;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  

       case 'fjpt' % shandong YanTai
          disp('Your CAL site is:Fujian Pintan')
          min_lat=25000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=26100000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=209;% define the pass number
          lat_gps=2.5502154e+01;% GNSS的坐标
          lon_gps=1.1976872e+02;% 1.1976872e+02 2.5502154e+01
     
       case 'gdst' % shandong YanTai
          disp('Your CAL site is:Guandong ShanTou')
          min_lat=22400000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=23100000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=224;% define the pass number
          lat_gps=2.3417880e+01;% GNSS的坐标
          lon_gps=1.1660307e+02;% 1.1660307e+02 2.3417880e+01
          
        otherwise
          disp('Unknown location.')
    end

    if exist('..\test\hy2_check\','dir')==0
        disp('creat new dir to save the temp files') 
        mkdir('..\test\hy2_check\');
    end
    
return