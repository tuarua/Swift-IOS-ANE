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

public extension CGPoint {
    /// init: Initialise a CGPoint from a FREObject.
    ///
    /// ```swift
    /// let rect = CGPoint(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type flash.geom.Point
    /// - returns: CGPoint?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else { return nil }
        let fre = FreObjectSwift(rv)
        self.init(x: fre.x as CGFloat, y: fre.y)
    }
    /// toFREObject: Converts a CGPoint into a FREObject of AS3 type flash.geom.Point.
    ///
    /// ```swift
    /// let fre = CGPoint().toFREObject()
    /// ```
    /// - returns: FREObject?
    func toFREObject() -> FREObject? {
        return FREObject(className: "flash.geom.Point", args: x, y)
    }
}

public extension FreObjectSwift {
    /// subscript: sets/gets the Property of a FREObject.
    ///
    /// ```swift
    /// let freCoord = FreObjectSwift(className: "com.tuarua.Coordinate")
    /// let coord: CGPoint = freCoord.coordinates
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: CGPoint?
    public subscript(dynamicMember name: String) -> CGPoint? {
        get { return CGPoint(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
