% DAC processing
% The DAC data were from ftp-access.aviso.altimetry.fr/auxiliary/dac/
% results show that DAC could be ignored in the CAL/VAL

clear all
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

dir_nm0='C:\Users\yangleir\Documents\aviso\dac\'; % ten year

k=1;% first index of each year.    
for j=2011:2020 % Loop the DAC files. Year 2011-2020
    
    dir_nm=strcat(dir_nm0,num2str(j),'\');
    namelist = ls(fullfile(dir_nm,'*.nc'));% all DAC files. 6 hour sample.
    
    len_index(j)=length(namelist); 
    len=len_index(j);

    
    dac_value_a(k:k+len-1)=0;% 10 years
    dac_value_b(k:k+len-1)=0;
    dac_value_c(k:k+len-1)=0;   
    
    
     for  n=1:len

          filepath=strcat(dir_nm,namelist(n,:));
          order=['grdtrack -G',filepath];
          tmp=gmt(order,[121.385 36.267;121.364	36.269;121.194 36.241]);% Qianliyan points 121.386 36.2681;121.34804723	36.2688465032;121.1852 36.2407
          dac_value_a(k+n)=tmp.data(1,3);
          dac_value_b(k+n)=tmp.data(2,3);
          dac_value_c(k+n)=tmp.data(3,3);
          Q=['year',num2str(j),'No.',num2str(n)];
          disp(Q)
     end
     k=k+len_index(j);
end
 
 d_ab=(dac_value_a-dac_value_b);% unit m. The scale 1*E4 has been added by GMT.
 d_ac=(dac_value_a-dac_value_c);
 plot(d_ab);hold on % The DAC difference at two points.
 plot(d_ac)
 len=length(d_ab);
 nm=linspace(1,len,len);
 out=[nm;dac_value_a;d_ab;d_ac]';
 save ('../temp/dac.txt','out','-ascii')
 
 figure (2)
 plot(dac_value_a)
 mean(d_ab)
 std(d_ab)
 mean(d_ac)
 std(d_ac)
 