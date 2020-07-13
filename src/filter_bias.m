% Filter data and save
function [bias]=filter_bias(sat,bias2)

    tmpp=bias2(:,2);
    ttt=bias2(:,1);
    [tmpp,ttt]=three_sigma_delete(tmpp,ttt);
    bias=[ttt tmpp];
    if sat==5
        save ..\test\s3a_check\s3a_bias.txt bias -ASCII % save file
    elseif sat==1
        save ..\test\ja2_check\ja2_bias.txt bias -ASCII % save file
    end
return