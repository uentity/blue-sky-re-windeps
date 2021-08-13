@echo off

set log_path="%~dp0%~1\build.txt"
date /T > %log_path%
time /T >> %log_path%

set vcvars_path="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"
call %vcvars_path% x86_x64 >> %log_path% 2>&1

timeout /t 3 /nobreak

echo "Building x86_64 Release..."
set bin_dir=%~dp0%~1\exe\x86_64_release
set config_dir=%bin_dir%\conf
perl Configure VC-WIN64A no-tests --prefix=%bin_dir% --openssldir=%config_dir% >> %log_path% 2>&1
nmake /f makefile clean >> %log_path% 2>&1
nmake /f makefile /MP >> %log_path% 2>&1
nmake /f makefile install >> %log_path% 2>&1
if errorlevel 1 goto fail
set target_dir=%BLUE_SKY_WINDEPS%\openssl
del /q %target_dir%\include\* >> %log_path% 2>&1
xcopy /e /Y %bin_dir%\include %target_dir%\include >> %log_path% 2>&1
del /q %target_dir%\lib\* >> %log_path% 2>&1
xcopy %bin_dir%\lib\libcrypto.lib %target_dir%\lib\
xcopy %bin_dir%\lib\libssl.lib %target_dir%\lib\
xcopy %bin_dir%\bin\libcrypto-1_1-x64.dll %target_dir%\lib\
xcopy %bin_dir%\bin\libssl-1_1-x64.dll %target_dir%\lib\
echo "Success"

echo "Building x86_64 Debug..."
set bin_dir=%~dp0%~1\exe\x86_64_debug
set config_dir=%bin_dir%\conf
perl Configure VC-WIN64A --debug no-tests --prefix=%bin_dir% --openssldir=%config_dir% >> %log_path% 2>&1
nmake /f makefile clean >> %log_path% 2>&1
nmake /f makefile /MP >> %log_path% 2>&1
nmake /f makefile install >> %log_path% 2>&1
if errorlevel 1 goto fail
set target_dir=%BLUE_SKY_WINDEPS%\openssl\lib\debug
del /q %target_dir%\* >> %log_path% 2>&1
xcopy %bin_dir%\lib\libcrypto.lib %target_dir%\
xcopy %bin_dir%\lib\libssl.lib %target_dir%\
xcopy %bin_dir%\bin\libcrypto-1_1-x64.dll %target_dir%\
xcopy %bin_dir%\bin\libssl-1_1-x64.dll %target_dir%\
echo "Success"

exit /B

:fail
echo "fail"
exit /B 1