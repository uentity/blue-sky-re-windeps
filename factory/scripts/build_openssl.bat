@echo off

set factory_dir="%BLUE_SKY_WINDEPS%\factory"

set build_dir="%factory_dir%\build"
if not exist %build_dir% mkdir %build_dir%
set log_dir="%build_dir%\log"
if not exist %log_dir% mkdir %log_dir%

set log_path="%log_dir%\openssl.txt"

date /T > %log_path%
time /T >> %log_path%

pushd %factory_dir%

set vcvars_path="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
call %vcvars_path% x64 >> %log_path% 2>&1

pushd openssl

echo "Building x86_64 Release..."
set out_dir=%build_dir%\output\openssl\release
set config_dir=%out_dir%\conf
perl Configure VC-WIN64A no-tests --prefix=%out_dir% --openssldir=%config_dir% >> %log_path% 2>&1
nmake /f makefile clean >> %log_path% 2>&1
nmake /f makefile >> %log_path% 2>&1
nmake /f makefile install >> %log_path% 2>&1
if errorlevel 1 goto fail
set target_dir=%BLUE_SKY_WINDEPS%\openssl\x86_64
del /q %target_dir%\include\* >> %log_path% 2>&1
xcopy /e /Y %out_dir%\include %target_dir%\include >> %log_path% 2>&1
del /q %target_dir%\lib\* >> %log_path% 2>&1
xcopy %out_dir%\lib\libcrypto.lib %target_dir%\lib\
xcopy %out_dir%\lib\libssl.lib %target_dir%\lib\
xcopy %out_dir%\bin\libcrypto-1_1-x64.dll %target_dir%\lib\
xcopy %out_dir%\bin\libssl-1_1-x64.dll %target_dir%\lib\
echo "Success"

echo "Building x86_64 Debug..."
set out_dir=%build_dir%\output\openssl\debug
set config_dir=%out_dir%\conf
perl Configure VC-WIN64A --debug no-tests --prefix=%out_dir% --openssldir=%config_dir% >> %log_path% 2>&1
nmake /f makefile clean >> %log_path% 2>&1
nmake /f makefile >> %log_path% 2>&1
nmake /f makefile install >> %log_path% 2>&1
if errorlevel 1 goto fail
set target_dir=%BLUE_SKY_WINDEPS%\openssl\x86_64\lib\debug
del /q %target_dir%\* >> %log_path% 2>&1
xcopy %out_dir%\lib\libcrypto.lib %target_dir%\
xcopy %out_dir%\lib\libssl.lib %target_dir%\
xcopy %out_dir%\bin\libcrypto-1_1-x64.dll %target_dir%\
xcopy %out_dir%\bin\libssl-1_1-x64.dll %target_dir%\
echo "Success"

popd
popd

exit /B

:fail
echo "fail"
exit /B 1