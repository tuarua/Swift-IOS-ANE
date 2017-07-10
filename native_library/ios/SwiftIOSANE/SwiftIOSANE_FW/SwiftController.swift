/*@copyright The code is licensed under the[MIT
 License](http://opensource.org/licenses/MIT):
 
 Copyright © 2017 -  Tua Rua Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files(the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions :
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/

import Foundation
import CoreImage

@objc class SwiftController: FreSwiftController {

    private var context: FreContextSwift!
    private func trace(_ value: Any...){
        freTrace(ctx: context, value: value)
    }
    
    // Must have this function. It exposes the methods to our entry ObjC.
    func getFunctions() -> Array<String> {

        functionsToSet["runStringTests"] = runStringTests
        functionsToSet["runNumberTests"] = runNumberTests
        functionsToSet["runIntTests"] = runIntTests
        functionsToSet["runArrayTests"] = runArrayTests
        functionsToSet["runObjectTests"] = runObjectTests
        functionsToSet["runBitmapTests"] = runBitmapTests
        functionsToSet["runByteArrayTests"] = runByteArrayTests
        functionsToSet["runErrorTests"] = runErrorTests
        functionsToSet["runErrorTests2"] = runErrorTests2
        functionsToSet["runDataTests"] = runDataTests

        var arr: Array<String> = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }

    func runStringTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start String test***********")
        guard argc == 1,
              let inFRE0 = argv[0],
              let airString: String = FreObjectSwift(freObject: inFRE0).value as? String else {
            return nil
        }

        trace("String passed from AIR:", airString)

        let swiftString: String = "I am a string from Swift"

        do {
            return try FreObjectSwift(string: swiftString).rawValue
        } catch {
        }
        return nil
    }

    func runNumberTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Number test***********")
        guard argc == 1, let inFRE0 = argv[0],
              let airNumber: Double = FreObjectSwift(freObject: inFRE0).value as? Double else {
            return nil
        }

        trace("Number passed from AIR:", airNumber)
        let swiftDouble: Double = 34343.31

        do {
            return try FreObjectSwift(double: swiftDouble).rawValue
        } catch {
        }

        return nil
    }

    func runIntTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Int Uint test***********")
        guard argc == 2, let inFRE0 = argv[0],
              let inFRE1 = argv[1],
              let airInt: Int = FreObjectSwift(freObject: inFRE0).value as? Int,
              let airUInt: Int = FreObjectSwift(freObject: inFRE1).value as? Int else {
            return nil
        }


        trace("Int passed from AIR:", airInt)
        trace("UInt passed from AIR:", airUInt)

        let swiftInt: Int = -666
        let swiftUInt: UInt = 888
        do {
            try _ = FreObjectSwift(uint: swiftUInt).value
            return try FreObjectSwift(int: swiftInt).rawValue
        } catch {
        }

        return nil
    }

    func runArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Array test NEW ***********")

        guard argc == 1, let inFRE0 = argv[0] else {
            return nil
        }

        let airArray: FreArraySwift = FreArraySwift.init(freObject: inFRE0)
        do {
            let airArrayLen = airArray.length

            trace("Array passed from AIR:", airArray.value)
            trace("AIR Array length:", airArrayLen)


            if let itemZero: FreObjectSwift = try airArray.getObjectAt(index: 0) {
                if let itemZeroVal: Int = itemZero.value as? Int {
                    trace("AIR Array elem at 0 type:", "value:", itemZeroVal)
                    let newVal = try FreObjectSwift.init(int: 56)
                    try airArray.setObjectAt(index: 0, object: newVal)
                    return airArray.rawValue
                }
            }

        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }

        return nil

    }

    func runObjectTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Object test***********")

        guard argc == 1, let inFRE0 = argv[0] else {
            return nil
        }


        let person = FreObjectSwift.init(freObject: inFRE0)

        do {

            if let freAge = try person.getProperty(name: "age") {
                if let oldAge: Int = freAge.value as? Int {
                    let newAge = try FreObjectSwift.init(int: oldAge + 10)
                    try person.setProperty(name: "age", prop: newAge)

                    trace("current person age is", oldAge)

                    if let addition: FreObjectSwift = try person.callMethod(name: "add", args: 100, 31) {
                        if let sum: Int = addition.value as? Int {
                            trace("addition result:", sum)
                        }
                    }
                    if let dictionary: Dictionary<String, AnyObject> = person.value as? Dictionary<String, AnyObject> {
                        trace("AIR Object converted to Dictionary using as? Dictionary:", dictionary.description)
                    }

                    return person.rawValue

                }

            }
        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }


        return nil

    }

    func runBitmapTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Bitmap test***********")
        guard argc == 1, let inFRE0 = argv[0] else {
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

        guard argc == 1,
              let inFRE0 = argv[0] else {
            return nil
        }



        let person = FreObjectSwift.init(freObject: inFRE0)

        do {
            _ = try person.callMethod(name: "add", args: 2) //not passing enough args
        } catch let e as FreError {
            trace(e.message) //just catch in Swift, do not bubble to actionscript
        } catch {
        }

        do {
            _ = try person.getProperty(name: "doNotExist") //calling a property that doesn't exist
        } catch let e as FreError {
            if let aneError = e.getError(#file, #line, #column) {
                return aneError //return the error as an actionscript error
            }
        } catch {
        }

        return nil
    }

    func runErrorTests2(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc == 1,
              let inFRE0 = argv[0] else {
            return nil
        }

        let expectInt = FreObjectSwift.init(freObject: inFRE0)
        guard FreObjectTypeSwift.int == expectInt.getType() else {
            trace("Oops, we expected the FREObject to be passed as an int but it's not")
            return nil
        }

        let _: Int = expectInt.value as! Int;


        return nil

    }

    func setFREContext(ctx: FREContext) {
        context = FreContextSwift.init(freContext: ctx)
    }


}
