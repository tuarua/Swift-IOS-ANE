red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk iphoneos -scheme "FreSwiftExampleANE_LIB (iOS)" -configuration "Release"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk iphoneos -scheme "FreSwiftExampleANE_LIB (iOS)" -configuration "Debug"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk iphonesimulator -scheme "FreSwiftExampleANE_LIB (iOS)" -configuration "Release"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk iphonesimulator -scheme "FreSwiftExampleANE_LIB (iOS)" -configuration "Debug"

xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk appletvos -scheme "FreSwiftExampleANE_LIB (tvOS)" -configuration "Release"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk appletvos -scheme "FreSwiftExampleANE_LIB (tvOS)" -configuration "Debug"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk appletvsimulator -scheme "FreSwiftExampleANE_LIB (tvOS)" -configuration "Release"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -sdk appletvsimulator -scheme "FreSwiftExampleANE_LIB (tvOS)" -configuration "Debug"

xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -scheme "FreSwiftExampleANE (OSX)" -configuration "Release"
xcodebuild -project /Users/eoinlandy/flash/Swift-IOS-ANE/framework_src/native_library/FreSwiftExampleANE/FreSwiftExampleANE.xcodeproj -scheme "FreSwiftExampleANE (OSX)" -configuration "Debug"

echo $grn"DONE" $white



