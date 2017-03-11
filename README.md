# SwiftIOSANE  

Example Xcode project showing how to programme Air Native Extensions for iOS using Swift.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

This project contains a translation of FlashRuntimeExtensions to Swift.
It is comprised of 2 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code. 
2. A dynamic Swift Framework which contains the main logic of the ANE.

> To allow FRE functions to be called from within Swift, a protocol acting 
> as a bridge back to Objective C ,was used.

SwiftIOSANE_LIB/SwiftIOSANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
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
######  The methods exposed by FlashRuntimeExtensions.swift are very similar to the Java API for Air Native Extensions. 

Example - Convert a FREObject into a String, and String into FREObject

````swift
do {
let asString: String = try myFREObject.getAsString()
trace("as3 String converted to Swift String :", airString)
let swiftString: String = "I am a string from Swift"
let freString: FREObject? = try FREObject.newObject(string: swiftString)
} catch {}
`````


Example - Call a method on an FREObject

````swift
if let addition: FREObject = try person.callMethod(methodName: "add", 
args: FREObject.toArray(args: 100, 33)) {
let sum: Int = try addition.getAsInt()
trace("addition result:", sum) //trace, noice!
}
`````

Example - Reading items in array
````swift
do {
let airArray = try inFRE.getAsArray()
if let firstItem: FREObject = try inFRE.getObjectAt(index: 0) {
let firstItemVal: Int = try firstItem.getAsInt()
trace("AIR Array elem at 0 type:", firstItem.getTypeAsString(), "value:", firstItemVal)
}
} catch {}
`````

Example - Convert BitmapData to a UIImage
````swift
if let cgimg = inFRE.getAsImage() {
let img: UIImage = UIImage(cgImage: cgimg)
}
inFRE.release()
`````

Example - Error handling
````swift
do {
_ = try testString.getAsInt() //get as wrong type
} catch let e as FREError {
e.printStackTrace(#file,#line,#column)
} catch {}
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
