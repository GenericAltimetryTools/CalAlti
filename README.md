# CalAlti(Calibration of the satellite altimeters)

## Introduction
CalAlt is developed and maintained by [The First Institute of Oceanography](http://www.fio.org.cn/), MNR, China. The main functions of the CalAltT include:
- Perform the absolute calibration of Satellite Altimeters (Jason2/3, Sentinel-3A/B and HY-2A/B) using the in situ tide gauge data as well as auxiliary models. 
- Validate the satellite radiometer data by GNSS wet path delay.
- The crossover point analysis by calling the GMT x2sys tools.

## usage

This program has been tested under Matlab 2018b Window. 

Download the zip and run one of the main program `cal_*.m` (SSH calibration,* means the satellite name) or `*_wet.m` (radiometer calibration, * means satellite name). 

Without in situ data or GNSS wet delay, the program will not be run properly. The in situ tide data are provided by the National Marine Data Center [NMDC](http://mds.nmdis.org.cn/pages/aboutUs.html) and the GNSS wet delay could be achieved from GNSS data product service platform of China Earthquake Administration (http://cgps.ac.cn). 

The potential contribution of the program to users may be the program design and functions. It can be easily modified to load user's own in situ data (set the pass number, satellite ID, tide gauge file, GNSS wet dely, etc.) and get the altimeter bias.

I provide the QLY tide gauge data with noise added in `simu_tide` directory (because of the limited data policy in China. If you want the in situ data, please contact me.). But it will not influnce the normal use of the program.

I also uploaded the in-situ tide data of Zhuhai Wanshan site (provided by National Satellite Ocean Application Service), which is the truth data and can be freely download. Thus, the best example to test CalVal is to use the zhuhai wanshan data. For Jason-3, please set the following parameter in `cal_jason3.m`
```
min_cir=128;
max_cir=158;
loc = 'zhws';
sat=4;% 4==jason-3
fre=1;
```
For HY-2B, please set the following parameters in `cal_hy2b.m`
```
min_cir=28;
max_cir=46;
loc = 'zhws';
sat=3;% 3==hy2-b
fre=1;%
```

To use the artificial tide gauge data and run the program without problem, first unzip the `simu_tide.zip` in directory `\simu_tide`. Then, modify the path in sub program `tg_pca_ssh`:
`        filename = '..\tg_xinxizx\qly\QLY_2011_2018_clean.txt';` 
to
`        filename = '..\simu_tide\simu_tide.txt';` 

You also need to download some altimeter GDR data set of Jason-2 or Jason-3 from AVISO. The Jason GDR files are filed as:
```
yangleir@DESKTOP-FVRFATD MINGW64 ~/Documents/aviso/jason3
$ ls
062/  077/  114/  138/  153/  164/  229/  240/  shell.txt  temp/

yangleir@DESKTOP-FVRFATD MINGW64 ~/Documents/aviso/jason3/153
$ ls | tail
...
JA3_GPN_2PTP012_153_20160611_103712_20160611_113325.nc
JA3_GPN_2PTP013_153_20160621_083544_20160621_093157.nc
JA3_GPN_2PTP014_153_20160701_063417_20160701_073030.nc
JA3_GPN_2PTP015_153_20160711_043249_20160711_052902.nc
JA3_GPN_2PTP016_153_20160721_023121_20160721_032734.nc
JA3_GPN_2PTP017_153_20160731_002953_20160731_012606.nc
JA3_GPN_2PTP018_153_20160809_222824_20160809_232437.nc
JA3_GPN_2PTP019_153_20160819_202655_20160819_212308.nc
JA3_GPN_2PTP020_153_20160829_182526_20160829_192139.nc
JA3_GPN_2PTP021_153_20160908_162357_20160908_172010.nc
```

The HY-2B data are stored as:
```

yangleir@DESKTOP-FVRFATD MINGW64 ~/Downloads/hy2b/IDR_2M
$ ls
0007/  0011/  0015/  0019/  0023/  0027/  0031/  0035/  0039/  0043/  0047/
0008/  0012/  0016/  0020/  0024/  0028/  0032/  0036/  0040/  0044/  0048/
0009/  0013/  0017/  0021/  0025/  0029/  0033/  0037/  0041/  0045/
0010/  0014/  0018/  0022/  0026/  0030/  0034/  0038/  0042/  0046/

yangleir@DESKTOP-FVRFATD MINGW64 ~/Downloads/hy2b/IDR_2M
$ ls 0007/
H2B_OPER_IDR_2MC_0007_0001_20190121T200307_20190121T205522.nc
H2B_OPER_IDR_2MC_0007_0002_20190121T205521_20190121T214735.nc
H2B_OPER_IDR_2MC_0007_0003_20190121T214734_20190121T223947.nc
H2B_OPER_IDR_2MC_0007_0004_20190121T223950_20190121T233203.nc
H2B_OPER_IDR_2MC_0007_0005_20190121T233202_20190122T002416.nc
...
``` 

Some functions call the [GMT](https://github.com/GenericMappingTools/gmt), which is a very good software for geodetic data processing. The GMT will do the following job:
- track DTU MSS model of Netcdf format using `grdtrack`.
- calculate distance on the earth surface using `mapproject`.
- crossover point analysis using `x2sys`.

（I will write a help document in detail later.）

## Citation
If you think it is appropriate, you may consider paying us back by including
our latest article in the reference list of your future publications:

> Lei, Y.; Xinghua, Z.; P., M.S.; Lin, Z.; Long, Y.; Ning, L. First Calibration Results of Jason-2 and Saral/AltiKa Satellite Altimeters from the Qianliyan Permanent Facilities. Advances in Space Research 2017, 59, 2831–2842.

## Contributing

Contributions are welcome and appreciated.

## Acknowledgment

This program was funded by the National Natural Science Foundation of China (41806214).

