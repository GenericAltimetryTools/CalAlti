% Pay attention that the pass number between HY-2A and HY2-B are not same.
% The pass number of 2b shifted 172. For example, the passnumber 215 of 2A
% is refered to 001 (215+172-386) of 2B. The 001 of 2A refered to 173 (1+
% 172) of 2B. The 203A --->375B.

% This is a function to determine the passnumber,CAL site location for HY-2.
% Author:Yang Lei
% 2020-0822
function [pass_num,min_lat,max_lat,lat_gps,lon_gps,h_gnss]=readhy2_cal_select_site(loc)

    switch lower(loc)
        case 'qly'
          disp('qianliyan HY-2A P147') % VAL for HY-2A SSH.
          min_lat=35000000; % xlim([37.6 40]) for pass 9 YD
          max_lat=36700000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=147;% define the pass number
          lat_gps=36.2672;% 千里岩验潮站的坐标
          lon_gps=121.3853;
          
        case 'bqly' % bqly For wet VAL for HY2B wet
          disp('qianliyan HY-2A P147')
          min_lat=35000000; %
          max_lat=36700000; %
          pass_num=319;% define the pass number
          lat_gps=36.2672;% 千里岩验潮站的坐标
          lon_gps=121.3853;       
          h_gnss=86.1-10.1;
          
        case 'zhws2' % Not use now. Do calibration, please use the zhws.
          disp('zhu hai wanshan')
          min_lat=21000000; % xlim([37.6 40]) for pass 9 YD
          max_lat=21910000; % xlim([36 36.7]) for pass 147 QLY
          pass_num=375;% define the pass number. The pass number of 2B is different with 2A. Pay attention!!
          lat_gps=22.108;% 验潮站的坐标
          lon_gps=114.0294;          

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
          max_lat=38800000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=224;% define the pass number
          lat_gps=3.7482596e+01;% 成山头验潮站的坐标
          lon_gps=1.2143555e+02;
          h_gnss=9.2409290e+01-8.721705361659E+00;
          
        case 'sdqd' % shandong YanTai
          disp('Your CAL site is: shandong qingdao')
          min_lat=35000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=36200000; % 
          pass_num=224;% define the pass number
          lat_gps=3.6076699e+01;% 
          lon_gps=1.2030390e+02 ;%1.2030390e+02 3.6076699e+01
          h_gnss=1.1713966e+01-6.2;

        case 'lndd' % shandong YanTai
          disp('Your CAL site is: liaoning dandong')
          min_lat=38000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=39800000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=pass_2ato2b(257);
          lat_gps=40.031621 ;% 成山头验潮站的坐标
          lon_gps=124.32726	;% 
          h_gnss=2.9773536e+01-15.8;  
        case 'lndd2' % shandong YanTai
          disp('Your CAL site is: liaoning dandong2')
          min_lat=37500000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=39800000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=pass_2ato2b(300);
          lat_gps=40.031621 ;% 成山头验潮站的坐标
          lon_gps=124.32726	;% 
          h_gnss=2.9773536e+01-15.8;            
          
        case 'sdrc' % shandong YanTai
          disp('Your CAL site is: shandong rongcheng P181')
          min_lat=34000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=38300000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=181;% define the pass number
          lat_gps=3.7170242e+01 ;% 成山头验潮站的坐标
          lon_gps=1.2242075e+02;% 
          h_gnss=6.4493126e+01-11.80;          
        case 'sdrc2' % shandong YanTai
          disp('Your CAL site is: shandong rongcheng P128')
          min_lat=36000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=38000000; % 
%           min_lat=30000000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=36000000; % 
          pass_num=86;% define the pass number
          lat_gps=3.7170242e+01 ;% 成山头验潮站的坐标
          lon_gps=1.2242075e+02;%  
          h_gnss=6.4493126e+01-11.80;
          
          
       case 'hisy' % shandong YanTai
          disp('Your CAL site is: Hainan sanya')
          min_lat=16000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18400000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=17;% define the pass number
          lat_gps=1.8235778e+01;% GNSS的坐标
          lon_gps=1.0953055e+02;% 1.0953055e+02 1.8235778e+01
          h_gnss=4.7004406e+01-(-1.097660858330E+01);
       case 'hisy2' % shandong YanTai
          disp('Your CAL site is: Hainan sanya')
          min_lat=16000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18000000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=252;% define the pass number
          lat_gps=1.8235778e+01;% GNSS的坐标
          lon_gps=1.0953055e+02;% 1.0953055e+02 1.8235778e+01
          h_gnss=4.7004406e+01-(-1.097660858330E+01);
       case 'yong' % shandong YanTai
          disp('Your CAL site is:Yongxing Dao')
          min_lat=15000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18000000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=265;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  
          h_gnss=8.3717570e+00-3.663055416951e+00;
       case 'yong2' % shandong YanTai
          disp('Your CAL site is:Yongxing Dao')
          min_lat=15000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=18000000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=114;% define the pass number
          lat_gps=1.6834028e+01;% GNSS的坐标
          lon_gps=1.1233533e+02;%  
          h_gnss=8.3717570e+00-3.663055416951e+00;     

      case 'jsly' % 
          disp('Your CAL site is: Jiangsu Lianyun')
          min_lat=34500000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=35600000; % 
%           min_lat=24500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=25000000; % 
          pass_num=pass_2ato2b(52);
          lat_gps=34.722075;% GNSS的坐标
          lon_gps=119.46743;% 1.1976872e+02 2.5502154e+01
          h_gnss=1.3901039e+02-4.298;   
          
       case 'fjpt' % shandong YanTai
          disp('Your CAL site is:Fujian Pintan')
          min_lat=24900000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=27000000; %           
          pass_num=209;% define the pass number
          lat_gps=2.5502154e+01;% GNSS的坐标
          lon_gps=1.1976872e+02;% 1.1976872e+02 2.5502154e+01
          h_gnss=3.3686457e+01-1.467323506820E+01;
          
       case 'gdst' % shandong YanTai
          disp('Your CAL site is:Guandong ShanTou')
          min_lat=21400000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=23100000; % 
          
          pass_num=pass_2ato2b(52);
          lat_gps=2.3417880e+01;% GNSS的坐标
          lon_gps=1.1660307e+02;% 1.1660307e+02 2.3417880e+01
          h_gnss=3.1811380e+01-6.9;  
       case 'gdst2' % shandong YanTai
          disp('Your CAL site is:Guandong ShanTou')
          min_lat=21400000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=23500000; % 
          pass_num=pass_2ato2b(313);
          lat_gps=2.3417880e+01;% GNSS的坐标
          lon_gps=1.1660307e+02;% 1.1660307e+02 2.3417880e+01
          h_gnss=3.1811380e+01-6.9;            
          
       case 'xiam' % shandong YanTai
          disp('Your CAL site is: Fujian Xiamen')
          min_lat=23000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=24800000; % 
          pass_num=pass_2ato2b(300);
          lat_gps=24.449852;% GNSS的坐标
          lon_gps=118.08259	;%
          h_gnss=1.0418800e+02-11.127;    
          
       case 'zhws' % zhuhai wanshan CAL site (Zhiwan)
          disp('Your CAL site is:Zhu Hai Wan Shan')
          min_lat=21000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=22200000; % 
          
%           min_lat=16500000; % 分析湿延迟的时候范围可以设置偏大
%           max_lat=17500000; %           
          pass_num=375;% define the pass number
          lat_gps=21.9949;% GNSS的坐标
          lon_gps=114.1479;% 1.1660307e+02 2.3417880e+01
          
        case 'bzmw' % zhimaowan
          disp('Your CAL site is: zhimaowan')
          min_lat=39000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=40000000; % 
          pass_num=319;% define the pass number    
          lat_gps=40.0094;% 芷锚湾验潮站的坐标
          lon_gps=119.9200;    
          h_gnss=24-3; 
        case 'bzmw2' % zhimaowan
          disp('Your CAL site is: zhimaowan')
          min_lat=39000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=40000000; % 
          pass_num=362;% define the pass number    
          lat_gps=40.0094;% 芷锚湾验潮站的坐标
          lon_gps=119.9200;    
          h_gnss=24-3;       

        case 'gxbh' % zhimaowan
          disp('Your CAL site is: guangxi beihai')
          min_lat=20000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=21500000; % 
          pass_num=17;% define the pass number    
          lat_gps=21.652538;% 
          lon_gps=109.21241	;    
          h_gnss=2.8666416e+01-(-18.11);    
        case 'gxbh2' % zhimaowan
          disp('Your CAL site is: guangxi beihai 2 ')
          min_lat=20000000; % 分析湿延迟的时候范围可以设置偏大
          max_lat=21500000; % 
          pass_num=pass_2ato2b(218);% define the pass number    
          lat_gps=21.652538;% 
          lon_gps=109.21241	;    
          h_gnss=2.8666416e+01-(-18.11);              
          
        otherwise
          disp('Unknown location.')
    end

    if exist('..\test\hy2_check\','dir')==0
        disp('creat new dir to save the temp files') 
        mkdir('..\test\hy2_check\');
    end
    
return