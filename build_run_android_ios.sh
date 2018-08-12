#!/bin/sh

set -e

# get command line params
build_type=$1
sim=$2

# get machine type (linix or mac generally)
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo $machine

if [ "$build_type" == "android" ]; then
    # do android stuff

    # set android sdk paths on mac
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
elif [ "$build_type" == "ios" ]; then
    # do ios stuff
    echo :: build libzap.a
    (cd libzap/src; ./build_ios_makefiles.sh $sim; make;)

    echo :: combine libs
    (cd libzap/src; ./combine_ios_libs.sh $sim;)

    echo :: copy libzap_combined.a to cordova plugin
    cp libzap/src/libzap_combined.a plugin/src/ios/libs/libzap_combined.a

    echo :: copy zap.h to cordova plugin
    cp libzap/src/zap.h plugin/src/ios/zap.h

    echo :: run ios cordova app
    if [ "$sim" == "sim" ]; then
        (cd demoApp; cordova run ios)
    else
        (cd demoApp; cordova run ios --device)
    fi
else
    echo no build type specified! - 'android' or 'ios'?
fi
