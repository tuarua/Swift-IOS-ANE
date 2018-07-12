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

public extension CGRect {
    /// init: Initialise a CGRect from a FREObject.
    ///
    /// ```swift
    /// let rect = CGRect(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type flash.geom.Rectangle.
    /// - returns: CGRect?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self.init(x: CGFloat(rv["x"]) ?? 0,
                  y: CGFloat(rv["y"]) ?? 0,
                  width: CGFloat(rv["width"]) ?? 0,
                  height: CGFloat(rv["height"]) ?? 0)
    }
    /// toFREObject: Converts a CGRect into a FREObject of AS3 type flash.geom.Rectangle.
    ///
    /// ```swift
    /// let fre = CGRect().toFREObject()
    /// ```
    /// - returns: FREObject?
    func toFREObject() -> FREObject? {
        var freObject: FREObject? = nil
        do {
            freObject = try FREObject.init(className: "flash.geom.Rectangle",
                                           args: CGFloat(self.origin.x),
                                           CGFloat(self.origin.y),
                                           CGFloat(self.width),
                                           CGFloat(self.height))
            
        } catch {
        }
        
        return freObject
    }
}
