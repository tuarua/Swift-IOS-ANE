#!/bin/sh

rm -r ios_dependencies/device
rm -r ios_dependencies/simulator

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/6.1.2/ios_dependencies.zip
unzip -u -o ios_dependencies.zip
rm ios_dependencies.zip

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/6.1.2/AIRSDK_additions.zip
unzip -u -o AIRSDK_additions.zip
rm AIRSDK_additions.zip
