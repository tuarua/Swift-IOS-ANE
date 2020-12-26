#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"
echo $pathtome

PROJECT_NAME=FreSwiftExampleANE
FRESWIFT_NAME=FreSwift

AIR_SDK="/Users/eoinlandy/SDKs/AIRSDK_33.1.1.345"

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi
if [ ! -d "$pathtome/platforms/mac" ]; then
mkdir "$pathtome/platforms/mac"
mkdir "$pathtome/platforms/mac/release"
fi

if [ ! -d "$pathtome/platforms/default" ]; then
mkdir "$pathtome/platforms/default"
fi

#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/FreSwift.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/FreSwift.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/mac/release"
cp "$pathtome/library.swf" "$pathtome/platforms/default"

#Copy native libraries into place.
echo "Copying native libraries into place."

cp -R -L "$pathtome/../../native_library/$PROJECT_NAME/Build/Products/Release/$FRESWIFT_NAME.framework" "$pathtome/platforms/mac/release"
mv "$pathtome/platforms/mac/release/$FRESWIFT_NAME.framework/Versions/A/Frameworks" "$pathtome/platforms/mac/release/$FRESWIFT_NAME.framework"
rm -r "$pathtome/platforms/mac/release/$FRESWIFT_NAME.framework/Versions"

#Run the build command.
echo "Building Release."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/FreSwift.ane" "$pathtome/extension_osx.xml" \
-swc "$pathtome/FreSwift.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/release" "$FRESWIFT_NAME.framework" "library.swf" \
-platform default -C "$pathtome/platforms/default" "library.swf"


rm -r "$pathtome/platforms/mac"
rm -r "$pathtome/platforms/default"
rm "$pathtome/FreSwift.swc"
rm "$pathtome/library.swf"

