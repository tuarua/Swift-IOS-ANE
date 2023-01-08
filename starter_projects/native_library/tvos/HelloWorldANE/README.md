# tvOS Swift ANE Starter Project  

Example Xcode project showing how to create Air Native Extensions for tvOS using Swift.   
It supports tvOS 11.1+

#### Xcode 14.2 (14C18) must be used with Apple Swift version 5.7.2 (swiftlang-5.7.2.135.5 clang-1400.0.29.51)
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

The ANE is comprised of 3 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code.
2. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
3. A dynamic Swift Framework which contains the main logic of the ANE.

HelloWorldANE_LIB/HelloWorldANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

```objectivec
static FRENamedFunction extensionFunctions[] =
{
    MAP_FUNCTION(TRSOA, load)
   ,MAP_FUNCTION(TRSOA, goBack)
};
```


HelloWorldANE_FW/SwiftController+FreSwift.swift    
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

```swift
@objc public func getFunctions(prefix: String) -> Array<String> {
    functionsToSet["\(prefix)load"] = load
    functionsToSet["\(prefix)goBack"] = goBack
}
```

HelloWorldANE_FW/SwiftController.swift    
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

- Xcode
- IntelliJ IDEA
- AIR 50.1+

