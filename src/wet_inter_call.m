% call wet_inter to find the minimum STD

function [bias_std,bias2,sig_g,dis]=wet_inter_call(min_cir,max_cir,lon_gps,lat_gps,pass_num,loc,sat)

% Define the comparison latitude, thus the comparison point. Here we do not
% know the best distance for calibration. So we give a comparison extent to
% the program to find the smallest STD between GNSS and the radiometer.

% assign the value of latitude `lat3`, which will be called by `wet_inter`.
if sat==1 || sat==4 %Jason2,3
    if   strcmp(loc,'cst')
        lat3=37.7;% 此处的纬度大概距离陆地20km，辐射计收到的陆地干扰较小，且距离站点近。
    elseif  strcmp(loc,'sdyt')
        lat3=37.75; % 30km far from the mainland
%         lat3=37.5:0.05:39.1; % It is just a test to loop the `lat3`. Slow
%         and useless. So we would better set the `lat3` by hand.
    elseif  strcmp(loc,'fjpt')
        lat3=25.1; % 25km far from the mainland
    elseif  strcmp(loc,'hisy')
        lat3=17.9; % 35km far from the mainland
    elseif  strcmp(loc,'yong')
        lat3=17.0; % 25km far from the mainland    
    elseif  strcmp(loc,'yong2')
        lat3=16.75; % 25km far from the mainland   
        
    end 
end

if sat==3 % HY-2B
    if  strcmp(loc,'sdyt')
        lat3=37.75; % 25km far from the mainland
    elseif  strcmp(loc,'fjpt')
        lat3=25.7; % 25km far from the mainland
    elseif  strcmp(loc,'hisy')
        lat3=17.9; % 25km far from the mainland
    elseif  strcmp(loc,'hisy2')
        lat3=17.9; % 25km far from the mainland        
    elseif  strcmp(loc,'yong')
        lat3=17.0; % 25km far from the mainland    
    elseif  strcmp(loc,'yong2')
        lat3=16.75; % 25km far from the mainland  
    elseif  strcmp(loc,'sdrc') || strcmp(loc,'sdrc2')
        lat3=37.1; % 25km far from the mainland      
    elseif  strcmp(loc,'sdqd')
        lat3=35.6; % 25km far from the mainland     
    elseif  strcmp(loc,'gdst') % This is not good due to land influnece
        lat3=23.0; % 25km far from the mainland     
        
    end 
end

    lat_compare=lat3;
    % interp and compare
    [bias_std,bias2,sig_g,dis]=wet_inter(min_cir,max_cir,pass_num,sat,loc,lat_compare,lon_gps,lat_gps);
    

    
    
return