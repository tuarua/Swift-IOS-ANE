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
            let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
            let arg0: FREObject? = try FreObjectSwift.init(cgFloat: value.origin.x).rawValue
            argsArray.addPointer(arg0)
            let arg1: FREObject? = try FreObjectSwift.init(cgFloat: value.origin.y).rawValue
            argsArray.addPointer(arg1)
            let arg2: FREObject? = try FreObjectSwift.init(cgFloat: value.width).rawValue
            argsArray.addPointer(arg2)
            let arg3: FREObject? = try FreObjectSwift.init(cgFloat: value.height).rawValue
            argsArray.addPointer(arg3)
            freObject = try FreSwiftHelper.newObject("flash.geom.Rectangle", argsArray)
        } catch {
        }
        
        super.init(freObject: freObject)
    }
    
    override public var value: Any? {
        get {
            do {
                if let raw = rawValue {
                    let idRes = try getAsCGRect(raw) as Any?
                    return idRes
                }
            } catch {
            }
            return nil
        }
    }
    
    private func getAsCGRect(_ rawValue: FREObject) throws -> CGRect {
        var ret: CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        
        if let xInt = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "x")).value as? Int {
            ret.origin.x = CGFloat.init(xInt)
        } else if let xDbl = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "x")).value as? Double {
            ret.origin.x = CGFloat.init(xDbl)
        }
        
        if let yInt = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "y")).value as? Int {
            ret.origin.y = CGFloat.init(yInt)
        } else if let yDbl = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "y")).value as? Double {
            ret.origin.y = CGFloat.init(yDbl)
        }
        
        if let wInt = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "width")).value as? Int {
            ret.size.width = CGFloat.init(wInt)
        } else if let wDbl = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "width")).value as? Double {
            ret.size.width = CGFloat.init(wDbl)
        }
        
        if let hInt = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "height")).value as? Int {
            ret.size.height = CGFloat.init(hInt)
        } else if let hDbl = try FreObjectSwift.init(freObject: FreSwiftHelper.getProperty(rawValue: rawValue, name: "height")).value as? Double {
            ret.size.height = CGFloat.init(hDbl)
        }
        
        return ret
    }
    
}
