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

The time colum  is the Elapsed day referring to `Start epoch`. The tide colum is tide signal in meter.
