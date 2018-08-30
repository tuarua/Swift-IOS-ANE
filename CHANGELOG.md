### 3.0.0
- Upgraded to Xcode 10.0 beta
- Upgraded to Swift version 4.2 (swiftlang-1000.0.32.1 clang-1000.10.39)
- Added FREArray.push()
- Added @dynamicMemberLookup to FreObjectSwift. Adds cleaner way to extend FREObjects 
- Remove ArgCountError class
- Remove sendEvent method
- UIColor / NSColor changed to single convenience init
- Refactoring

### 2.5.0
- Upgraded to Xcode 9.4
- Upgraded to Swift version 4.1.2 (swiftlang-902.0.54 clang-902.0.39.2)
- Added subscript setter for FREArray i.e. myFreArray[0] = myFREObject
- Added iterator for FREArray i.e. for freObject in myFreArray { }
- Added subscript for setProp i.e. myFreObject["propName"] = myFREObject
- Improve UIImage Extension
- sendEvent is renamed to dispatchEvent

### 2.4.0
- Upgraded to Xcode 9.3
- Upgraded to Swift version 4.1 (swiftlang-902.0.48 clang-902.0.37.1)
- Upgraded to AIR SDK 29

### 2.3.0
- SwiftLint
- added tvOS support
- Merge OSX, iOS, tvOS into same project

### 2.2.0
- Added UIColor.toFREObject() 
- Improved performance for Number,Int conversion

### 2.1.0
- Added subscript for getProp i.e. myFreObject["propName"]
- Added subscript for FREArray i.e. myFreArray[0]
- Added support for ARGB in UIColor / NSColor
- Improve UIImage Extension

### 2.0.0
- Upgraded to Xcode 9.1
- Upgraded to Swift version 4.0.2 (swiftlang-900.0.69.2 clang-900.0.38)
- Upgraded to AIR SDK 28

### 1.3.0
- Upgraded to Xcode 8.3.3
- Added starter project
- Added conversions for Bool, String, Double, Int Arrays
- Fixed Dictionary conversion for Objects with null values

### 1.2.1
- Set bitcode enabled to false
- Improve FreBitmapData

### 1.2.0
- Refactor FreSwift

### 0.0.7
- Convert FreXxxxSwift classes to camel case.
- Change FRENamedFunction array to prevent ARC of strings.
- Prevent XCode from overwriting -Swift header. Optimised values are maintained.

### 0.0.6 
- Added getFunctions(). Functions are defined here. Removes need to edit -Swift.h bridging header
- Update to Swift 3.1 + Xcode 8.3

### 0.0.5 
- Restructure

### 0.0.4 
- Rewrite of API. Now similar to the Air Native Extension API for Android.

### 0.0.3  
- Added remaining FRE methods

### 0.0.2  
- Ported FlashRuntimeExtensions to Swift. Allows calling FRE functions from within Swift

### 0.0.1  
- initial version
