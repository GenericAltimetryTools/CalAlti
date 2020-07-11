% Remove the noise data greater than 3 times of the STD
function [tmpp,ttt]=three_sigma_delete(tmpp,ttt)

hehe=std(tmpp);% 
hehe2=mean(tmpp);
hehe3=hehe2+3*hehe;
hehe4=hehe2-3*hehe;
[n]=find(tmpp(:,1)>hehe3);
tmpp(n,1)=NaN;
[n]=find(tmpp(:,1)<hehe4);
tmpp(n)=NaN;
ttt(any(isnan(tmpp), 2),:) = [];
tmpp(any(isnan(tmpp), 2),:) = [];%Delete NaN
return