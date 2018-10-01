# OSX Swift ANE Starter Project

Example Xcode project showing how to create Air Native Extensions for OSX using Swift.    
It supports OSX 10.10+

#### Xcode 10.0 (10A255) must be used with Apple Swift version 4.2 (swiftlang-1000.11.37.1 clang-1000.11.45.1)
It is not possible to mix Swift versions in the same app. Therefore all Swift based ANEs must use the same exact version.
ABI stability is planned for Swift 5 in late 2018

##### Dependencies
From the command line cd into /example and run:
- OSX
````shell
bash get_mac_dependencies.sh
`````
----------

The ANE is comprised of 2 parts.

1. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
2. A dynamic Swift Framework which contains the main logic of the ANE.

HelloWorldANE_LIB/HelloWorldANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

````objectivec
static FRENamedFunction extensionFunctions[] =
{
    MAP_FUNCTION(TRSOA, load)
   ,MAP_FUNCTION(TRSOA, goBack)
};
`````


HelloWorldANE_FW/SwiftController.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
@objc public func getFunctions(prefix: String) -> Array<String> {
    functionsToSet["\(prefix)load"] = load
    functionsToSet["\(prefix)goBack"] = goBack
}
`````

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

- Xcode 10.0
- Xcode 9.1 for iOS Simulator
- IntelliJ IDEA
- AIR 30
