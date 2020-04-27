@echo off

set factory_dir="%BLUE_SKY_WINDEPS%\factory"

echo "Building OpenSSL..."
call %factory_dir%\scripts\build_openssl.bat

set log_path="%log_dir%\curl.txt"

date /T > %log_path%
time /T >> %log_path%

pushd %factory_dir%

set vcvars_path="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
call %vcvars_path% x64 >> %log_path% 2>&1

set openssl_path=%build_dir%\output\openssl
set CC=cl.exe /DUSE_OPENSSL_NTLM

pushd curl
call buildconf.bat
popd

pushd curl\winbuild

echo "Building Release..."
nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x64 WITH_DEVEL=%openssl_path%\release >> %log_path% 2>&1
if errorlevel 1 goto fail
set out_dir=..\builds\libcurl-vc-x64-release-dll-ssl-dll-ipv6-sspi
set target_dir=%BLUE_SKY_WINDEPS%\curl
del /q %target_dir%\curl\* >> %log_path% 2>&1
xcopy /e /Y %out_dir%\include\curl %target_dir%\curl >> %log_path% 2>&1
del /q %target_dir%\lib64\* >> %log_path% 2>&1
xcopy %out_dir%\lib\libcurl.lib %target_dir%\lib64\
xcopy %out_dir%\bin\libcurl.dll %target_dir%\lib64\
echo "Success"

echo "Building Debug..."
nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x64 DEBUG=yes WITH_DEVEL=%openssl_path%\debug >> %log_path% 2>&1
if errorlevel 1 goto fail
set out_dir=..\builds\libcurl-vc-x64-debug-dll-ssl-dll-ipv6-sspi
set target_dir=%BLUE_SKY_WINDEPS%\curl\debug\lib64
del /q %target_dir%\* >> %log_path% 2>&1
copy /Y %out_dir%\lib\libcurl_debug.lib %target_dir%\libcurl.lib
copy /Y %out_dir%\bin\libcurl_debug.dll %target_dir%\libcurl.dll
echo "Success"

popd
popd

exit /B

:fail
echo "fail"
exit /B 1