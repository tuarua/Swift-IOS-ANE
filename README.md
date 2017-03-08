# SwiftIOSANE  

Example Xcode project showing how to programme Air Native Extensions for iOS using Swift.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

This project contains a translation of FlashRuntimeExtensions to Swift.
It is comprised of 2 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code. 
2. A dynamic Swift Framework which contains the main logic of the ANE.

> To allow FRE functions to be called from within Swift, a protocol acting 
> as a bridge back to Objective C ,was used.

SwiftIOSANE_LIB/SwiftIOSANE_LIB.mm is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add methods here like you would an ObjC based ANE  
eg

````objectivec

FRE_FUNCTION (runStringTests) {
    return [swft runStringTestsWithArgv:getFREargs(argc, argv)];
}
...

static FRENamedFunction extensionFunctions[] = {
    {(const uint8_t *) "runStringTests", NULL, &runStringTests}
}
`````


SwiftIOSANE_FW/SwiftIOSANE_FW-Swift.h
Add the method to the header to expose to Swift 

````objectivec
- (FREObject _Nullable)runStringTestsWithArgv:(NSPointerArray *_Nullable)argv;
`````


SwiftIOSANE_FW/SwiftController.swift  
Add Swift method  

````swift
func runStringTests(argv: NSPointerArray) -> FREObject? {
    if let inFRE = argv.pointer(at: 0) {
        //code
    }
}
`````


----------

### How to use
Example - Converting a FREObject into a String

````swift
var swiftString: String = ""
var len: UInt32 = 0
let status: FREResult = FREGetObjectAsUTF8(object: object, length: &len, value: &swiftString)

var airString: FREObject?
let status: FREResult = FRENewObjectFromUTF8(length: UInt32(string.utf8.count), value: ret, object: &airString);
`````

Example - Converting a FREObject into a String the easy way, using ANEHelper.swift


````swift
let swiftString: String = aneHelper.getString(object: object)
let airString: FREObject? = aneHelper.getFREObject(string: swiftString)
trace("Swift string is:", swiftString)
`````

Example - call a method on an FREObject

````swift
let paramsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
var addition: FREObject?
var thrownException: FREObject?

var param1: FREObject?
_ = FRENewObjectFromInt32(value: 100, object: &param1)

var param2: FREObject?
_ = FRENewObjectFromInt32(value: 33, object: &param2)

paramsArray.addPointer(param1)
paramsArray.addPointer(param2)

let status: FREResult = FRECallObjectMethod(object: myClass, methodName: "add",
    argc: UInt32(paramsArray.count), argv: paramsArray, result: &addition,
    thrownException: &thrownException)
`````

Example - call a method on a FREObject the (very) easy way, using ANEHelper.swift
````swift
let addition: FREObject? = aneHelper.call(object: myClass, methodName: "add", params: 100, 33)
`````

----------
### Running on Simulator

The example project can be run on the Simulator from IntelliJ

### Running on Device !

The example project needs to be built and signed in the correct manner.
An AIR based packaging tool is provided in /packager/AIR_ios_packager.dmg

The option to install and debug on the device is included within the tool.
The AIR tool fdb (Flash debugger) is used for debugging. This is only applicable when "Debug over network" is chosen

![alt tag](https://github.com/tuarua/SwiftIOSANE/blob/master/screenshots/1.png)


![alt tag](https://github.com/tuarua/SwiftIOSANE/blob/master/screenshots/2.png)

### Prerequisites

You will need

- Xcode 8.2 / AppCode
- IntelliJ IDEA
- AIR 25 Beta SDK

### NOTES
The code is likely to change as I tidy and improve things especially guard checks on optionals

### TODO
FRE functions still to be implemented

FREAcquireBitmapData()  
~~FREAcquireBitmapData2()~~  
FREAcquireByteArray()  
~~FRECallObjectMethod()~~  
~~FREDispatchStatusEventAsync()~~  
~~FREGetArrayElementAt()~~  
~~FREGetArrayLength()~~  
FREGetContextActionScriptData()  
FREGetContextNativeData()  
~~FREGetObjectAsBool()~~  
~~FREGetObjectAsDouble()~~  
~~FREGetObjectAsInt32()~~  
~~FREGetObjectAsUint32()~~  
~~FREGetObjectAsUTF8()~~  
~~FREGetObjectProperty()~~  
~~FREGetObjectType()~~  
FREInvalidateBitmapDataRect()  
~~FRENewObject()~~  
~~FRENewObjectFromBool()~~  
~~FRENewObjectFromDouble()~~  
~~FRENewObjectFromInt32()~~  
~~FRENewObjectFromUint32()~~  
~~FRENewObjectFromUTF8()~~  
~~FREReleaseBitmapData()~~  
FREReleaseByteArray()  
~~FRESetArrayElementAt()~~  
~~FRESetArrayLength()~~  
FRESetContextActionScriptData()  
FRESetContextNativeData()  
~~FRESetObjectProperty()~~
