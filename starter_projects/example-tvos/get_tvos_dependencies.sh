#!/bin/sh

rm -r tvos_dependencies/device

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/4.0.0/tvos_dependencies.zip
unzip -u -o tvos_dependencies.zip
rm tvos_dependencies.zip

wget https://github.com/tuarua/Swift-IOS-ANE/releases/download/4.0.0/AIRSDK_patch.zip
unzip -u -o AIRSDK_patch.zip
rm AIRSDK_patch.zip
