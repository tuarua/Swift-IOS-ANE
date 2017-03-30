# SwiftIOSANE  

Example Xcode project showing how to programme Air Native Extensions for iOS using Swift.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

It is comprised of 3 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code.
2. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
3. A dynamic Swift Framework which contains the main logic of the ANE.

> To allow FRE functions to be called from within Swift, a protocol acting 
> as a bridge back to Objective C ,was used.

SwiftIOSANE_LIB/SwiftIOSANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

````objectivec
/********************************************************/

const int numFunctions = 1;

/********************************************************/
`````


SwiftIOSANE_FW/SwiftController.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
func getFunctions() -> Array<String> {
  functionsToSet["load"] = load
  ...        
}
`````

Add Swift method(s)

````swift
func load(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
  //your code here
  return nil
}
`````

----------

### How to use
######  The methods exposed by FlashRuntimeExtensions.swift are very similar to the Java API for Air Native Extensions. 

Example - Convert a FREObject into a String, and String into FREObject

````swift
do {
  let asString: String = try myFREObject.getAsString()
  trace("as3 String converted to Swift String :", asString)
  let swiftString: String = "I am a string from Swift"
  let freString: FREObject? = try FREObject.newObject(string: swiftString)
} catch {}
`````


Example - Call a method on an FREObject

````swift
if let addition: FREObject = try person.callMethod(methodName: "add", args: FREObject.toArray(args: 100, 33)) {
  let sum: Int = try addition.getAsInt()
  trace("addition result:", sum) //trace, noice!
}
`````

Example - Reading items in array
````swift
do {
  let airArray = try inFRE.getAsArray() //get as PointerArray


  if let firstItem: FREObject = try inFRE.getObjectAt(index: 0) { //direct access to FREArray
    let firstItemVal: Int = try firstItem.getAsInt()
    trace("AIR Array elem at 0 type:", firstItem.getTypeAsString(), "value:", firstItemVal)
  }
} catch {}
`````

Example - Convert BitmapData to a UIImage
````swift
defer {
  inFRE.release()
}
do {
  if let cgimg = try inFRE.getAsImage() {
    let img: UIImage = UIImage(cgImage: cgimg)
  }
} catch {}
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
An AIR based packaging tool is provided at https://github.com/tuarua/AIR-iOS-Packager

### Prerequisites

You will need

- Xcode 8.3 / AppCode
- IntelliJ IDEA
- AIR 25
