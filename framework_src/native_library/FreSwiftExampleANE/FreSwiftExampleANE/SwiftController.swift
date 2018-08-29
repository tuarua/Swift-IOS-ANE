/* Copyright 2018 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#if os(iOS) || os(tvOS)
import UIKit
#else
import Cocoa
#endif
import Foundation
import CoreImage
import FreSwift

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    func runStringTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0 else {
            return FreArgError(message: "not enough arguments passed").getError(#file, #line, #column)
        }
        // Turn on FreSwift logging
        FreSwiftLogger.shared().context = context
        
        warning("I am a test warning")
        info("I am a test info")
        trace("*********** Start String test ***********")
        guard let airString = String(argv[0]) else {
            return FreArgError(message: "String not converted").getError(#file, #line, #column)
        }
        
        trace("String passed from AIR:", airString)
        let swiftString: String = "I am a string from Swift"
        trace("-------------------------------------------")
        return swiftString.toFREObject()
    }
    
    func runNumberTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Number test***********")
        guard argc > 0,
            let inFRE0 = argv[0],
            let airDouble = Double(inFRE0),
            let airCGFloat = CGFloat(inFRE0),
            let airFloat = Float(inFRE0),
            let airNSNumber = NSNumber(inFRE0)
            else {
                return FreArgError(message: "Number not converted").getError(#file, #line, #column)   
        }
        
        let testDouble: Double = 31.99
        let testCGFlot: CGFloat = 31.99
        let testFloat: Float = 31.99
        let testNSNumber: NSNumber = 31.99
        
        trace("Number passed from AIR as Double:", airDouble, testDouble.isEqual(to: airDouble) ? "✅" : "❌")
        trace("Number passed from AIR as CGFloat:", airCGFloat, testCGFlot.isEqual(to: airCGFloat) ? "✅" : "❌")
        trace("Number passed from AIR as Float:", airFloat, testFloat.isEqual(to: airFloat) ? "✅" : "❌")
        trace("Number passed from AIR as NSNumber:", airNSNumber, testNSNumber.isEqual(to: airNSNumber) ? "✅" : "❌")
        trace("-------------------------------------------")
        
        let swiftDouble: Double = 34343.31
        return swiftDouble.toFREObject()
    }
    
    func runIntTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Int Uint test***********")
        guard argc > 1,
            let airInt = Int(argv[0]),
            let airUInt = UInt(argv[1]),
            let airIntAsDouble = Double(argv[0]) else {
                return nil
        }
        
        let testInt = -54
        let testDouble = -54.0
        let testUint = 66
        
        trace("Number passed from AIR as Int:", airInt, testInt == airInt ? "✅" : "❌")
        trace("Number passed from AIR as Int to Double:", airIntAsDouble, testDouble == airIntAsDouble ? "✅" : "❌")
        trace("Number passed from AIR as UInt:", airUInt, testUint == airUInt ? "✅" : "❌")
        trace("-------------------------------------------")
        let swiftInt: Int = -666
        return swiftInt.toFREObject()
    }
    
    func runArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Array test ***********")
        
        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }
        
        let airArray = FREArray(inFRE0)
        airArray.append(77.toFREObject())
        airArray.append(88)
        trace("Get FREArray length :", airArray.length, 8 == airArray.length ? "✅" : "❌")
        for fre in airArray {
            trace("iterate over FREArray", Int(fre) ?? "unknown")
        }
        
        let myVector = FREArray(className: "Object", length: 5, fixed: true)
        trace("New FREArray of fixed length:", myVector.length, 5 == myVector.length ? "✅" : "❌")
        airArray[0] = 123.toFREObject()
        trace("Set element of FREArray:", Int(airArray[0]) ?? 0, 123 == Int(airArray[0]) ? "✅" : "❌")
        
        let swiftArr: [Int] = [1, 2, 3]
        let swiftArrayFre = FREArray(intArray: swiftArr)
        let swiftArrBack = [Int](swiftArrayFre)
        trace("Swift IntArray:", 3 == swiftArrBack?[2] ? "✅" : "❌")
        trace("-------------------------------------------")
        return airArray.rawValue
        
    }
    
    func runObjectTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Object test***********")
        
        guard argc > 0, let person = argv[0] else {
            return nil
        }
        
        let newPerson = FREObject(className: "com.tuarua.Person")
        trace("We created a new person. type =", newPerson?.type ?? "unknown")
        
        if let swiftPerson = FreObjectSwift(className: "com.tuarua.Person") {
            trace("FreObjectSwift age 1", Int(swiftPerson.age) ?? "unknown")
            swiftPerson.age = 999
            trace("FreObjectSwift age 2", Int(swiftPerson.age) ?? "unknown")
            swiftPerson.age = 111.toFREObject()
            trace("FreObjectSwift age 3", Int(swiftPerson.age) ?? "unknown")
            let swiftPersonType = swiftPerson.type
            trace("We created a new person using FreObjectSwift. type =", swiftPersonType)
            
        }
        
        if let oldAge = Int(person["age"]) {
            trace("current person age is", oldAge)
            if let addition = person.call(method: "add", args: 100, 31) {
                if let result = Int(addition) {
                    trace("addition result:", result)
                }
            }
            
            if let dictionary = Dictionary(person) {
                trace("AIR Object converted to Dictionary using getAsDictionary:", dictionary.description)
            }
            
        }
        trace("-------------------------------------------")
        return person
    }
    
    func runBitmapTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Bitmap test***********")
        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }
        
        let asBitmapData = FreBitmapDataSwift(freObject: inFRE0)
        
        defer {
            asBitmapData.releaseData()
        }
        do {
            if let cgimg = asBitmapData.asCGImage() {
                let context = CIContext()
                if let filter = CIFilter(name: "CISepiaTone") {
                    filter.setValue(0.8, forKey: kCIInputIntensityKey)
                    let image = CIImage(cgImage: cgimg)
                    filter.setValue(image, forKey: kCIInputImageKey)
                    let result = filter.outputImage!
#if os(iOS) || os(tvOS)
                    if let cgImage = context.createCGImage(result, from: result.extent) {
                        let img: UIImage = UIImage.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
                        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                            let imgView: UIImageView = UIImageView.init(image: img)
                            imgView.frame = CGRect.init(x: 10, y: 120, width: img.size.width, height: img.size.height)
                            rootViewController.view.addSubview(imgView)
                        }
                    }
#else
                    if let newImage = context.createCGImage(result, from: result.extent, format: CIFormat.BGRA8,
                                                            colorSpace: cgimg.colorSpace) {
                        try asBitmapData.setPixels(cgImage: newImage)
                    }
#endif
                }
            }
        } catch {
        }
        
        return nil
    }
    
    func runByteArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start ByteArray test***********")
        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }
        
        let asByteArray = FreByteArraySwift(freByteArray: inFRE0)
        if let byteData = asByteArray.value {
            let base64Encoded = byteData.base64EncodedString(options: .init(rawValue: 0))
            trace("ByteArray passed from AIR to base64:", base64Encoded,
                  base64Encoded == "U3dpZnQgaW4gYW4gQU5FLiBTYXkgd2hhYWFhdCE=" ? "✅" : "❌")
        }
        asByteArray.releaseBytes() //don't forget to release
        trace("-------------------------------------------")
        return nil
        
    }
    
    func runDataTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start ActionScriptData test***********")
        if let objectAs = argv[0] {
            context.setActionScriptData(object: objectAs)
            return context.getActionScriptData()
        }
        return nil
    }
    
    func runErrorTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Error Handling test***********")
        
        guard argc > 0,
            let person = argv[0],
            let expectInt = argv[1] else {
                return nil
        }
        
        _ = person["doNotExist"]
        _ = person.call(method: "add", args: 2) //not passing enough args
        
        guard FreObjectTypeSwift.int == expectInt.type else {
            return FreError(stackTrace: "",
                                 message: "Oops, we expected the FREObject to be passed as an int but it's not",
                                 type: .typeMismatch).getError(#file, #line, #column)
        }
        
        trace("-------------------------------------------")
        return nil
    }
    
    func runExtensibleTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Rectangle Point test***********")
        guard argc > 1,
            let frePoint = CGPoint(argv[0]), //point, rectangle
            let freRect = CGRect(argv[1]) else {
                return nil
        }
        let testPoint = CGPoint(x: 1, y: 55.5)
        let testRect = CGRect(x: 9.1, y: 0.5, width: 20, height: 50)
        trace("Point passed from AIR as CGPoint:", frePoint.debugDescription, frePoint.equalTo(testPoint) ? "✅" : "❌")
        trace("Rectangle passed from AIR as CGRect:", freRect.debugDescription, freRect.equalTo(testRect) ? "✅" : "❌")
        trace("-------------------------------------------")
        return CGPoint(x: 10.2, y: 99.9).toFREObject()
    }
    
    func runDateTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let date = Date(argv[0])
        return date?.toFREObject()
    }
    
    func runColorTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Color test ***********")
        guard argc > 0,
            let inFRE0 = argv[0],
            let inFRE1 = argv[1] else {
                return nil
        }
        var ret: FREObject? = nil
#if os(iOS) || os(tvOS)
        let airColor = UIColor(inFRE0, hasAlpha: false)
        let airColorWithAlpha = UIColor(inFRE0)
        
        let testColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 1)
        let testColorAlpha = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.5)
        
        trace("Point passed from AIR as CGPoint:", airColor.debugDescription, airColor?.isEqual(testColor) ?? false ? "✅" : "❌")
        trace("Point passed from AIR as CGPoint:", airColorWithAlpha.debugDescription, airColorWithAlpha?.isEqual(testColorAlpha) ?? false ? "✅" : "❌")
        
        ret = airColor?.toFREObject()
#else
        
        let airColor = NSColor(inFRE0, hasAlpha: false)
        let airColorWithAlpha = NSColor(inFRE1)
        
        trace("Colour passed from AIR as Color (RGB):", airColor.debugDescription,
              airColor?.alphaComponent.isEqual(to: 1.0) ?? false
                && airColor?.redComponent.isEqual(to: 0) ?? false
                && airColor?.greenComponent.isEqual(to: 1.0) ?? false
                && airColor?.blueComponent.isEqual(to: 0) ?? false
                ? "✅" : "❌")
        
        trace("Colour passed from AIR as Color (ARGB):", airColorWithAlpha.debugDescription,
              String(format: "%.1f", airColorWithAlpha?.alphaComponent ?? 0) == "0.5"
                && airColorWithAlpha?.redComponent.isEqual(to: 0) ?? false
                && airColorWithAlpha?.greenComponent.isEqual(to: 1.0) ?? false
                && airColorWithAlpha?.blueComponent.isEqual(to: 0) ?? false
                ? "✅" : "❌")
        
        ret = airColorWithAlpha?.toFREObject()
#endif
        trace("-------------------------------------------")
        return ret
    }
    
}
