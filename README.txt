This repo contains all dependencies required to build BlueSky Re (https://github.com/uentity/blue-sky-re.git) on Windows.
All you need to do is setup environment variable BLUE_SKY_WINDEPS that points to your local clone of this repo.

NOTE: because of huge size, Boost headers are NOT included. You need to place 'em into `boost/boost` directory by yourself.

Includes following components.
Boost: 1.77
CGAL: 5.0 (header-only)
curl: 7.67.0 modified (patched version from https://github.com/uentity/curl.git that supports NTLM auth with given password hashes, linked with bundled OpenSSL)
HDF5: 1.10.4
OpenSSL: 1.1.1
tbb: 2019_20181203oss
CAF: 0.18.5
ANN: 1.1
freetype: 2.9.0
Windows CRT: 10.0.19041.0
MSVC libs: v16.11.0