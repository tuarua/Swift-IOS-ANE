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
        trace("*********** Start String test ***********")
        guard let airString = String(argv[0]) else {
            return FreArgError(message: "String not converted").getError(#file, #line, #column)
        }
        
        // this will trace an error, can't convert String to Int
        _ = Int(argv[0])
        
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
        
        trace("Number passed from AIR as Double:", testDouble.isEqual(to: airDouble) ? "PASS" : "FAIL", airDouble)
        trace("Number passed from AIR as CGFloat:", testCGFlot.isEqual(to: airCGFloat) ? "PASS" : "FAIL", airCGFloat)
        trace("Number passed from AIR as Float:", testFloat.isEqual(to: airFloat) ? "PASS" : "FAIL", airFloat)
        trace("Number passed from AIR as NSNumber:", testNSNumber.isEqual(to: airNSNumber) ? "PASS" : "FAIL", airNSNumber)
        trace("-------------------------------------------")
        
        let swiftDouble: Double = 34343.31
        return swiftDouble.toFREObject()
    }
    
    func runIntTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Int Uint test***********")
        guard argc > 1,
            let inFRE0 = argv[0],
            let inFRE1 = argv[1],
            let airInt = Int(inFRE0),
            let airUInt = UInt(inFRE1) else {
                return nil
        }
        
        let optionalInt: Int? = Int(inFRE0)
        
        trace("Int passed from AIR:", airInt)
        trace("Int passed from AIR (optional):", optionalInt.debugDescription)
        trace("UInt passed from AIR:", airUInt)
        
        let swiftInt: Int = -666
        return swiftInt.toFREObject()
    }
    
    func runArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Array test ***********")
        
        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }
        
        let airArray: FREArray = FREArray(inFRE0)
            
        let myVector = FREArray(className: "Object", length: 5, fixed: true)
        trace("Vector of Objects should equal 5 ? ", myVector.length)
        
        let airArrayLen = airArray.length
        
        trace("Array passed from AIR:", airArray.value)
        trace("AIR Array length:", airArrayLen)
        for fre in airArray {
            trace("iterate over FREArray", Int(fre) ?? "unknown")
        }
        
        if let itemZero = Int(airArray[0]) { //get using brackets with FREObject
            trace("AIR Array elem at 0 type:", "value:", itemZero)
            airArray.set(index: 0, value: 56)
            airArray.append(value: 222)
            airArray[1] = 123.toFREObject() //set using brackets with FREObject
            return airArray.rawValue
        }

        return nil
        
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
            // swiftPerson.myMethod("", [1, 2, 3])
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
                    if let newImage = context.createCGImage(result, from: result.extent, format: CIFormat.BGRA8, colorSpace: cgimg.colorSpace) {
                        try asBitmapData.setPixels(cgImage: newImage)
                    }
#endif
                }
            }
        } catch {
        }
        
        trace("bitmap test finish")
        
        return nil
    }
    
    func runByteArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start ByteArray test***********")
        
        guard argc == 1, let inFRE0 = argv[0] else {
            return nil
        }
        
        let asByteArray = FreByteArraySwift(freByteArray: inFRE0)
        
        if let byteData = asByteArray.value {
            let base64Encoded = byteData.base64EncodedString(options: .init(rawValue: 0))
            
            trace("Encoded to Base64:", base64Encoded)
        }
        asByteArray.releaseBytes() //don't forget to release
        return nil
        
    }
    
    func runDataTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start ActionScriptData test***********")
        if let objectAs = argv[0] {
            do {
                try context.setActionScriptData(object: objectAs)
                return try context.getActionScriptData()
            } catch {
            }
        }
        return nil
    }
    
    func runErrorTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Error Handling test***********")
        
        guard argc > 0,
            let person = argv[0] else {
                return nil
        }
        
        _ = person["doNotExist"]
        _ = person.call(method: "add", args: 2) //not passing enough args
        
        return nil
    }
    
    func runErrorTests2(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let expectInt = argv[0] else {
                return nil
        }
        
        guard FreObjectTypeSwift.int == expectInt.type else {
            trace("Oops, we expected the FREObject to be passed as an int but it's not")
            return nil
        }
        
        return nil
        
    }
    
    func runExtensibleTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Rectangle Point test***********")
        guard argc > 1,
            let inFRE0 = argv[0], //point, rectangle
            let inFRE1 = argv[1] else {
                trace("runExtensibleTests returning early")
                return nil
        }
        
        if let frePoint = CGPoint(inFRE0) {
            trace(frePoint.debugDescription)
        }
        
        if let freRect = CGRect(inFRE1) {
            trace(freRect.debugDescription)
        }
        return CGPoint(x: 10.2, y: 99.9).toFREObject()
    }
    
    func runDateTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Date test ***********")
        guard argc > 0,
            let date = Date(argv[0]) else {
                return nil
        }
        trace("timeIntervalSince1970 :", date.timeIntervalSince1970)
        return date.toFREObject()
    }
    
    func runColorTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Color test ***********")
        guard argc > 0,
            let inFRE0 = argv[0] else {
                return nil
        }
        var ret: FREObject? = nil
#if os(iOS) || os(tvOS)
        let airColor = UIColor(inFRE0)
        trace(airColor.debugDescription)
        ret = airColor?.toFREObject()
#else
        let airColor = NSColor(inFRE0, hasAlpha: true)
        trace("A", airColor?.alphaComponent ?? "unknown",
              "R", airColor?.redComponent ?? "unknown",
              "G", airColor?.greenComponent ?? "unknown",
              "B", airColor?.blueComponent ?? "unknown")
        ret = airColor?.toFREObject()
#endif
        return ret
    }
    
}
