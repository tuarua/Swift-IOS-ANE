/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

import UIKit
import Foundation
import CoreImage
import FreSwift


public class SwiftController: NSObject, FreSwiftMainController {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var appDidFinishLaunchingNotif:Notification?
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> Array<String> {

        functionsToSet["\(prefix)runStringTests"] = runStringTests
        functionsToSet["\(prefix)runNumberTests"] = runNumberTests
        functionsToSet["\(prefix)runIntTests"] = runIntTests
        functionsToSet["\(prefix)runArrayTests"] = runArrayTests
        functionsToSet["\(prefix)runObjectTests"] = runObjectTests
        functionsToSet["\(prefix)runBitmapTests"] = runBitmapTests
        functionsToSet["\(prefix)runByteArrayTests"] = runByteArrayTests
        functionsToSet["\(prefix)runErrorTests"] = runErrorTests
        functionsToSet["\(prefix)runErrorTests2"] = runErrorTests2
        functionsToSet["\(prefix)runDataTests"] = runDataTests
        functionsToSet["\(prefix)runRectTests"] = runRectTests
        functionsToSet["\(prefix)runDateTests"] = runDateTests

        var arr: Array<String> = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }

    func runStringTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start String test***********")
        
        guard argc > 0,
            let inFRE0 = argv[0],
            let airString = String(inFRE0) else {
                return nil
        }
        
        trace("String passed from AIR:", airString)
        let swiftString: String = "I am a string from Swift"
        return swiftString.toFREObject()
    }

    func runNumberTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Number test***********")
        guard argc > 0,
            let inFRE0 = argv[0],
            let airDouble = Double(inFRE0),
            let airCGFloat = CGFloat(inFRE0),
            let airFloat = Float(inFRE0)
            else {return nil}
        
        trace("Number passed from AIR as Double:", airDouble.debugDescription)
        trace("Number passed from AIR as CGFloat:", airCGFloat.description)
        trace("Number passed from AIR as Float:", airFloat.description)
        
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
        
        let optionalInt:Int? = Int(inFRE0)
        
        trace("Int passed from AIR:", airInt)
        trace("Int passed from AIR (optional):", optionalInt.debugDescription)
        trace("UInt passed from AIR:", airUInt)
        
        let swiftInt: Int = -666
        return swiftInt.toFREObject()
    }

    func runArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Array test NEW ***********")

        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }
        
        let airArray: FREArray = FREArray.init(inFRE0)
        do {
            let airArrayLen = airArray.length
            
            trace("Array passed from AIR:", airArray.value)
            trace("AIR Array length:", airArrayLen)
            
            if let itemZero = try Int(airArray.at(index: 0)) {
                trace("AIR Array elem at 0 type:", "value:", itemZero)
                try airArray.set(index: 0, value: 56)
                return airArray.rawValue
            }
            
        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }
        
        return nil

    }

    func runObjectTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Object test***********")
        
        guard argc > 0, let person = argv[0] else {
            return nil
        }
        
        do {
            let newPerson = try FREObject(className: "com.tuarua.Person")
            trace("We created a new person. type =", newPerson?.type ?? "unknown")
            
            if let oldAge = try Int(person.getProp(name: "age")) {
                trace("current person age is", oldAge)
                try person.setProp(name: "age", value: oldAge + 10)
                if let addition = try person.call(method: "add", args: 100, 31) {
                    if let result = Int(addition) {
                        trace("addition result:", result)
                    }
                }
                
                if let dictionary = Dictionary.init(person) {
                    trace("AIR Object converted to Dictionary using getAsDictionary:", dictionary.description)
                }
                
            }
            
            return person
            
        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }
        
        
        return nil


    }

    func runBitmapTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Bitmap test***********")
        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }

        let asBitmapData = FreBitmapDataSwift.init(freObject: inFRE0)

        defer {
            asBitmapData.releaseData()
        }
        do {
            if let cgimg = try asBitmapData.getAsImage() {
                
                let context = CIContext()
                if let filter = CIFilter(name: "CISepiaTone") {
                    filter.setValue(0.8, forKey: kCIInputIntensityKey)
                    let image = CIImage.init(cgImage: cgimg)
                    filter.setValue(image, forKey: kCIInputImageKey)
                    let result = filter.outputImage!
                    if let cgImage = context.createCGImage(result, from: result.extent) {
                        let img:UIImage = UIImage.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
                        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                            let imgView: UIImageView = UIImageView.init(image: img)
                            imgView.frame = CGRect.init(x: 10, y: 120, width: img.size.width, height: img.size.height)
                            rootViewController.view.addSubview(imgView)
                        }
                    }
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

        let asByteArray = FreByteArraySwift.init(freByteArray: inFRE0)

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
        
        do {
            _ = try person.call(method: "add", args: 2) //not passing enough args
        } catch let e as FreError {
            trace(e.message) //just catch in Swift, do not bubble to actionscript
        } catch {
        }
        
        do {
            _ = try person.getProp(name: "doNotExist") //calling a property that doesn't exist
        } catch let e as FreError {
            if let aneError = e.getError(#file, #line, #column) {
                return aneError //return the error as an actionscript error
            }
        } catch {
        }
        
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
    
    func runRectTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Rectangle Point test***********")
        guard argc > 1,
            let inFRE0:FREObject = argv[0], //point, rectangle
            let inFRE1 = argv[1] else {
                trace("runRectTests returning early")
                return nil
        }
        
        if let frePoint = CGPoint(inFRE0) {
            trace(frePoint.debugDescription)
        }
        
        if let freRect = CGRect(inFRE1) {
            trace(freRect.debugDescription)
        }
        return CGPoint.init(x: 10.2, y: 99.9).toFREObject()
    }
    
    func runDateTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Date test ***********")
        
        guard argc > 0,
            let inFRE0 = argv[0] else {
                return nil
        }
        if let date = Date(inFRE0) {
            trace("timeIntervalSince1970 :", date.timeIntervalSince1970)
            return date.toFREObject()
        }
        return nil
    }

    // Must have these 3 functions. 
    //Exposes the methods to our entry ObjC.
    public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    //Here we set our FREContext
    func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        appDidFinishLaunchingNotif = notification
    }
    
    // Here we add observers for any app delegate stuff
    // Observers are independant of other ANEs and cause no conflicts
    // DO NOT OVERRIDE THE DEFAULT !!
    public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
        
    }


}
