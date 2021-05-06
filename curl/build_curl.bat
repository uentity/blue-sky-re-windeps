@echo off

if "%1" == "" (
	echo "openssl path not passed as 1 arg"
	exit
)

set log_path="%~dp0\build.txt"
date /T > %log_path%
time /T >> %log_path%

set vcvars_path="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
call %vcvars_path% x86_x64 >> %log_path% 2>&1

timeout /t 3 /nobreak

set openssl_path=%1
set CC=cl.exe /DUSE_OPENSSL_NTLM

echo "Building x86_64 Release..."
nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x64 WITH_DEVEL=%openssl_path%\x86_64_release >> %log_path% 2>&1
if errorlevel 1 goto fail
set out_dir=%~dp0\..\builds\libcurl-vc-x64-release-dll-ssl-dll-ipv6-sspi
set target_dir=%BLUE_SKY_WINDEPS%\curl
del /q %target_dir%\include\* >> %log_path% 2>&1
xcopy /e /Y %out_dir%\include %target_dir%\include >> %log_path% 2>&1
del /q %target_dir%\lib\* >> %log_path% 2>&1
xcopy %out_dir%\lib\libcurl.lib %target_dir%\lib\
xcopy %out_dir%\bin\libcurl.dll %target_dir%\lib\
echo "Success"

echo "Building x86_64 Debug..."
nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x64 DEBUG=yes WITH_DEVEL=%openssl_path%\x86_64_debug >> %log_path% 2>&1
if errorlevel 1 goto fail
set out_dir=%~dp0\..\builds\libcurl-vc-x64-debug-dll-ssl-dll-ipv6-sspi
set target_dir=%BLUE_SKY_WINDEPS%\curl\lib\debug
del /q %target_dir%\* >> %log_path% 2>&1
copy /Y %out_dir%\lib\libcurl_debug.lib %target_dir%\libcurl.lib
copy /Y %out_dir%\bin\libcurl_debug.dll %target_dir%\libcurl.dll
echo "Success"

exit /B

:fail
echo "fail"
exit /B 1