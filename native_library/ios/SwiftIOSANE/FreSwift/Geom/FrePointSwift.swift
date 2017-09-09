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

public class FrePointSwift: FreObjectSwift {
    override public init(freObject: FREObject?) {
        super.init(freObject: freObject)
    }
    
    public init(value: CGPoint) {
        var freObject: FREObject? = nil
        do {
            let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
            let arg0: FREObject? = try FreObjectSwift.init(cgFloat: value.x).rawValue
            argsArray.addPointer(arg0)
            let arg1: FREObject? = try FreObjectSwift.init(cgFloat: value.y).rawValue
            argsArray.addPointer(arg1)
            freObject = try FreSwiftHelper.newObject("flash.geom.Point", argsArray)
        } catch {
        }
        
        super.init(freObject: freObject)
    }
    
    override public var value: Any? {
        get {
            if let rv = rawValue {
                let idRes = CGPoint.init(rv) as Any?
                return idRes
            }
            return nil
        }
    }
    
}

public extension CGPoint {
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        var x: CGFloat = CGFloat.init(0)
        var y: CGFloat = CGFloat.init(0)
        do {
            if let rvX = try FreSwiftHelper.getProperty(rawValue: rv, name: "x"), let xVal = CGFloat.init(rvX) {
                x = xVal
            }
            if let rvY = try FreSwiftHelper.getProperty(rawValue: rv, name: "y"), let yVal = CGFloat.init(rvY) {
                y = yVal
            }
            
        } catch {
        }
        self.init(x: x, y: y)
    }
    init?(_ freObjectSwift: FreObjectSwift?) {
        guard let val = freObjectSwift, let rv = val.rawValue else {
            return nil
        }
        self.init(rv)
    }
    func toFREObject() -> FREObject? {
        return FrePointSwift(value: self).rawValue
    }
}
