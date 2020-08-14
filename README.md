# CalAlti(Calibration of the satellite altimeters)

- CalAlt can calibrate Satellite Altimeters (Jason2/3, Sentinel-3A/B and HY-2A/B) using the in situ tide gauge data (not provide here) as well as auxiliary models. If you want the in situ data, please contact me.
- CalAlt can validate the satellite radiometer data by GNSS wet path delay.
- The crossover point analysis were wrote in GMT script by calling the x2sys tools.

CalAlt is developed and maintained by [The First Institute of Oceanography](http://www.fio.org.cn/), MNR, China.

## usage

This program has been tested under Matlab 2018b Window. Download the zip and run one of the main program `cal_*.m` (SSH calibration,* means the satellite name) or `*_wet.m` (radiometer calibration, * means satellite name). Without in situ data or GNSS wet delay, the program will not be run properly. The in situ tide data are provided by the National Marine Data Center [NMDC](http://mds.nmdis.org.cn/pages/aboutUs.html) and the GNSS wet delay could be achieved from GNSS data product service platform of China Earthquake Administration (http://cgps.ac.cn). The potential contribution of the program to users may be the program design and functions. It can be easily modified to load user's own in situ data (set the pass number, satellite ID, tide gauge file, GNSS wet dely, etc.) and get the altimeter bias.

Some functions call the [GMT](https://github.com/GenericMappingTools/gmt), which is a very good software for geodetic data processing. The GMT will do the following job:
- track DTU MSS model of Netcdf format using `grdtrack`.
- calculate distance on the earth surface using `mapproject`.
- crossover point analysis using `x2sys`.


## Citation
If you think it is appropriate, you may consider paying us back by including
our latest article in the reference list of your future publications:

> Lei, Y.; Xinghua, Z.; P., M.S.; Lin, Z.; Long, Y.; Ning, L. First Calibration Results of Jason-2 and Saral/AltiKa Satellite Altimeters from the Qianliyan Permanent Facilities. Advances in Space Research 2017, 59, 2831–2842.

## Contributing

Contributions are welcome and appreciated.

## Acknowledgment

This research was funded by the National Natural Science Foundation of China (41806214).

