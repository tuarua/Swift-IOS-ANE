#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path to current directory to:"
pathtome=$0
pathtome="${pathtome%/*}"
echo $pathtome

PROJECT_NAME=HelloWorldANE

AIR_SDK="/Users/eoinlandy/SDKs/AIRSDK_33.1.1.713"

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi
if [ ! -d "$pathtome/platforms/mac" ]; then
mkdir "$pathtome/platforms/mac"
mkdir "$pathtome/platforms/mac/release"
fi

#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECT_NAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files form SWC."
unzip "$pathtome/$PROJECT_NAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/mac/release"

#Copy native libraries into place.
echo "Copying native libraries into place."
cp -R -L "$pathtome/../../native_library/mac/$PROJECT_NAME/Build/Products/Release/$PROJECT_NAME.framework" "$pathtome/platforms/mac/release"

rm -r "$pathtome/platforms/mac/release/$PROJECT_NAME.framework/Versions"

#Run the build command.
echo "Building Release."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECT_NAME-osx.ane" "$pathtome/extension_osx.xml" \
-swc "$pathtome/$PROJECT_NAME.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/release" "$PROJECT_NAME.framework" "library.swf"


rm -r "$pathtome/platforms/mac"
rm "$pathtome/$PROJECT_NAME.swc"
rm "$pathtome/library.swf"

