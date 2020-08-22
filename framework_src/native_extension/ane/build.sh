#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"

PROJECTNAME=FreSwiftExampleANE
fwSuffix="_FW"
libSuffix="_LIB"

AIR_SDK="/Users/eoinlandy/SDKs/AIRSDK_33"

##############################################################################

if [ ! -d "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphonesimulator/" ]; then
echo "No iOS Simulator build. Build using Xcode"
exit
fi
if [ ! -d "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphoneos/" ]; then
echo "No iOS Device build. Build using Xcode"
exit
fi
if [ ! -d "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-appletvos/" ]; then
echo "No tvOS Device build. Build using Xcode"
exit
fi
if [ ! -d "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release/" ]; then
echo "No OSX Device build. Build using Xcode"
exit
fi

##############################################################################

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
if [ ! -d "$pathtome/platforms/mac" ]; then
mkdir "$pathtome/platforms/mac"
mkdir "$pathtome/platforms/mac/release"
fi

if [ ! -d "$pathtome/platforms/tvos" ]; then
mkdir "$pathtome/platforms/tvos"
fi
if [ ! -d "$pathtome/platforms/tvos/device" ]; then
mkdir "$pathtome/platforms/tvos/device"
fi
if [ ! -d "$pathtome/platforms/tvos/device/Frameworks" ]; then
mkdir "$pathtome/platforms/tvos/device/Frameworks"
fi

##############################################################################

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
cp "$pathtome/library.swf" "$pathtome/platforms/tvos/device"
cp "$pathtome/library.swf" "$pathtome/platforms/mac/release"

##############################################################################
# OSX
FWPATH="$pathtome/../../native_library/mac/$PROJECTNAME/Build/Products/Release/$PROJECTNAME.framework/Versions/A/Frameworks"
if [ -f "$FWPATH/libswiftAppKit.dylib" ]; then
rm "$FWPATH/libswiftAppKit.dylib"
fi
if [ -f "$FWPATH/libswiftCore.dylib" ]; then
rm "$FWPATH/libswiftCore.dylib"
fi
if [ -f "$FWPATH/libswiftCoreData.dylib" ]; then
rm "$FWPATH/libswiftCoreData.dylib"
fi
if [ -f "$FWPATH/libswiftCoreFoundation.dylib" ]; then
rm "$FWPATH/libswiftCoreFoundation.dylib"
fi
if [ -f "$FWPATH/libswiftCoreGraphics.dylib" ]; then
rm "$FWPATH/libswiftCoreGraphics.dylib"
fi
if [ -f "$FWPATH/libswiftCoreImage.dylib" ]; then
rm "$FWPATH/libswiftCoreImage.dylib"
fi
if [ -f "$FWPATH/libswiftDarwin.dylib" ]; then
rm "$FWPATH/libswiftDarwin.dylib"
fi
if [ -f "$FWPATH/libswiftDispatch.dylib" ]; then
rm "$FWPATH/libswiftDispatch.dylib"
fi
if [ -f "$FWPATH/libswiftFoundation.dylib" ]; then
rm "$FWPATH/libswiftFoundation.dylib"
fi
if [ -f "$FWPATH/libswiftIOKit.dylib" ]; then
rm "$FWPATH/libswiftIOKit.dylib"
fi
if [ -f "$FWPATH/libswiftMetal.dylib" ]; then
rm "$FWPATH/libswiftMetal.dylib"
fi
if [ -f "$FWPATH/libswiftObjectiveC.dylib" ]; then
rm "$FWPATH/libswiftObjectiveC.dylib"
fi
if [ -f "$FWPATH/libswiftos.dylib" ]; then
rm "$FWPATH/libswiftos.dylib"
fi
if [ -f "$FWPATH/libswiftQuartzCore.dylib" ]; then
rm "$FWPATH/libswiftQuartzCore.dylib"
fi
if [ -f "$FWPATH/libswiftXPC.dylib" ]; then
rm "$FWPATH/libswiftXPC.dylib"
fi

cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release/$PROJECTNAME.framework" "$pathtome/platforms/mac/release"
if [ -d "$pathtome/platforms/mac/release/$PROJECTNAME.framework/Versions/A/Frameworks" ]; then
mv "$pathtome/platforms/mac/release/$PROJECTNAME.framework/Versions/A/Frameworks" "$pathtome/platforms/mac/release/$PROJECTNAME.framework"
fi
rm -r "$pathtome/platforms/mac/release/$PROJECTNAME.framework/Versions"

##############################################################################
# IOS
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphonesimulator/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/simulator/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphoneos/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/device/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphonesimulator/FreSwift.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphoneos/FreSwift.framework" "$pathtome/platforms/ios/device/Frameworks"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphonesimulator/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-iphoneos/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/ios/device/Frameworks"

#move the swift dylibs into root of "$pathtome/platforms/ios/ios_dependencies/Frameworks" as per Adobe docs for AIR27
#create folders if they don't exist
if [ ! -d "$pathtome/../../example-ios/ios_dependencies" ]; then
mkdir "$pathtome/../../example-ios/ios_dependencies"
fi
if [ ! -d "$pathtome/../../example-ios/ios_dependencies/device" ]; then
mkdir "$pathtome/../../example-ios/ios_dependencies/device"
fi
if [ ! -d "$pathtome/../../example-ios/ios_dependencies/device/Frameworks" ]; then
mkdir "$pathtome/../../example-ios/ios_dependencies/device/Frameworks"
fi
if [ ! -d "$pathtome/../../example-ios/ios_dependencies/simulator" ]; then
mkdir "$pathtome/../../example-ios/ios_dependencies/simulator"
fi
if [ ! -d "$pathtome/../../example-ios/ios_dependencies/simulator/Frameworks" ]; then
mkdir "$pathtome/../../example-ios/ios_dependencies/simulator/Frameworks"
fi

echo "Copying Swift dylibs into place for device."
#Device

if [ -e "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks" ]
then
for dylib in "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks/*"
do
mv -f $dylib "$pathtome/../../example-ios/ios_dependencies/device/Frameworks"
done
rm -r "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks"
fi

if [ -f "$pathtome/../../example-ios/ios_dependencies/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example-ios/ios_dependencies/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi
if [ -f "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi

cp -R -L "$pathtome/platforms/ios/simulator/Frameworks/FreSwift.framework" "$pathtome/../../example-ios/ios_dependencies/simulator/Frameworks"
cp -R -L "$pathtome/platforms/ios/device/Frameworks/FreSwift.framework" "$pathtome/../../example-ios/ios_dependencies/device/Frameworks"
cp -R -L "$pathtome/platforms/ios/simulator/Frameworks/$PROJECTNAME$fwSuffix.framework" "$pathtome/../../example-ios/ios_dependencies/simulator/Frameworks"
cp -R -L "$pathtome/platforms/ios/device/Frameworks/$PROJECTNAME$fwSuffix.framework" "$pathtome/../../example-ios/ios_dependencies/device/Frameworks"


##############################################################################
# TVOS
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-appletvos/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/tvos/device/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-appletvos/FreSwift.framework" "$pathtome/platforms/tvos/device/Frameworks"
cp -R -L "$pathtome/../../native_library/$PROJECTNAME/Build/Products/Release-appletvos/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/tvos/device/Frameworks"

#move the swift dylibs into root of "$pathtome/platforms/tvos/tvos_dependencies/Frameworks" as per Adobe docs for AIR27
#create folders if they don't exist
if [ ! -d "$pathtome/../../example-tvos/tvos_dependencies" ]; then
mkdir "$pathtome/../../example-tvos/tvos_dependencies"
fi
if [ ! -d "$pathtome/../../example-tvos/tvos_dependencies/device" ]; then
mkdir "$pathtome/../../example-tvos/tvos_dependencies/device"
fi
if [ ! -d "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks" ]; then
mkdir "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks"
fi

echo "Copying Swift dylibs into place for device."
#Device

if [ -e "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks" ]
then
for dylib in "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks/*"
do
mv -f $dylib "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks"
done
rm -r "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/Frameworks"
fi

if [ -f "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi
if [ -f "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi

cp -R -L "$pathtome/platforms/tvos/device/Frameworks/FreSwift.framework" "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks"
cp -R -L "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework" "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks"

##############################################################################
#Run the build command.
echo "Building ANE."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME.ane" "$pathtome/extension.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform iPhone-x86 -C "$pathtome/platforms/ios/simulator" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \
-platform iPhone-ARM -C "$pathtome/platforms/ios/device" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \
-platform appleTV-ARM -C "$pathtome/platforms/tvos/device" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/tvos/platform.xml" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/release" "$PROJECTNAME.framework" "library.swf"

#remove the frameworks from sim and device, as not needed any more
rm -r "$pathtome/platforms/ios/simulator"
rm -r "$pathtome/platforms/ios/device"
rm -r "$pathtome/platforms/ios/default"
rm -r "$pathtome/platforms/tvos/device"
rm -r "$pathtome/platforms/mac"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"

echo "Finished."

