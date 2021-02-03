% dry correction for height
% https://keisan.casio.com/exec/system/1224575267
function [P_corr]=dry_height(P0,height)

% height=1:100:1000; % meter
% P0=1012.57; % hPa
% t=15;% temperature
% k1=0.0065./(t+0.0065*height+273.15);
% P_h=P0*(1-height.*k1).^5.257;
% plot(height,P_h)

k1=1/44300; % This is a approximation
P_corr=P0*(1-height*k1)^(5.225);% Using 5.257 or 5.225 dose not have significant effect on the result.

return