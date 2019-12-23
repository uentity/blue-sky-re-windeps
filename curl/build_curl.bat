@echo off

if "%1" == "" (
	echo "openssl path not passed as 1 arg"
	exit
)

set log_path="%~dp0\build.txt"
date /T > %log_path%
time /T >> %log_path%

set vcvars_path="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
call %vcvars_path% x64 >> %log_path% 2>&1

set openssl_path=%1
set CC=cl.exe /DUSE_OPENSSL_NTLM

rem echo "Building x86_64 Release..."
rem nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x64 WITH_DEVEL=%openssl_path%\x86_64_release >> %log_path% 2>&1
rem if errorlevel 1 goto fail
rem set out_dir=%~dp0\..\builds\libcurl-vc-x64-release-dll-ssl-dll-ipv6-sspi
rem set target_dir=%BLUE_SKY_WINDEPS%\curl
rem del /q %target_dir%\curl\* >> %log_path% 2>&1
rem xcopy /e /Y %out_dir%\include\curl %target_dir%\curl >> %log_path% 2>&1
rem del /q %target_dir%\lib64\* >> %log_path% 2>&1
rem xcopy %out_dir%\lib\libcurl.lib %target_dir%\lib64\
rem xcopy %out_dir%\bin\libcurl.dll %target_dir%\lib64\
rem echo "Success"

echo "Building x86_64 Debug..."
nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x64 DEBUG=yes WITH_DEVEL=%openssl_path%\x86_64_debug >> %log_path% 2>&1
if errorlevel 1 goto fail
set out_dir=%~dp0\..\builds\libcurl-vc-x64-debug-dll-ssl-dll-ipv6-sspi
set target_dir=%BLUE_SKY_WINDEPS%\curl\debug\lib64
del /q %target_dir%\* >> %log_path% 2>&1
copy /Y %out_dir%\lib\libcurl.lib %target_dir%\libcurl.lib
copy /Y %out_dir%\bin\libcurl.dll %target_dir%\libcurl.dll
echo "Success"

rem call %vcvars_path% x86 >> %log_path% 2>&1

rem echo "Building x86 Release..."
rem nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x86 WITH_DEVEL=%openssl_path%\x86_release >> %log_path% 2>&1
rem if errorlevel 1 goto fail
rem set out_dir=%~dp0\..\builds\libcurl-vc-x86-release-dll-ssl-dll-ipv6-sspi
rem set target_dir=%BLUE_SKY_WINDEPS%\curl\lib
rem del /q %target_dir%\* >> %log_path% 2>&1
rem xcopy %out_dir%\lib\libcurl.lib %target_dir%\
rem xcopy %out_dir%\bin\libcurl.dll %target_dir%\
rem echo "Success"

rem echo "Building x86 Debug..."
rem nmake /f Makefile.vc mode=dll WITH_SSL=dll ENABLE_SSPI=yes MACHINE=x86 DEBUG=yes WITH_DEVEL=%openssl_path%\x86_debug >> %log_path% 2>&1
rem if errorlevel 1 goto fail
rem set out_dir=%~dp0\..\builds\libcurl-vc-x86-debug-dll-ssl-dll-ipv6-sspi
rem set target_dir=%BLUE_SKY_WINDEPS%\curl\debug\lib
rem del /q %target_dir%\* >> %log_path% 2>&1
rem copy /Y %out_dir%\lib\libcurl.lib %target_dir%\libcurl.lib
rem copy /Y %out_dir%\bin\libcurl.dll %target_dir%\libcurl.dll
rem echo "Success"

exit /B

:fail
echo "fail"
exit /B 1