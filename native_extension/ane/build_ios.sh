#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"


echo $pathtome

PROJECTNAME=SwiftIOSANE
fwSuffix="_FW"
libSuffix="_LIB"

AIR_SDK="/Users/User/sdks/AIR/AIRSDK_27_B"
echo $AIR_SDK

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi
if [ ! -d "$pathtome/platforms/ios" ]; then
mkdir "$pathtome/platforms/ios"
fi
if [ ! -d "$pathtome/platforms/ios/simulator" ]; then
mkdir "$pathtome/platforms/ios/simulator"
fi
if [ ! -d "$pathtome/platforms/ios/simulator/Frameworks" ]; then
mkdir "$pathtome/platforms/ios/simulator/Frameworks"
fi
if [ ! -d "$pathtome/platforms/ios/device" ]; then
mkdir "$pathtome/platforms/ios/device"
fi
if [ ! -d "$pathtome/platforms/ios/device/Frameworks" ]; then
mkdir "$pathtome/platforms/ios/device/Frameworks"
fi
if [ ! -d "$pathtome/platforms/ios/default" ]; then
mkdir "$pathtome/platforms/ios/default"
fi


#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECTNAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/$PROJECTNAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/ios/simulator"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/device"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/default"

#Copy native libraries into place.
echo "Copying native libraries into place."
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/simulator/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/device/lib$PROJECTNAME.a"

cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-iOS-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/FreSwift.framework/Headers/FreSwift-iOS-Swift.h"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-iOS-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/FreSwift.framework/Headers/FreSwift-iOS-Swift.h"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-iOS-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Debug-iphonesimulator/FreSwift.framework/Headers/FreSwift-iOS-Swift.h"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/FreSwift/FreSwift-iOS-Swift.h" "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Debug-iphoneos/FreSwift.framework/Headers/FreSwift-iOS-Swift.h"

cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/FreSwift.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/FreSwift.framework" "$pathtome/platforms/ios/device/Frameworks"

cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphonesimulator/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../native_library/ios/$PROJECTNAME/Build/Products/Release-iphoneos/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/device/Frameworks"



#Run the build command.
echo "Building Simulator Release."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME-ios.ane" "$pathtome/extension_ios.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform iPhone-x86  -C "$pathtome/platforms/ios/simulator" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \
-platform iPhone-ARM  -C "$pathtome/platforms/ios/device" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \

#create folders if they don't exist
if [ ! -d "$pathtome/../../example/native" ]; then
mkdir "$pathtome/../../example/native"
fi
if [ ! -d "$pathtome/../../example/native/device" ]; then
mkdir "$pathtome/../../example/native/device"
fi
if [ ! -d "$pathtome/../../example/native/device/Frameworks" ]; then
mkdir "$pathtome/../../example/native/device/Frameworks"
fi
if [ ! -d "$pathtome/../../example/native/simulator" ]; then
mkdir "$pathtome/../../example/native/simulator"
fi
if [ ! -d "$pathtome/../../example/native/simulator/Frameworks" ]; then
mkdir "$pathtome/../../example/native/simulator/Frameworks"
fi

#copy frameworks folder to src
cp -R -L "$pathtome/platforms/ios/device/Frameworks/FreSwift.framework" "$pathtome/../../example/native/device/Frameworks"
cp -R -L "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework" "$pathtome/../../example/native/device/Frameworks"
cp -R -L "$pathtome/platforms/ios/simulator/Frameworks/FreSwift.framework" "$pathtome/../../example/native/simulator/Frameworks"
cp -R -L "$pathtome/platforms/ios/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework" "$pathtome/../../example/native/simulator/Frameworks"

#remove the frameworks from sim and device, as not needed any more
rm -r "$pathtome/platforms/ios/simulator"
rm -r "$pathtome/platforms/ios/device"

#move the swift dylibs into root of "$pathtome/platforms/ios/device/Frameworks" as per Adobe docs for AIR27

#Device

#FreSwift
if [ -e "$pathtome/../../example/native/device/Frameworks/FreSwift.framework/Frameworks" ]
then
for dylib in "$pathtome/../../example/native/device/Frameworks/FreSwift.framework/Frameworks/*"
do
mv -f $dylib "$pathtome/../../example/native/device/Frameworks"
done
rm -r "$pathtome/../../example/native/device/Frameworks/FreSwift.framework/Frameworks"
fi
if [ -f "$pathtome/../../example/native/device/Frameworks/FreSwift.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example/native/device/Frameworks/FreSwift.framework/libswiftRemoteMirror.dylib"
fi
#Project
if [ -e "$pathtome/../../example/native/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks" ]
then
for dylib in "$pathtome/../../example/native/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks/*"
do
mv -f $dylib "$pathtome/../../example/native/device/Frameworks"
done
rm -r "$pathtome/../../example/native/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks"
fi
if [ -f "$pathtome/../../example/native/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example/native/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi

#Simulator

if [ -e "$pathtome/../../example/native/simulator/Frameworks/FreSwift.framework/Frameworks" ]
then
for dylib in "$pathtome/../../example/native/simulator/Frameworks/FreSwift.framework/Frameworks/*"
do
mv -f $dylib "$pathtome/../../example/native/simulator/Frameworks"
done
rm -r "$pathtome/../../example/native/simulator/Frameworks/FreSwift.framework/Frameworks"
fi
if [ -f "$pathtome/../../example/native/simulator/Frameworks/FreSwift.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example/native/simulator/Frameworks/FreSwift.framework/libswiftRemoteMirror.dylib"
fi

if [ -e "$pathtome/../../example/native/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks" ]
then
for dylib in "$pathtome/../../example/native/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks/*"
do
mv -f $dylib "$pathtome/../../example/native/simulator/Frameworks"
done
rm -r "$pathtome/../../example/native/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks"
fi
if [ -f "$pathtome/../../example/native/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example/native/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi


rm -r "$pathtome/platforms/ios/default"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"



