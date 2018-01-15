This repo contains all dependencies required to build BlueSky Re (https://github.com/uentity/blue-sky-re.git) on Windows.
All you need to do is setup environment variable BLUE_SKY_WINDEPS that points to your local clone of this repo.

NOTE: because of huge size, Boost headers are NOT included. You need to place 'em into `boost/boost` directory by yourself.

Includes following components.
Boost: 1.66
CGAL: 4.9.1
curl: 88220adb72c5cb00e3c8d0886ebe687edf842cd8
HDF5: 1.10.1
loki: 0.1.7
tbb: 2017_20170226oss