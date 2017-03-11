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

@objc class SwiftController: NSObject {


    func runStringTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start String test***********")
        if let inFRE = argv.pointer(at: 0) {
            do {
                let airString: String = try inFRE.getAsString()
                trace("String passed from AIR:", airString)
                let swiftString: String = "I am a string from Swift"
                let swiftString2 = "I am a string in Swift as Any"

                if let testAsAny: FREObject = try FREObject.newObject(any: swiftString2) {
                    let typeAsString: String = testAsAny.getTypeAsString()
                    trace(typeAsString)
                }

                return try FREObject.newObject(string: swiftString)

            } catch {
            }
        }
        return nil
    }

    func runNumberTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start Number test***********")
        if let inFRE = argv.pointer(at: 0) {
            do {
                let airNumber: Double = try inFRE.getAsDouble()
                trace("Number passed from AIR:", airNumber)
                let swiftDouble: Double = 34343.31
                return try FREObject.newObject(double: swiftDouble)
            } catch {
            }
        }
        return nil
    }

    func runIntTests(argv: NSPointerArray) -> FREObject? {
        if let inFRE1 = argv.pointer(at: 0), let inFRE2 = argv.pointer(at: 1) {
            trace("***********Start Int Uint test***********", "file:", #file, "line:", #line, "column:", #column)
            do {
                let airInt: Int = try inFRE1.getAsInt()
                let airUint: UInt = try inFRE2.getAsUInt()
                trace("Int passed from AIR:", airInt)
                trace("Uint passed from AIR:", airUint)
                let swiftInt: Int = -666
                let swiftUInt: UInt = 888


                try _ = FREObject.newObject(uint: swiftUInt)
                return try FREObject.newObject(int: swiftInt)
            } catch {
            }
        }
        return nil
    }

    //TODO check whether the C ANE methods can be added in Swift
    //http://stackoverflow.com/questions/30740560/new-conventionc-in-swift-2-how-can-i-use-it
    //public typealias FREFunction = @convention(c) (FREContext?, UnsafeMutableRawPointer?, UInt32, UnsafeMutablePointer<FREObject?>?) -> FREObject?


    func runArrayTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start Array test***********")
        if let inFRE: FREArray = argv.pointer(at: 0) {
            do {

                let airArray = try inFRE.getAsArray()
                let airArrayLen = try inFRE.getLength()
                trace("Array passed from AIR:", airArray)
                trace("AIR Array length:", airArrayLen)

                if let itemZero: FREObject = try inFRE.getObjectAt(index: 0) {
                    let itemZeroVal: Int = try itemZero.getAsInt()
                    trace("AIR Array elem at 0 type:", itemZero.getTypeAsString(), "value:", itemZeroVal)

                    if let newVal = try FREObject.newObject(int: 56) {
                        try inFRE.setObjectAt(index: 0, object: newVal)
                    }

                    return inFRE

                }
            } catch {
            }
        }
        return nil

    }

    func runObjectTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start Object test***********")
        if let person = argv.pointer(at: 0) {
            do {
                if let freAge: FREObject = try person.getProperty(name: "age") {

                    let oldAge: Int = try freAge.getAsInt()
                    let newAge: FREObject? = try FREObject.newObject(int: oldAge + 10)
                    try person.setProperty(name: "age", prop: newAge!)

                    let personType: String = person.getTypeAsString()
                    trace("person type is:", personType)
                    trace("current person age is", oldAge)

                    if let addition: FREObject = try person.callMethod(methodName: "add",
                            args: FREObject.toArray(args: 100, 33)) {
                        let sum: Int = try addition.getAsInt()
                        trace("addition result:", sum)
                    }

                    let dictionary = try person.getAsDictionary()
                    trace("AIR Object converted to Dictionary using getAsDictionary:", dictionary.description)

                    return person
                }
            } catch {
            }

        }
        return nil

    }

    func runBitmapTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start Bitmap test***********")
        if let inFRE = argv.pointer(at: 0) {
            if let cgimg = inFRE.getAsImage() {
                let img: UIImage = UIImage(cgImage: cgimg)
                trace("image loaded", img.size.width, "x", img.size.height)
                if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    let imgView: UIImageView = UIImageView.init(image: img)
                    let frame: CGRect = CGRect.init(x: 10, y: 100, width: img.size.width, height: img.size.height)
                    imgView.frame = frame
                    rootViewController.view.addSubview(imgView)
                }
            }
            inFRE.release()




            if let cgimg = inFRE.getAsImage() {
                let img: UIImage = UIImage(cgImage: cgimg)
            }
            inFRE.release()



            trace("bitmap test finish")
        }
        return nil
    }

    func runByteArrayTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start ByteArray test***********")
        if let asByteArray = argv.pointer(at: 0) {
            let byteData: NSData? = asByteArray.getAsData()
            if let base64Encoded = byteData?.base64EncodedString(options:.init(rawValue: 0)) {
                trace("Encoded to Base64:", base64Encoded)
            }
            asByteArray.release()
        }
        return nil
    }

    func runDataTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start ActionScriptData test***********")
        if let objectAs = argv.pointer(at: 0) {
            do {
                try context.setActionScriptData(object: objectAs)
                return try context.getActionScriptData()
            } catch {
            }
        }
        return nil
    }

    func runErrorTests(argv: NSPointerArray) -> FREObject? {
        trace("***********Start Error Handling test***********")
        if let person = argv.pointer(at: 0), let testString = argv.pointer(at: 1), let testInt = argv.pointer(at: 2) {
            do {
                _ = try person.getProperty(name: "doNotExist") //calling a property that doesn't exist
            } catch let e as FREError {
                e.printStackTrace(#file, #line, #column)
            } catch {
            }

            do {
                _ = try person.callMethod(methodName: "noMethod", args: nil) //calling an nonexistent method
            } catch let e as FREError {
                e.printStackTrace(#file, #line, #column)
            } catch {
            }


            do {
                _ = try person.callMethod(methodName: "add", args: FREObject.toArray(args: testInt)) //not passing enough args
            } catch let e as FREError {
                e.printStackTrace(#file, #line, #column)
            } catch {
            }


            do {
                _ = try testString.getAsInt() //get as wrong type
            } catch let e as FREError {
                e.printStackTrace(#file, #line, #column)
            } catch {
            }

        }
        return nil
    }

    func setFREContext(ctx: FREContext) {
        context = ctx
    }


}
