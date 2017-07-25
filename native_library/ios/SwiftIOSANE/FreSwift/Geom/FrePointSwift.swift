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
            do {
                if let raw = rawValue {
                    let idRes = try getAsCGPoint(raw) as Any?
                    return idRes
                }
            } catch {
            }
            return nil
        }
    }
    
    private func getAsCGPoint(_ rawValue: FREObject) throws -> CGPoint {
        var ret: CGPoint = CGPoint.init(x: 0, y: 0)
        
        if let xInt = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "x")).value as? Int {
            ret.x = CGFloat.init(xInt)
        } else if let xDbl = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "x")).value as? Double {
            ret.x = CGFloat.init(xDbl)
        }
        
        if let yInt = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "y")).value as? Int {
            ret.y = CGFloat.init(yInt)
        } else if let yDbl = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "y")).value as? Double {
            ret.y = CGFloat.init(yDbl)
        }
        
        return ret
    }
    
}
