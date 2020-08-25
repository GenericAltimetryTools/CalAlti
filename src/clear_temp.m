% clear temp filse in hy2_test/ja2_test/ja3_test
function clear_temp(sat)

if sat==1
    temp='..\test\ja2_check\';
elseif sat==4
    temp='..\test\ja3_check\';
elseif sat==3
    temp='..\test\hy2_check\';    
end

str=[temp '*.txt'];
delete(str);

str=[temp '*.dat'];
delete(str);
return