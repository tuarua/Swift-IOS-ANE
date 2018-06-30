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
/// :nodoc:
open class FreObjectSwift: NSObject {
    public var rawValue: FREObject?
    open var value: Any? {
        do {
            if let raw = rawValue {
                let idRes = try FreSwiftHelper.getAsId(raw)
                return idRes
            }
        } catch {
        }
        return nil
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

    public init(float: Float) throws {
        rawValue = try FreSwiftHelper.newObject(Double(float))
    }
    
    public init(cgFloat: CGFloat) throws {
        rawValue = try FreSwiftHelper.newObject(cgFloat)
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
        } else if any is FREObject, let v = any as? FREObject {
            return (v)
        } else if any is FreObjectSwift, let v = any as? FreObjectSwift {
            return v.rawValue
        } else if any is String, let v = any as? String {
            return try FreSwiftHelper.newObject(v)
        } else if any is Int, let v = any as? Int {
            return try FreSwiftHelper.newObject(v)
        } else if any is Int32, let v = any as? Int32 {
            return try FreSwiftHelper.newObject(Int(v))
        } else if any is UInt, let v = any as? UInt {
            return try FreSwiftHelper.newObject(v)
        } else if any is UInt32, let v = any as? UInt32 {
            return try FreSwiftHelper.newObject(UInt(v))
        } else if any is Double, let v = any as? Double {
            return try FreSwiftHelper.newObject(v)
        } else if any is CGFloat, let v = any as? CGFloat {
            return try FreSwiftHelper.newObject(v)
        } else if any is Float, let v = any as? Float {
            return try FreSwiftHelper.newObject(Double(v))
        } else if any is Bool, let v = any as? Bool {
            return try FreSwiftHelper.newObject(v)
        } else if any is Date, let v = any as? Date {
            return try FreSwiftHelper.newObject(v)
        } else if any is CGRect, let v = any as? CGRect {
            return FreRectangleSwift.init(value: v).rawValue
        } else if any is CGPoint, let v = any as? CGPoint {
            return FrePointSwift.init(value: v).rawValue
        }
        return nil

    }

}
