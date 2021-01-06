## How to produce the simulated tide by NAO

First, edit the `naotestj.f`. Change the `Start epoch`, `End epoch` and `Station location` to your own requirements.
Then,run the following command:
```
$ gfortran naotestj.f -o nao
$ ./nao.exe
```

The output file contains full information of simulated tide signals.
Finally, extract the two colums time and tide.
```
awk 'NR>2 {print $1,$2}'' naotestj.out >hehe.out
```

The time colum  is the Elapsed day referring to `Start epoch`. The tide colum is tide signal in meter. Rename the `hehe.out` to the required filename like `ja2.nao2011_2017` (means NAO model value at the comparison point of Jason2 from 2011 to 2017). 

The tide model will be used in function `nao_dif` called by `tg_pca_ssh`. In `nao_dif`, there has code like:
```
            load ..\test\ja2_check\ja2.nao2011_2017 % the ssh simulated by the nao99JB model at the comparison points under satellite tracks.   
            load ..\test\ja2_check\pca_ssh.txt; % 
            load ..\test\qly.nao2011_2017 % the ssh simulated by NAO99JB model at the tide station, such as QLY.
%             load .\qianliyan_tg_cal\tg_FES2014.qly_ja2pca_2011_2017 % You can also use other tide models that best fitting your area.
            disp('loading simulated tide model')
            sat_day=ja2(:,1); %
            sat_tg=ja2(:,2); % unit: cm
%             sat_tg=tg_FES2014(:,2);
```
In the `nao_dif`, I just compute the tide correction by comparing the difference between model values at the comparison points and the tide station. The comparison point is set to one fix point that determined by the mean locations of many cycles. I ignore the 1 km shift of the satellite tracks, which should have a very small impact on the tide correction. 

However, you can choose other ways to do the tide correction. For example, call the NAO fortran programs or FES matlab programs for each comparison point for every loop of the calibration. 

If you would like to call NAO99jb fortran programs, please set:
```
tmodel=4; % tide model. 1=NAO99jb,2=fes2014,3=call FES2014,4=call NAO99jb
```

If you would like to call FES 2014 programs, please set:
```
tmodel=3; % tide model. 1=NAO99jb,2=fes2014,3=call FES2014,4=call NAO99jb
```
Slection of 3 or 4 maybe slow because the computing time is longer.

Before doing this, you need to download the FES 2014 model (matlab programs) and NAO99 fortran codes. The difference is very small compared with `tmodel=2` using the output file of the FES2014 (computing at the mean PCA location). The difference maybe large between the NAO99jb and FES2014 in some places. Since the NAO used the TP altimetry data and tide stations around East Pacific sea, it is accurate in the ocean of regular tide signals (compared with FES 2014, they have nearly the same accuracy). However, over special sea of un-regular tide signals such as Bohai sea, the NAO99jb is less accurate than FES2014. 
