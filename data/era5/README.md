## How to download the ERA5 data from ECMWF

The pressure data is the input parameters for calculatng the dry PD at the GNSS stations. After minus the dry PD by the total PD, the wet PD could be got.

The ERA5 reanalysis data source is the most accurate one that could provide the pressure parameter at the sea level. Here I use the python code to download the hourly ERA5 pressure at mean sea level surface.

Before run this script, you should install the required dependencies `cdsapi` for Python and install the CDS API key. The basic usage is here: https://cds.climate.copernicus.eu/api-how-to

The python code in this repository is a refined one that could download the data much more quickly. If the time span of the data is long and the area is large, the speed is very slow using the example code provide by the official website. Here, this code enable to download 4 files at the same time. The data are filed as daily.