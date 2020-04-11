# OSX Swift ANE Starter Project

Example Xcode project showing how to create Air Native Extensions for OSX using Swift.    
It supports OSX 10.10+

#### Xcode 11.4 (11E146) must be used with Apple Swift version 5.2 (swiftlang-1103.0.32.1 clang-1103.0.32.29)
It is not possible to mix Swift versions in the same app. Therefore all Swift based ANEs must use the same exact version.

#### To download the required FreSwift Framework

Install [Carthage](https://github.com/Carthage/Carthage)  
 
then from the Terminal run:

```shell
carthage update
```

#### Xcode Build Configuration
Open Xcode > Preferences > Locations > Click Advanced...

![Xcode](https://user-images.githubusercontent.com/12083217/46570717-d4db8600-c960-11e8-92fc-2cf2ee657f7c.png)

-----

The ANE is comprised of 2 parts.

1. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
2. A dynamic Swift Framework which contains the main logic of the ANE.

HelloWorldANE.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

```objectivec
static FRENamedFunction extensionFunctions[] =
{
    MAP_FUNCTION(TRSOA, load)
   ,MAP_FUNCTION(TRSOA, goBack)
};
```


SwiftController+FreSwift.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

```swift
@objc public func getFunctions(prefix: String) -> Array<String> {
    functionsToSet["\(prefix)load"] = load
    functionsToSet["\(prefix)goBack"] = goBack
}
```

SwiftController.swift  
Add Swift method(s)

```swift
func load(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}

func goBack(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}
```

### Prerequisites

You will need

- Xcode 11.4
- IntelliJ IDEA
- AIR 33.2.338+

