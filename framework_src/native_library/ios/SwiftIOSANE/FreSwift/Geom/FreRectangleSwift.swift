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
/// :nodoc:
public class FreRectangleSwift: FreObjectSwift {
    override public init(freObject: FREObject?) {
        super.init(freObject: freObject)
    }
    
    public init(value: CGRect) {
        var freObject: FREObject? = nil
        do {
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
        if let rv = rawValue {
            let idRes = CGRect.init(rv) as Any?
            return idRes
        }
        return nil
    }
    
}

public extension CGRect {
    /// init: Initialise a CGRect from a FREObject.
    ///
    /// ```swift
    /// let rect = CGRect.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type flash.geom.Rectangle.
    /// - returns: CGRect?
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
    /// toFREObject: Converts a CGRect into a FREObject of AS3 type flash.geom.Rectangle.
    ///
    /// ```swift
    /// let fre = CGRect.init().toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreRectangleSwift(value: self).rawValue
    }
}
