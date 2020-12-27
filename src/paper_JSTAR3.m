% Statistic of HY-2B
format long
clear all
% Check DCA error

% Step4: Analysis the final sigma of radiometer
[myfit]=spatial_dec(pass_num,min_cir,max_cir,sat); % here we use the `153` as a constant pass number because the data are in open coean and are of good quality.
 
 
 