#!/bin/sh

set -e

(cd libzap; ./install_requirements.sh)

# install java
add-apt-repository ppa:webupd8team/java
apt-get update
sudo apt-get install oracle-java8-installer

###apt install android-sdk

## download android sdk
#wget -nc http://dl.google.com/android/android-sdk_r24.2-linux.tgz
## extract android sdk
#tar -xvf android-sdk_r24.2-linux.tgz -C /opt
#cd /opt/android-sdk-linux/tools
## install sdk packages
#./android update sdk --no-ui --filter 26,tool,platform-tool,doc

# download android sdk
wget -nc https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
# extract android sdk
mkdir -p /opt/android-sdk
unzip sdk-tools-linux-4333796.zip -d /opt/android-sdk
cd /opt/android-sdk/tools/bin
# install sdk packages
./sdkmanager "platform-tools" "platforms;android-26" "build-tools;28.0.1"
chown -R 755 /opt/android-sdk

# install gradle
apt install gradle

# install cordova
apt install npm
npm install -g cordova
