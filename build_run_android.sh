#!/bin/sh

set -e

echo :: build libzap.so
(cd libzap/src; ./build_android_makefiles.sh; make)

echo :: copy libzap.so to cordova plugin
cp libzap/src/ndk_build/armeabi-v7a/libzap.so plugin/src/android/libs/armeabi-v7a/libzap.so

echo :: copy libzap java files to cordova plugin
cp libzap/src/*.java plugin/src/android/

echo :: run android cordova app
export ANDROID_HOME=/opt/android-sdk
(cd demoApp; cordova run android)
