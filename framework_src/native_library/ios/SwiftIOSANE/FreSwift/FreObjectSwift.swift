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
/// :nodoc:
open class FreObjectSwift: NSObject {
    public var rawValue: FREObject? = nil
    open var value: Any? {
        get {
            do {
                if let raw = rawValue {
                    let idRes = try FreSwiftHelper.getAsId(raw)
                    return idRes
                }
            } catch {
            }
            return nil
        }
    }

    public init(freObject: FREObject?) {
        rawValue = freObject
    }

    public init(freObjectSwift: FreObjectSwift?) {
        rawValue = freObjectSwift?.rawValue
    }

    public init(string: String) throws {
        rawValue = try FreSwiftHelper.newObject(string)
    }

    public init(double: Double) throws {
        rawValue = try FreSwiftHelper.newObject(double)
    }

    public init(date: Date) throws {
        rawValue = try FreSwiftHelper.newObject(date)
    }

    public init(cgFloat: CGFloat) throws {
        rawValue = try FreSwiftHelper.newObject(Double(cgFloat))
    }

    public init(int: Int) throws {
        rawValue = try FreSwiftHelper.newObject(int)
    }

    public init(uint: UInt) throws {
        rawValue = try FreSwiftHelper.newObject(uint)
    }

    public init(bool: Bool) throws {
        rawValue = try FreSwiftHelper.newObject(bool)
    }

    public init(any: Any?) throws {
        super.init()
        rawValue = try _newObject(any: any)
    }

    fileprivate func _newObject(any: Any?) throws -> FREObject? {
        if any == nil {
            return nil
        } else if any is FREObject {
            return (any as! FREObject)
        } else if any is FreObjectSwift {
            return (any as! FreObjectSwift).rawValue
        } else if any is String {
            return try FreSwiftHelper.newObject(any as! String)
        } else if any is Int {
            return try FreSwiftHelper.newObject(any as! Int)
        } else if any is Int32 {
            return try FreSwiftHelper.newObject(any as! Int)
        } else if any is UInt {
            return try FreSwiftHelper.newObject(any as! UInt)
        } else if any is UInt32 {
            return try FreSwiftHelper.newObject(any as! UInt)
        } else if any is Double {
            return try FreSwiftHelper.newObject(any as! Double)
        } else if any is CGFloat {
            return try FreSwiftHelper.newObject(any as! CGFloat)
        } else if any is Bool {
            return try FreSwiftHelper.newObject(any as! Bool)
        } else if any is Date {
            return try FreSwiftHelper.newObject(any as! Date)
        } else if any is CGRect {
            return FreRectangleSwift.init(value: any as! CGRect).rawValue
        } else if any is CGPoint {
            return FrePointSwift.init(value: any as! CGPoint).rawValue
        }
        //TODO add Dict and others

        Swift.debugPrint("_newObject NO MATCH")

        return nil

    }

}

