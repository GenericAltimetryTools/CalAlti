% 获取目录名，为目录循环提供文件夹名输入
% Get the name of directory
function b=dir_name(dir_0)
    cd (dir_0);
    bb=ls;
    t=size (bb);
    b=bb(3:t,:);% 3表示送第三行开始。因为前两行是特殊字符
    cd C:\Users\yangleir\Documents\MATLAB\CAL\matlab_dell\CalALti\src;

return