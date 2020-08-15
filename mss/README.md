## How to produce your local MSS model from gloabl model

In order to speed the calculation, it is better to use the local MSS model with relatively small size.
Here in my example, the MSS model `qly.nc` is just about 0.5 MB.

I used the GMT grdcut to produce the local model from the global DTU MSS model.

```
gmt grdcut -Rlon1/lon2/lat1/lat2 DTU.nc -Gqly.nc
``` 

I do not change the resolution. If you want, you can add the option `-I`.