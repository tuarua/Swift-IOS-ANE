#!/bin/sh

rm -r tvos_dependencies/device

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/5.7.2/tvos_dependencies.zip
unzip -u -o tvos_dependencies.zip
rm tvos_dependencies.zip

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/5.7.2/AIRSDK_additions.zip
unzip -u -o AIRSDK_additions.zip
rm AIRSDK_additions.zip
