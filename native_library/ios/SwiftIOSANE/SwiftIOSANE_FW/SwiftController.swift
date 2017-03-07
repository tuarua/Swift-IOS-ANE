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
    private var dllContext: FREContext!
    private var aneHelper = ANEHelper()
    func trace(_ value: Any...) {
        var traceStr: String = ""
        for i in 0 ..< value.count {
            traceStr = traceStr + "\(value[i])" + " "
        }
        _ = FREDispatchStatusEventAsync(ctx: self.dllContext, code: traceStr, level: "TRACE")
    }

    func runStringTests(argv: NSPointerArray) -> FREObject? {
        trace("\n***********Start String test***********")
        if let inFRE = argv.pointer(at: 0) {
            let airString: String = aneHelper.getString(object: inFRE)
            trace("String passed from AIR:", airString)
            let swiftString: String = "I am a string from Swift"
            let swiftString2 = "I am a string in Swift as Any"

            let testAsAny: FREObject? = aneHelper.getFREObject(any: swiftString2)
            aneHelper.traceObjectType(tag: "What type swiftString2: ", object: testAsAny)
            return aneHelper.getFREObject(string: swiftString)
        }
        return nil
    }

    func runNumberTests(argv: NSPointerArray) -> FREObject? {
        trace("\n***********Start Number test***********")
        if let inFRE = argv.pointer(at: 0) {
            let airNumber: Double = aneHelper.getDouble(object: inFRE)
            trace("Number passed from AIR:", airNumber)
            let swiftDouble: Double = 34343.31
            return aneHelper.getFREObject(double: swiftDouble)
        }
        return nil
    }

    func runIntTests(argv: NSPointerArray) -> FREObject? {
        if let inFRE1 = argv.pointer(at: 0), let inFRE2 = argv.pointer(at: 1) {
            trace("\n***********Start Int Uint test***********")
            let airInt: Int = aneHelper.getInt(object: inFRE1)
            let airUint: UInt = aneHelper.getUInt(object: inFRE2)
            let swiftInt: Int32 = -666
            let swiftUInt: UInt = 888
            trace("Int passed from AIR:", airInt)
            trace("Uint passed from AIR:", airUint)
            _ = aneHelper.getFREObject(uint: swiftUInt)
            return aneHelper.getFREObject(int32: swiftInt)
        }
        return nil
    }

    func runArrayTests(argv: NSPointerArray) -> FREObject? {
        trace("\n***********Start Array test***********")
        if let inFRE = argv.pointer(at: 0) {

            let airArray = aneHelper.getArray(arrayOrVector: inFRE)
            trace("Array passed from AIR:", airArray)
            trace("AIR Array length:", aneHelper.getArrayLength(arrayOrVector: inFRE))

            var itemZero: FREObject?
            let status: FREResult = FREGetArrayElementAt(arrayOrVector: inFRE, index: 0, value: &itemZero)
            aneHelper.traceObjectType(tag: "AIR Array elem at 0 type", object: itemZero)

            if FRE_OK == status {
                trace("AIR Array item 0:", aneHelper.getInt(object: itemZero!))
                if let newVal = aneHelper.getFREObject(int32: 56) {
                    _ = FRESetArrayElementAt(arrayOrVector: inFRE, index: 0, value: newVal)
                }
            }

            return inFRE
        }
        return nil

    }

    func runObjectTests(argv: NSPointerArray) -> FREObject? {
        trace("\n***********Start Object test***********")
        if let person = argv.pointer(at: 0) {
            if let freAge = aneHelper.getProperty(object: person, name: "age") {
                let oldAge: Int = aneHelper.getInt(object: freAge)
                let newAge: FREObject = aneHelper.getFREObject(int: oldAge + 10)!


                aneHelper.setProperty(object: person, name: "age", prop: newAge)
                aneHelper.traceObjectType(tag: "person type is: ", object: person)
                trace("current person age is", oldAge)

                let addition: FREObject? = aneHelper.call(object: person, methodName: "add", params: 100, 33)

                if FRE_TYPE_NULL != aneHelper.getObjectType(object: addition) {
                    trace("addition result:", aneHelper.getInt(object: addition!))
                }

                let dictionary = aneHelper.getDictionary(object: person)
                trace("AIR Object converted to Dictionary:", dictionary.description)

                return person
            }

        }
        return nil

    }
    
    func runBitmapTests(argv: NSPointerArray) -> FREObject? {
        trace("\n***********Start Bitmap test***********")
        if let objectBitmapData = argv.pointer(at: 0) {
            if let img = aneHelper.getImage(object: objectBitmapData) {
                 trace("image loaded", img.size.width, "x", img.size.height)

                if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                    
                    let imgView:UIImageView = UIImageView.init(image: img)
                    let frame:CGRect = CGRect.init(x: 10, y: 100, width: img.size.width, height: img.size.height)
                    imgView.frame = frame
                    
                    
                    rootViewController.view.addSubview(imgView)
                }
                
                
            }
            _ = FREReleaseBitmapData(object: objectBitmapData);
            trace("bitmap test finish")
            
        }
        return nil
    }

    func setFREContext(ctx: FREContext) {
        dllContext = ctx
        aneHelper.setFREContext(ctx: ctx)
    }


}
