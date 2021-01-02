% DAC processing
% The DAC data were from ftp-access.aviso.altimetry.fr/auxiliary/dac/
% results show that DAC could be ignored in the CAL/VAL

clear all
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

dir_nm='C:\Users\yangleir\Documents\aviso\dac\2011\'; % one year
namelist = ls(fullfile(dir_nm,'*.nc'));% 
len=length(namelist);
dac_value_a(1:len)=0;
dac_value_b(1:len)=0;
dac_value_c(1:len)=0;

 for  n=1:length(namelist)
     
      filepath=strcat(dir_nm,namelist(n,:));
      order=['grdtrack -G',filepath];
      tmp=gmt(order,[121.386 36.2681;121.34804723	36.2688465032;121.1852 36.2407]);% Qianliyan points
      dac_value_a(n)=tmp.data(1,3);
      dac_value_b(n)=tmp.data(2,3);
      dac_value_c(n)=tmp.data(3,3);
      Q=['No:',num2str(n)];
      disp(Q)
 end
 
 d_ab=(dac_value_a-dac_value_b)/10;% unit mm
 d_ac=(dac_value_a-dac_value_c)/10;
 plot(d_ab);hold on % The DAC difference at two points.
 plot(d_ac)
 nm=linspace(1,365,len);
 out=[nm;dac_value_a/10;d_ab;d_ac]';
 save ('../temp/dac.txt','out','-ascii')
 
 figure (2)
 plot(dac_value_a/10)
 mean(d_ac)
 std(d_ac)
 