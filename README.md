# Swift iOS ANE  

Example Xcode project showing how to create Air Native Extensions for iOS using Swift.
It supports iOS 9.0+

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

It is comprised of 3 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code.
2. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
3. A dynamic Swift Framework which contains the main logic of the ANE.

> To allow FRE functions to be called from within Swift a protocol acting 
> as a bridge back to Objective C was used.

SwiftIOSANE_LIB/SwiftIOSANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

````objectivec
static FRENamedFunction extensionFunctions[] =
{
    { (const uint8_t*) "load", (__bridge void *)@"load", &callSwiftFunction }
   ,{ (const uint8_t*) "goBack", (__bridge void *)@"goBack", &callSwiftFunction }
};
`````


SwiftIOSANE_FW/SwiftController.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
func getFunctions() -> Array<String> {
    functionsToSet["load"] = load
    functionsToSet["goBack"] = goBack      
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

### How to use
######  The methods exposed by FlashRuntimeExtensions.swift are similar to the FreSharp API for Air Native Extensions. 

Example - Convert a FREObject into a String, and String into FREObject

````swift
let airString: String = FreObjectSwift(freObject: inFRE0).value as? String
trace("String passed from AIR:", airString)
let swiftString: String = "I am a string from Swift"
do {
    return try FreObjectSwift(string: swiftString).rawValue
} catch {}
`````


Example - Call a method on an FREObject

````swift
if let addition: FreObjectSwift = try person.callMethod(methodName: "add", args: 100, 31) {
    if let sum: Int = addition.value as? Int {
        trace("addition result:", sum)
    }
}
`````

Example - Reading items in array
````swift
let airArray: FreArraySwift = FreArraySwift.init(freObject: inFRE0)
do {
    if let itemZero: FreObjectSwift = try airArray.getObjectAt(index: 0) {
        if let itemZeroVal: Int = itemZero.value as? Int {
            trace("AIR Array elem at 0 type:", "value:", itemZeroVal)
            let newVal = try FreObjectSwift.init(int: 56)
            try airArray.setObjectAt(index: 0, object: newVal)
            return airArray.rawValue
         }
    }
} catch {}
`````

Example - Convert BitmapData to a UIImage and add to native view
````swift
let asBitmapData = FreBitmapDataSwift.init(freObject: inFRE0)
defer {
    asBitmapData.releaseData()
}
do {
    if let cgimg = try asBitmapData.getAsImage() {
        let img: UIImage = UIImage(cgImage: cgimg)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
           let imgView: UIImageView = UIImageView.init(image: img)
           imgView.frame = CGRect.init(x: 0, y: 0, width: img.size.width, height: img.size.height)
           rootViewController.view.addSubview(imgView)
        }
    }
} catch {}
`````

Example - Error handling
````swift
do {
    _ = try person.getProperty(name: "doNotExist") //calling a property that doesn't exist
} catch let e as FREError {
    if let aneError = e.getError(#file, #line, #column) {
        return aneError //return the error as an actionscript error
    }
} catch {}
`````
----------
### Running on Simulator

The example project can be run on the Simulator from IntelliJ

### Running on Device !

The example project needs to be built and signed in the correct manner.   
AIR's ADT does not yet handle signing of the shared Swift Libraries correctly.   

An AIR based packaging tool is provided at https://github.com/tuarua/AIR-iOS-Packager     
Here is a video [demonstrating how to use it](https://www.youtube.com/watch?v=H-G8WugNFQM&feature=youtu.be)       

[![youtube video](https://raw.githubusercontent.com/tuarua/WebViewANE/master/screenshots/ios-packaging.jpg)](https://www.youtube.com/watch?v=H-G8WugNFQM&feature=youtu.be)

### Prerequisites

You will need

- Xcode 8.3 / AppCode
- IntelliJ IDEA
- AIR 25
