#!/bin/sh

set -e

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo $machine

if [ "$machine" == "Mac" ]; then
    export ANDROID_SDK=~/Library/Android/sdk
    export ANDROID_NDK=~/Library/Android/sdk/ndk-bundle
    export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$ANDROID_NDK"
fi

echo :: build libzap.so
(cd libzap/src; ./build_android_makefiles.sh; make)

echo :: copy libzap.so to cordova plugin
cp libzap/src/ndk_build/armeabi-v7a/libzap.so plugin/src/android/libs/armeabi-v7a/libzap.so

echo :: copy libzap java files to cordova plugin
cp libzap/src/*.java plugin/src/android/

echo :: run android cordova app
export ANDROID_HOME=/opt/android-sdk
(cd demoApp; cordova run android)
