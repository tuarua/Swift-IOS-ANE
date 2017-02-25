#!/usr/bin/env bash

INSPECT_ONLY=0
if [[ "$1" == '-i' ]]; then
    INSPECT_ONLY=1
    shift
fi

if [[ "$1" == '-l' ]]; then
    security find-certificate -a | awk '/^keychain/ {if(k!=$0){print; k=$0;}} /"labl"<blob>=/{sub(".*<blob>=","          "); print}'
    exit
fi



realpath(){
    echo "$(cd "$(dirname "$1")"; echo -n "$(pwd)/$(basename "$1")")";
}

IPA="$(realpath $1)"
TMP="$(mktemp -d /tmp/resign.$(basename "$IPA" .ipa).XXXXX)"
IPA_NEW="$(pwd)/$(basename "$IPA" .ipa).resigned.ipa"
CLEANUP_TEMP=0 # Do not remove this line or "set -o nounset" will error on checks below
#CLEANUP_TEMP=1 # Uncomment this line if you want this script to clean up after itself
cd "$TMP"
[[ $CLEANUP_TEMP -ne 1 ]] && echo "Using temp dir: $TMP"
unzip -q "$IPA"
plutil -convert xml1 Payload/*.app/Info.plist -o Info.plist
echo "App has BundleDisplayName '$(/usr/libexec/PlistBuddy -c 'Print :CFBundleDisplayName' Info.plist)' and BundleShortVersionString '$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Info.plist)'"
echo "App has BundleIdentifier  '$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' Info.plist)' and BundleVersion $(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' Info.plist)"
security cms -D -i Payload/*.app/embedded.mobileprovision > mobileprovision.plist
echo "App has provision         '$(/usr/libexec/PlistBuddy -c "Print :Name" mobileprovision.plist)', which supports '$(/usr/libexec/PlistBuddy -c "Print :Entitlements:application-identifier" mobileprovision.plist)'"
if [[ ! ($INSPECT_ONLY == 1) ]]; then
    PROVISION="$(realpath "$2")"
    CERTIFICATE="$3"
    security cms -D -i "$PROVISION" > provision.plist
    /usr/libexec/PlistBuddy  -x -c 'Print :Entitlements' provision.plist > entitlements.plist
    echo "Embedding provision       '$(/usr/libexec/PlistBuddy -c "Print :Name" provision.plist)', which supports '$(/usr/libexec/PlistBuddy -c "Print :Entitlements:application-identifier" provision.plist)'"
    rm -rf Payload/*.app/_CodeSignature Payload/*.app/CodeResources
    cp "$PROVISION" Payload/*.app/embedded.mobileprovision
    /usr/bin/codesign -f -s "$CERTIFICATE" --entitlements entitlements.plist Payload/*.app
    zip -qr "$IPA_NEW" Payload
fi
if [[ $CLEANUP_TEMP -eq 1 ]]; then
    rm -rf "$TMP"
fi