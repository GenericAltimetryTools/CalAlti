% 
function [sig_r]=sigma_r(bias_std,sig_g,spa)
    % The sig_g will not be used for calculate the sig_r. Because the Gamit over estimated the sigma_g in summmer and the southern China.    
    % We use the 5mm as the sig_g. This is from compadison with in-situ
    % ground radiometer published by papers.
    sig_r=sqrt(bias_std^2-5^2-spa^2);
    Q=['The parameters are: sig(R-G) ', num2str(bias_std),', sig_gnss ', num2str(sig_g),',sig_spatial ', num2str(spa)];
    disp(Q);
    Q=['The uncertainty of the radiometer wet PD is:', num2str(sig_r)];
    disp(Q);
    disp('----------------+Next+----------------');
return