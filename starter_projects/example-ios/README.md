# iOS Swift ANE Starter Project  

Example Xcode project showing how to create Air Native Extensions for iOS using Swift.
It supports iOS 9.0+

#### Xcode 10.1 (10B61) must be used with Apple Swift version 4.2.1 (swiftlang-1000.11.42 clang-1000.11.45.1)
It is not possible to mix Swift versions in the same app. Therefore all Swift based ANEs must use the same exact version.
ABI stability is planned for Swift 5 in early 2019

The ANE is comprised of 3 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code.
2. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
3. A dynamic Swift Framework which contains the main logic of the ANE.

> To allow FRE functions to be called from within Swift a protocol acting 
> as a bridge back to Objective C was used.

HelloWorldANE_LIB/HelloWorldANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

````objectivec
static FRENamedFunction extensionFunctions[] =
{
    MAP_FUNCTION(TRSOA, load)
   ,MAP_FUNCTION(TRSOA, goBack)
};
`````


HelloWorldANE_FW/SwiftController+FreSwift.swift    
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
@objc public func getFunctions(prefix: String) -> Array<String> {
    functionsToSet["\(prefix)load"] = load
    functionsToSet["\(prefix)goBack"] = goBack
}
`````

HelloWorldANE_FW/SwiftController.swift    
Add Swift method(s)

````swift
func load(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}

func goBack(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}
`````

----------

**Dependencies**
From the command line cd into example/ and run:

````shell
bash get_ios_dependencies.sh
`````


### Prerequisites

You will need

- Xcode 10.1
- IntelliJ IDEA
- AIR 32

### Xcode Build Configuration
Open Xcode > Preferences > Locations > Click Advanced...
![Adobe AIR + Firebase](https://user-images.githubusercontent.com/12083217/46570717-d4db8600-c960-11e8-92fc-2cf2ee657f7c.png)

