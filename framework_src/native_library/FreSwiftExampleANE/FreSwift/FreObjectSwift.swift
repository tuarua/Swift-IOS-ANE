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
@dynamicMemberLookup
open class FreObjectSwift: NSObject {
    public var rawValue: FREObject?
    open var value: Any? {
        do {
            if let raw = rawValue {
                return try FreSwiftHelper.getAsId(raw)
            }
        } catch {
        }
        return nil
    }

    public subscript(dynamicMember name: String) -> FREObject? {
        get { return rawValue?[name]}
        set { rawValue?[name] = newValue }
    }
    
    public subscript(dynamicMember name: String) -> String? {
        get {  return String(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Bool? {
        get { return Bool(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Bool {
        get { return Bool(rawValue?[name]) ?? false }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Int? {
        get { return Int(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Int {
        get { return Int(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> UInt? {
        get { return UInt(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> UInt {
        get { return UInt(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> NSNumber? {
        get { return NSNumber(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> NSNumber {
        get { return NSNumber(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> CGFloat? {
        get { return CGFloat(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> CGFloat {
        get { return CGFloat(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Float? {
        get { return Float(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Float {
        get { return Float(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Double? {
        get { return Double(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Double {
        get { return Double(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> CGRect? {
        get { return CGRect(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> CGPoint? {
        get { return CGPoint(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public subscript(dynamicMember name: String) -> Date? {
        get { return Date(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    public init(_ any: Any?) {
        super.init()
        rawValue = _newObject(any: any)
    }
    
    public convenience init?(className: String, args: Any?...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(FreObjectSwift(args[i]).rawValue)
        }
        if let rv = try FreSwiftHelper.newObject(className: className, argsArray) {
            self.init(rv)
        } else {
            return nil
        }
    }
    
    public convenience init?(className: String) throws {
        if let rv = try FreSwiftHelper.newObject(className: className) {
            self.init(rv)
        } else {
            return nil
        }
    }

    private func _newObject(any: Any?) -> FREObject? {
        do {
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
                return v.toFREObject()
            } else if any is CGPoint, let v = any as? CGPoint {
                return v.toFREObject()
            } else if any is NSNumber, let v = any as? NSNumber {
                return v.toFREObject()
            }
        } catch {
        }
        
        return nil

    }

}
