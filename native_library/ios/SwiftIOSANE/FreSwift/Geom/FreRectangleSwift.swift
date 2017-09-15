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

import Foundation
#if os(OSX)
    import Cocoa
#endif

public class FreRectangleSwift: FreObjectSwift {
    override public init(freObject: FREObject?) {
        super.init(freObject: freObject)
    }
    
    public init(value: CGRect) {
        var freObject: FREObject? = nil
        do {
//            let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
//            //let arg0: FREObject? = try FreObjectSwift.init(cgFloat: value.origin.x).rawValue
//            let arg0: FREObject? = CGFloat.init(value.origin.x).toFREObject()
//            argsArray.addPointer(arg0)
//            //let arg1: FREObject? = try FreObjectSwift.init(cgFloat: value.origin.y).rawValue
//            let arg1: FREObject? = CGFloat.init(value.origin.y).toFREObject()
//            argsArray.addPointer(arg1)
//            //let arg2: FREObject? = try FreObjectSwift.init(cgFloat: value.width).rawValue
//            let arg2: FREObject? = CGFloat.init(value.width).toFREObject()
//            argsArray.addPointer(arg2)
//            //let arg3: FREObject? = try FreObjectSwift.init(cgFloat: value.height).rawValue
//            let arg3: FREObject? = CGFloat.init(value.height).toFREObject()
//            argsArray.addPointer(arg3)
//            freObject = try FreSwiftHelper.newObject(className: "flash.geom.Rectangle", argsArray)
            
            
            freObject = try FREObject.init(className: "flash.geom.Rectangle",
                                           args: CGFloat.init(value.origin.x),
                                           CGFloat.init(value.origin.y),
                                           CGFloat.init(value.width),
                                           CGFloat.init(value.height))
            
        } catch {
        }
        
        super.init(freObject: freObject)
    }
    
    override public var value: Any? {
        get {
            if let rv = rawValue {
                let idRes = CGRect.init(rv) as Any?
                return idRes
            }
            return nil
        }
    }
    
}

public extension CGRect {
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        var x: CGFloat = CGFloat.init(0)
        var y: CGFloat = CGFloat.init(0)
        var w: CGFloat = CGFloat.init(0)
        var h: CGFloat = CGFloat.init(0)
        do {
            if let rvX = try FreSwiftHelper.getProperty(rawValue: rv, name: "x"), let xVal = CGFloat.init(rvX) {
                x = xVal
            }
            if let rvY = try FreSwiftHelper.getProperty(rawValue: rv, name: "y"), let yVal = CGFloat.init(rvY) {
                y = yVal
            }
            if let rvW = try FreSwiftHelper.getProperty(rawValue: rv, name: "width"), let wVal = CGFloat.init(rvW) {
                w = wVal
            }
            if let rvH = try FreSwiftHelper.getProperty(rawValue: rv, name: "height"), let hVal = CGFloat.init(rvH) {
                h = hVal
            }
        } catch {
        }
        self.init(x: x, y: y, width: w, height: h)
    }
    
//    init?(_ freObjectSwift: FreObjectSwift?) {
//        guard let val = freObjectSwift, let rv = val.rawValue else {
//            return nil
//        }
//        self.init(rv)
//    }
    func toFREObject() -> FREObject? {
        return FreRectangleSwift(value: self).rawValue
    }
}
