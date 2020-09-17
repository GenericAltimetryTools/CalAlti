% pass trasform between HY-2A and HY-2B
% The pass number in the 2B GDR files has been changed and it not the same
% with the 2A. The 2A kml tracks have been widely used in previous study,
% which provide the pass number. The 2B has no kml files to read the pass
% number. So, need the transform.
% I find the simple lows to transform the pass numbers between 2A and 2B.
function [p2]=pass_2ato2b(p1)

    if p1>=215
        p2=p1-214;
    elseif p1<215
        p2=p1+172;
    end

return