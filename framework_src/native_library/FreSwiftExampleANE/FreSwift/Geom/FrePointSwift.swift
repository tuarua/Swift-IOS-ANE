/* Copyright 2018 Tua Rua Ltd.
 
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
#if canImport(Cocoa)
    import Cocoa
#endif
/// :nodoc:
public class FrePointSwift: FreObjectSwift {
    override public init(freObject: FREObject?) {
        super.init(freObject: freObject)
    }
    
    public init(value: CGPoint) {
        var freObject: FREObject? = nil
        do {
            freObject = try FREObject.init(className: "flash.geom.Point",
                                           args: CGFloat(value.x), CGFloat(value.y))
        } catch {
        }
        
        super.init(freObject: freObject)
    }
    
    override public var value: Any? {
        if let rv = rawValue {
            let idRes = CGPoint.init(rv) as Any?
            return idRes
        }
        return nil
    }
    
}

public extension CGPoint {
    /// init: Initialise a CGPoint from a FREObject.
    ///
    /// ```swift
    /// let rect = CGPoint(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type flash.geom.Point
    /// - returns: CGPoint?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self.init(x: CGFloat(rv["x"]) ?? 0,
                  y: CGFloat(rv["y"]) ?? 0)
    }
    /// toFREObject: Converts a CGPoint into a FREObject of AS3 type flash.geom.Point.
    ///
    /// ```swift
    /// let fre = CGPoint.init().toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FrePointSwift(value: self).rawValue
    }
}
