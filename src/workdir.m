% This Function is to set work dir to Matlab main dir
function workdir
    wk=userpath;
    wk=wk(1:length(wk));
    cd (wk)
    disp('present dir is:')
    pwd
return