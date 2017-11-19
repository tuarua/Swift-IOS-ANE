# Swift iOS ANE  

Example Xcode project showing how to create Air Native Extensions for iOS using Swift.
It supports iOS 9.0+
#### Xcode 8.3.3 must be used. Xcode 9 will be supported soon.

This project is used as the basis for the following ANEs   
[Google Maps ANE](https://github.com/tuarua/Google-Maps-ANE)   
[AdMob ANE](https://github.com/tuarua/AdMob-ANE)  
[WebViewANE](https://github.com/tuarua/WebViewANE )   


-------------

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

### Getting Started

A basic Hello World [starter project](/starter_project) is included 

A walkthrough video is available on [Youtube](https://www.youtube.com/watch?v=pjZPzo1A6Ro)


### How to use
###### Converting from FREObject args into Swift types, returning FREObjects
The following table shows the primitive as3 types which can easily be converted to/from Swift types


| AS3 type | Swift type | AS3 param->Swift | return Swift->AS3 |
|:--------:|:--------:|:--------------|:-----------|
| String | String | `let str = String(argv[0])` | `return str.toFREObject()`|
| int | Int | `let i = Int(argv[0])` | `return i.toFREObject()`|
| Boolean | Bool | `let b = Bool(argv[0])` | `return b.toFREObject()`|
| Number | Double | `let dbl = Double(argv[0])` | `return dbl.toFREObject()`|
| Number | CGFloat | `let cfl = CGFloat(argv[0])` | `return cfl.toFREObject()`|
| Date | Date | `let date = Date(argv[0])` | `return date.toFREObject()`|
| Rectangle | CGRect | `let rect = CGRect(argv[0])` | `return rect.toFREObject()` |
| Point | CGPoint | `let pnt = CGPoint(argv[0])` | `return pnt.toFREObject()` |
| Vector int | Array<`Int`> | `let a = Array<Int>(argv[0])` | `return a.toFREObject()`|
| Vector Boolean | Array<`Bool`> | `let a = Array<Bool>(argv[0])` | `return a.toFREObject()`|
| Vector Number | Array<`Double`> | `let a = Array<Double>(argv[0])` | `return a.toFREObject()`|
| Vector String | Array<`String`> | `let a = Array<String>(argv[0])` | `return a.toFREObject()`|
| Object | Dictionary<String, Any>? | `let dct = Dictionary.init(argv[0])` | N/A |

Example

````swift
let airString = String(argv[0])
trace("String passed from AIR:", airString)
let swiftString: String = "I am a string from Swift"
return swiftString.toFREObject()
`````

FreSwift is fully extensible. New conversion types can be added in your own project. For example, Rectangle and Point are built as Extensions.

----------

Example - Call a method on an FREObject

````swift
let person = argv[0]
if let addition = try person.call(method: "add", args: 100, 31) {
    if let result = Int(addition) {
        trace("addition result:", result)
    }
}
`````

Example - Create a new FREObject

````swift
let person = try FREObject(className: "com.tuarua.Person")
try person.setProp(name: "age", value: 30)
`````

Example - Sending events back to AIR  (replaces dispatchStatusEventAsync)

````swift
sendEvent(name: "MY_EVENT", value: "My message")
`````

Example - Reading items in array

````swift
let airArray: FREArray = FREArray.init(argv[0])
do {
    if let itemZero = try Int(airArray.at(index: 0)) {
        trace("AIR Array elem at 0 type:", "value:", itemZero)
        try airArray.set(index: 0, value: 56)
        return airArray.rawValue
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
        let img:UIImage = UIImage.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
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
    _ = try person.getProp(name: "doNotExist") //calling a property that doesn't exist
} catch let e as FreError {
    if let aneError = e.getError(#file, #line, #column) {
        return aneError //return the error as an actionscript error
    }
} catch {}
`````
----------

#### applicationDidFinishLaunching
The static library contains a predefined `+(void)load` method in FreMacros.h. This method can safely be declared in different ANEs.
It is also called once for each ANE and very early in the launch cycle. In here the SwiftController is inited and `onLoad()` called.
This makes an ideal place to add observers for applicationDidFinishLaunching and any other calls which would normally be added as app delegates, thus removing the restriction of one ANE declaring itself as the "owner".   
Note: We have no FREContext yet so calls such as trace, sendEvent will not work.

````swift
@objc func applicationDidFinishLaunching(_ notification: Notification) {
   appDidFinishLaunchingNotif = notification //save the notification for later
}
func onLoad() {
NotificationCenter.default.addObserver(self, 
            selector: #selector(applicationDidFinishLaunching),
            name: NSNotification.Name.UIApplicationDidFinishLaunching, 
            object: nil)      
}
`````
----------

### Running on Simulator

The example project can be run on the Simulator from IntelliJ using AIR 28 Beta or AIR 26. AIR 27 contains a bug when packaging.

### Running on Device

The example project can be run on the device from IntelliJ using AIR 27+

### Submitting to App Store
AIR 28 Beta should be used if possible.
If using AIR 27 please see the [README here](package_for_ios_appstore/) for package script
This is a minor inconvenience and only needs to be done when your app is ready to go to the App Store.

### Prerequisites

You will need

- Xcode 8.3.3 / AppCode - N.B. Xcode 9 will be supported soon.
- IntelliJ IDEA
- AIR 26 and AIR 27
