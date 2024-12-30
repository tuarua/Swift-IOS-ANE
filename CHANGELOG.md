### 6.0.0
- Upgrade to Xcode 16.2
- Upgrade to Swift version 6.0.3 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)

### 5.7.2
- Upgrade to Xcode 14.2
- Upgrade to Swift version 5.7.2 (swiftlang-5.7.2.135.5 clang-1400.0.29.51)

### 5.5.2
- Upgrade to Xcode 13.2
- Upgrade to Swift version 5.5.2 (swiftlang-1300.0.47.5 clang-1300.0.29.30)

### 5.5.1
- Upgrade to Xcode 13.1
- Upgrade to Swift version 5.5.1 (swiftlang-1300.0.31.4 clang-1300.0.29.6)
- Support Apple M1

### 5.5.0
- Upgrade to Xcode 13.0
- Upgrade to Swift version 5.5 (swiftlang-1300.0.31.1 clang-1300.0.29.1)

### 5.2.0
- Upgrade to Xcode 12.5
- Upgrade to Swift version 5.4 (swiftlang-1205.0.26.9 clang-1205.0.19.55)

### 5.1.0
- Upgrade to Xcode 12.3
- Upgrade to Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)

### 5.0.0
- Upgrade to Xcode 12.0
- Upgrade to Swift version 5.3 (swiftlang-1200.0.29.2 clang-1200.0.30.1)

### 4.5.0
- Upgrade to Xcode 11.6
- Upgrade to Swift version 5.2.4 (swiftlang-1103.0.32.9 clang-1103.0.32.53)

### 4.4.0
- Upgrade to Xcode 11.4
- Upgrade to Swift version 5.2 (swiftlang-1103.0.32.1 clang-1103.0.32.29)

### 4.3.0
- Upgrade to Xcode 11.3.1
- Latest `ANEUtils` 
- Added main types subscript setters for FREArray i.e. `myFreArray[0] = 10
- refactor starter project ANE
- macOS dispose is now static function `FreSwift.dispose()`

### 4.2.0
- Upgrade to Xcode 11.3
- Upgrade to Swift version 5.1.3 (swiftlang-1100.0.282.1 clang-1100.0.33.15)

### 4.1.0
- Upgrade to Xcode 11.2
- Upgrade to Swift version 5.1.2 (swiftlang-1100.0.278 clang-1100.0.33.9)
- add optional `items` param to `FREArray()`
- internal refactor of FREArray, use .map and .compactMap for conciser code
- Add `[String?]` support to `FREArray`
- rename `FreSwiftLogger.log` to  `FreSwiftLogger.error`
- add `FreSwiftLogger.info`

### 4.0.0
- Upgrade to Xcode 11.0
- Upgrade to iOS SDK 13.0
- Upgrade to Swift version 5.1 (swiftlang-1100.0.270.13 clang-1100.0.33.7)
- Remove `sendEvent()`
- Remove `FREObject.setProp()`
- Remove `FREObject.getProp()`
- Add default param values to `FreArgError.init()`
- Add default param values to `FreError.getError()`

### 3.1.0
- `FreError.getError()` params are now optional
- Add `FREObject.className`
- Add `FreObjectSwift.className`
- Add `FreObjectSwift.toString()`
- Add `@dynamicMemberLookup` for Array types to `FreObjectSwift`
- Add `[Date]` support to `FREArray`
- Add `[NSNumber]` support to `FREArray`
- Declare `FREArray` as open
- Change: `FREArray` now uses `Vector.<Type>` throughout
- Rename `FreObjectTypeSwift.cls` to `FreObjectTypeSwift.class`
- Improve `ANEUtils.map` performance
- Obsolete `FREObject.setProp()`
- Obsolete `FREObject.getProp()`
- Fix spelling mistakes in docs
- Upgraded to AIR SDK 32.0.0.116

### 3.0.0
- Upgrade to Xcode 10.1
- Upgrade to iOS SDK 12.1
- Upgrade to Swift version 4.2.1 (swiftlang-1000.11.42 clang-1000.11.45.1)
- Upgraded to AIR SDK 32
- Add `FREArray.push()`
- Add `FREArray.insert()`
- Add `FREArray.remove()`
- Add `FREArray.isEmpty`
- Add `FREObject.hasOwnProperty()`
- Add `FREObject.toString()`
- Add `@dynamicMemberLookup` to `FreObjectSwift`. Adds cleaner way to extend FREObjects 
- Mark `FREObject.call()` as  `@discardableResult`
- Remove try catches and make better use of optionals
- Remove `ArgCountError` class
- Obsoleted `sendEvent()` method
- Deprecate `FREObject.setProp()` - use accessor or `FreSwiftObject` wrapper instead
- Deprecate `FREObject.getProp()` - use accessor or `FreSwiftObject` wrapper instead
- FreSwiftMainController.TAG is now `public static var String`
- UIColor / NSColor changed to single `convenience init()`
- Add `FreSwiftLogger` to trace any FREExceptions
- `FREObject.init()` to return optional and not require try
- CommonDependancies.ane renamed to FreSwift.ane
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
