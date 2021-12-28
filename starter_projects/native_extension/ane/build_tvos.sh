#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"
PROJECTNAME=HelloWorldANE
fwSuffix="_FW"
libSuffix="_LIB"

AIR_SDK="/Users/eoinlandy/SDKs/AIRSDK_33.1.1.713"


##############################################################################

if [ ! -d "$pathtome/../../native_library/tvos/$PROJECTNAME/Build/Products/Release-appletvos/" ]; then
echo "No Device build. Build using Xcode"
exit
fi

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
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


#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECTNAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/$PROJECTNAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/tvos/device"

#Copy native libraries into place.
echo "Copying native libraries into place."
cp -R -L "$pathtome/../../native_library/tvos/$PROJECTNAME/Build/Products/Release-appletvos/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/tvos/device/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks/FreSwift.framework" "$pathtome/platforms/tvos/device/Frameworks"
cp -R -L "$pathtome/../../native_library/tvos/$PROJECTNAME/Build/Products/Release-appletvos/$PROJECTNAME$fwSuffix.framework" "$pathtome/platforms/tvos/device/Frameworks"


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

if [ -f "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi
if [ -f "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib" ]; then
rm "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework/libswiftRemoteMirror.dylib"
fi
cp -R -L "$pathtome/platforms/tvos/device/Frameworks/$PROJECTNAME$fwSuffix.framework" "$pathtome/../../example-tvos/tvos_dependencies/device/Frameworks"


#Run the build command.
echo "Building ANE."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME-tvos.ane" "$pathtome/extension_tvos.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform appleTV-ARM -C "$pathtome/platforms/tvos/device" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/tvos/platform.xml" \

#remove the frameworks from sim and device, as not needed any more
rm -r "$pathtome/platforms/tvos/device"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"
echo "Finished."
