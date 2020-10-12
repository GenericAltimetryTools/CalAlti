
function [out]=high_pass_filter(in,order,filtT,sampT)
%
% function [out]=high_pass_filter(in,order,filtT,sampT);
%

%
% This function is designed to do highpass filtering of any vector of 
% data.  It uses a  Butterworth filter and does the 
% filtering twice, once forward and once in the reverse direction.  
%
% INPUTS:
%        in    -- the data vector
%	 filtT -- the smoothing period; 
%	 sampT -- the sample period
%        order -- of the butterworth filter
%
%  NOTE:  filtT and sampT must be entered in the same units!!!!!
%

[mm,nn]=size(in);
if nn>mm & mm==1
 in=in';
 [mm,nn]=size(in);
elseif mm~=1 & nn~=1
 error('Input must be a vector and not an array!!!')
end
%以下为直线线性拟合
 
P=polyfit([1 mm],[in(1) in(mm)],1);
dumx=[1:mm]';
lineartrend=polyval(P,dumx);
in=in-lineartrend;

% Second, create the Butterworth filter. 
Wn=(2./filtT)*sampT;
[b,a]=butter(order,Wn,'high');

%
% Third, filter the data both forward and reverse.  
%
inan = find(isnan(in));
if ~isempty(inan)
 error('There are NaNs in the data set!!! Remove them and try again!')
end
out=filtfilt(b,a,in);
%
%
% Finally return the linear trend removed earlier.
%
%out=out+lineartrend;
%

