@echo off

echo :: make sure you have freshly built libzap.so!
pause

echo :: copy libzap.so to cordova plugin
copy /y libzap\src\ndk_build\armeabi-v7a\libzap.so plugin\src\android\libs\armeabi-v7a\libzap.so
if %errorlevel% neq 0 exit /b %errorlevel%

echo :: run android cordova app
pushd demoApp
call cordova run android
popd
