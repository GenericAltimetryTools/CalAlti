% It can do£º
% - Define zone of comparison
% - Load the GNSS wet PD file
% - Call `wet_inter` to calculate bias and STD

function [bias_std,bias2,sig_g,dis]=wet_inter_call(min_cir,max_cir,lon_gps,lat_gps,pass_num,loc,sat,dry,h_gnss,myfit)
%%
% Define the comparison latitude, thus the comparison point. Here we do not
% know the best distance for calibration. So we give a comparison extent to
% the program to find the smallest STD between GNSS and the radiometer.

% assign the value of latitude `lat3`, which will be called by `wet_inter`.
if sat==1 || sat==4 %Jason2,3
    if   strcmp(loc,'cst')
        lat3=37.7;% 
    elseif  strcmp(loc,'sdyt')
%         lat3=38.25; % 30km far from the mainland
        lat3=37.6:0.05:39.1; % It is just a test to loop the `lat3`. Slow
%         and useless. So we would better set the `lat3` by hand.
    elseif  strcmp(loc,'fjpt')
%         lat3=24.96; % 50km 
         lat3=24.5:0.05:25.3;
    elseif  strcmp(loc,'hisy')
%         lat3=17.75; % 35km far from the mainland
        lat3=17.0:0.05:18.2; % Loop to test my guess. The lowest RMS is not the beginning of the land contamination.   
    elseif  strcmp(loc,'yong')
        lat3=15.1:0.05:19.4; % 
    elseif  strcmp(loc,'yong2')
        lat3=15.1:0.05:19.4; % 
    elseif  strcmp(loc,'gdzh')
        lat3=19.5:0.05:22.0; %   
    elseif  strcmp(loc,'gdst')
        lat3=21.1:0.05:23.45; %          
    elseif  strcmp(loc,'lnhl')
        lat3=38.1:0.05:40.5; % 
    elseif  strcmp(loc,'jsly')
        lat3=33.7:0.05:35.5; %   
    elseif  strcmp(loc,'zjwz')
        lat3=25.2:0.05:27.9; %     
    elseif  strcmp(loc,'zmw')
        lat3=38.5:0.05:39.99; %      
    elseif  strcmp(loc,'qly')
        lat3=35.0:0.05:36.5; %    
    elseif  strcmp(loc,'twtf')
        lat3=25.1:0.05:27.5; %            
    else        
        disp('!!!!!!!!!!!!!!!!!no GNSS wet PD was found!!!!!!!!!!!!!!!')
        error('Please check the GNSS wet PD file for this site');        
    end 
end

if sat==3 % HY-2B
    if  strcmp(loc,'sdyt')
        lat3=37.9:0.05:38.5; %  
    elseif  strcmp(loc,'fjpt')
        lat3=25.1:0.05:26.0; %  
    elseif  strcmp(loc,'hisy')
%         lat3=17.9; %  
        lat3=17.2:0.05:18.2; 
    elseif  strcmp(loc,'hisy2')
%         lat3=17.9; %  
        lat3=15.2:0.05:18.0;        
    elseif  strcmp(loc,'yong2') 
        lat3=15.1:0.05:19.9; %      
    elseif  strcmp(loc,'yong')
        lat3=15.1:0.05:19.1; %    
    elseif  strcmp(loc,'sdrc') 
        lat3=35.1:0.05:37.0; %       
    elseif  strcmp(loc,'sdrc2')
        lat3=35.1:0.05:39.4; %               
    elseif  strcmp(loc,'sdqd')
        lat3=34.6:0.05:35.8; %       
    elseif  strcmp(loc,'gdst') % This is not good due to land influnece
        lat3=20.1:0.05:23.0; %     
    elseif  strcmp(loc,'gdst2') % This is not good due to land influnece
        lat3=20.5:0.05:23.4; %             
    elseif  strcmp(loc,'bzmw') 
        lat3=38.5:0.05:39.8; %    
    elseif  strcmp(loc,'bzmw2')
        lat3=38.4:0.05:39.7; %            
    elseif  strcmp(loc,'bqly')
        lat3=33:0.05:36.3; %      
    elseif  strcmp(loc,'gxbh2')
        lat3=21.1:0.05:21.4; %   
    elseif  strcmp(loc,'gxbh') 
        lat3=20.1:0.05:21.3; %           
    elseif  strcmp(loc,'xiam') || strcmp(loc,'kmnm') 
        lat3=21.5:0.05:24.6; %     
    elseif  strcmp(loc,'jsly')
        lat3=34.6:0.05:35.5; %     
    elseif  strcmp(loc,'lndd')
        lat3=38.1:0.05:39.5; %     
    elseif  strcmp(loc,'lndd2')
        lat3=37.6:0.05:39.5; %             
    elseif  strcmp(loc,'lnjz')
        lat3=37.9:0.05:38.5; %  
    elseif  strcmp(loc,'lnjz2')
        lat3=37.9:0.05:38.8; %  
    elseif  strcmp(loc,'twtf')
        lat3=25.3:0.05:27.5; %       
    elseif  strcmp(loc,'twtf2')
        lat3=24.9:0.05:26.1; %  
    elseif  strcmp(loc,'hkws')
        lat3=21.5:0.05:22.4; %            
    else
        disp('!!!!!!!!!!!!!!!!!no GNSS wet PD was found!!!!!!!!!!!!!!!')
        error('Please check the GNSS wet PD file for this site');
    end 
end

% Load the GNSS wet PD file.
% `z_delta` is a  threshold value  to remove the fast changing data. Unit
% is `mm`. It is not the same for each site and given by subjectively.
% - load the GNSS wet PD file according to the `loc`. Format is
% '2008.000000000 2524.90 209.70 17.50'='Time total_PD wet_PD sig_PD'
% -
    if strcmp(loc,'sdyt')
        gnss_wet=load ('..\test\gnss_wet\troSDYT.d3');
        z_delta=15;
    elseif strcmp(loc,'fjpt')
        gnss_wet=load ('..\test\gnss_wet\troFJPT.d3');
        z_delta=15;
    elseif strcmp(loc,'hisy') || strcmp(loc,'hisy2')
        gnss_wet=load ('..\test\gnss_wet\troHISY.d3');
        z_delta=15;
    elseif strcmp(loc,'yong')||strcmp(loc,'yong2')
        gnss_wet=load ('..\test\gnss_wet\troYONG.d3'); 
        z_delta=20;
    elseif strcmp(loc,'sdrc')||strcmp(loc,'sdrc2')
        gnss_wet=load ('..\test\gnss_wet\troSDRC.d3'); 
        z_delta=20;   
    elseif strcmp(loc,'sdqd')
        gnss_wet=load ('..\test\gnss_wet\troSDQD.d3'); 
        z_delta=20;           
    elseif strcmp(loc,'gdst') || strcmp(loc,'gdst2')
        gnss_wet=load ('..\test\gnss_wet\troGDST.d3'); 
        z_delta=20;       
    elseif strcmp(loc,'gdzh')
        gnss_wet=load ('..\test\gnss_wet\troGDZH.d3'); 
        z_delta=20;  
    elseif strcmp(loc,'lnhl')
        gnss_wet=load ('..\test\gnss_wet\troLNHL.d3'); 
        z_delta=20;         
    elseif strcmp(loc,'jsly')
        gnss_wet=load ('..\test\gnss_wet\troJSLY.d3');         
        z_delta=20;          
    elseif strcmp(loc,'zjwz')
        gnss_wet=load ('..\test\gnss_wet\troZJWZ.d3');         
        z_delta=20;          
    elseif strcmp(loc,'zmw') || strcmp(loc,'bzmw') || strcmp(loc,'bzmw2') 
        gnss_wet=load ('..\test\gnss_wet\troBZMW.d');         
        z_delta=20;     
    elseif strcmp(loc,'qly') || strcmp(loc,'bqly')
        gnss_wet=load ('..\test\gnss_wet\troBQLY.d');         
        z_delta=20;  
    elseif strcmp(loc,'gxbh') || strcmp(loc,'gxbh2')
        gnss_wet=load ('..\test\gnss_wet\troGXBH.d3');         
        z_delta=20;   
    elseif strcmp(loc,'xiam')
        gnss_wet=load ('..\test\gnss_wet\troXIAM.d3');         
        z_delta=20;  
    elseif strcmp(loc,'lndd')||strcmp(loc,'lndd2')
        gnss_wet=load ('..\test\gnss_wet\troLNDD.d3');         
        z_delta=20;   
    elseif strcmp(loc,'lnjz')||strcmp(loc,'lnjz2')
        gnss_wet=load ('..\test\gnss_wet\troLNJZ.d3');         
        z_delta=20;           
    elseif strcmp(loc,'kmnm')
        gnss_wet=load ('..\test\gnss_wet\trokmnm.d3');         
        z_delta=20;    % not use this parameters   
    elseif strcmp(loc,'twtf')||strcmp(loc,'twtf2')
        gnss_wet=load ('..\test\gnss_wet\trotwtf.d3');         
        z_delta=20;    % not use this parameters 
    elseif strcmp(loc,'hkws')
        gnss_wet=load ('..\test\gnss_wet\trohkws.d3');         
        z_delta=20;    % not use this parameters         
    end
    
    lat_compare=lat3; % This is a matrix of latitude along the track. Each point of the matrix will be compared to the GNSS.
    % interp and compare. 
    %% This is the key function 
    [bias_std,bias2,sig_g,dis]=wet_inter(min_cir,max_cir,pass_num,sat,loc,lat_compare,lon_gps,lat_gps,dry,h_gnss,myfit,gnss_wet,z_delta);
    
return