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

public extension CGRect {
    /// init: Initialise a CGRect from a FREObject.
    ///
    /// ```swift
    /// let rect = CGRect(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type flash.geom.Rectangle.
    /// - returns: CGRect?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        self.init(x: fre.x as CGFloat, y: fre.y, width: fre.width, height: fre.height)
    }
    /// toFREObject: Converts a CGRect into a FREObject of AS3 type flash.geom.Rectangle.
    ///
    /// ```swift
    /// let fre = CGRect().toFREObject()
    /// ```
    /// - returns: FREObject?
    func toFREObject() -> FREObject? {
        return FREObject(className: "flash.geom.Rectangle",
                         args: origin.x, origin.y, width, height)
    }
}

public extension FreObjectSwift {
    /// subscript: gets the Property of a FREObject.
    ///
    /// ```swift
    /// let freRoom = FreObjectSwift(className: "com.tuarua.Room")
    /// let dimensions: CGRect? = freRoom.dimensions
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: CGRect?
    subscript(dynamicMember name: String) -> CGRect? {
        get { return CGRect(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
