/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

public class FreSwiftHelper {

    private static var logger: FreSwiftLogger {
        return FreSwiftLogger.shared
    }

    @discardableResult
    static func callMethod(_ rawValue: FREObject?, name: String, args: [Any?]) -> FREObject? {
        guard let rv = rawValue else {
            return nil
        }
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(newObject(any: args[i]))
        }
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        numArgs = UInt32((argsArray.count))
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRECallObjectMethod(object: rv, methodName: name,
          argc: numArgs, argv: argsArray,
          result: &ret, thrownException: &thrownException)

#else
        let status = FRECallObjectMethod(rv,
                                                    name,
                                                    numArgs,
                                                    arrayToFREArray(argsArray),
                                                    &ret, &thrownException)
#endif
        
        if FRE_OK == status { return ret }
        logger.log(message: "cannot call method \(name) on \(rv.toString())",
            stackTrace: getActionscriptException(thrownException),
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsString(_ rawValue: FREObject) -> String? {
        var len: UInt32 = 0
        var valuePtr: UnsafePointer<UInt8>?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectAsUTF8(object: rawValue,
                                                                         length: &len, value: &valuePtr)
#else
        let status = FREGetObjectAsUTF8(rawValue, &len, &valuePtr)
#endif
        if FRE_OK == status {
            return NSString(bytes: valuePtr!, length: Int(len), encoding: String.Encoding.utf8.rawValue) as String?
        }
        
        logger.log(message: "cannot get FREObject \(rawValue.toString(true)) as String",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsBool(_ rawValue: FREObject) -> Bool? {
        var val: UInt32 = 0
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectAsBool(object: rawValue, value: &val)
#else
        let status = FREGetObjectAsBool(rawValue, &val)
#endif
        if FRE_OK == status  { return val == 1 }
        logger.log(message: "cannot get FREObject \(rawValue.toString()) as Bool",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsDouble(_ rawValue: FREObject) -> Double? {
        var ret: Double = 0.0
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectAsDouble(object: rawValue, value: &ret)
#else
        let status = FREGetObjectAsDouble(rawValue, &ret)
#endif
        if FRE_OK == status  { return ret }
        logger.log(message: "cannot get FREObject \(rawValue.toString()) as Double",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsDate(_ rawValue: FREObject) -> Date? {
        if let timeFre = rawValue["time"],
            let time = getAsDouble(timeFre) {
            return Date(timeIntervalSince1970: time / 1000.0)
        }
        return nil
    }

    static func getAsInt(_ rawValue: FREObject) -> Int? {
        var ret: Int32 = 0
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectAsInt32(object: rawValue, value: &ret)
#else
        let status = FREGetObjectAsInt32(rawValue, &ret)
#endif
        
        if FRE_OK == status { return Int(ret) }
        logger.log(message: "cannot get FREObject \(rawValue.toString()) as Int",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsUInt(_ rawValue: FREObject) -> UInt? {
        var ret: UInt32 = 0
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectAsUint32(object: rawValue, value: &ret)
#else
        let status = FREGetObjectAsUint32(rawValue, &ret)
#endif
        if FRE_OK == status { return UInt(ret) }
        logger.log(message: "cannot get FREObject \(rawValue.toString()) as UInt",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsId(_ rawValue: FREObject?) -> Any? {
        guard let rv = rawValue else { return nil }
        let objectType: FreObjectTypeSwift = getType(rv)
        switch objectType {
        case .int:
            return getAsInt(rv)
        case .vector, .array:
            return FREArray(rv).value
        case .string:
            return getAsString(rv)
        case .boolean:
            return getAsBool(rv)
        case .object, .class:
            return getAsDictionary(rv) as [String: AnyObject]?
        case .number:
            return getAsDouble(rv)
        case .bitmapdata:
            return FreBitmapDataSwift(freObject: rv).asCGImage()
        case .bytearray:
            let asByteArray = FreByteArraySwift(freByteArray: rv)
            let byteData = asByteArray.value
            asByteArray.releaseBytes()
            return byteData
        case .point:
            return CGPoint(rv)
        case .rectangle:
            return CGRect(rv)
        case .date:
            return getAsDate(rv)
        case .null:
            return nil
        }
    }
    
    public static func newObject(any: Any?) -> FREObject? {
        if any == nil {
            return nil
        } else if any is FREObject, let v = any as? FREObject {
            return (v)
        } else if any is FreObjectSwift, let v = any as? FreObjectSwift {
            return v.rawValue
        } else if any is String, let v = any as? String {
            return newObject(v)
        } else if any is Int, let v = any as? Int {
            return newObject(v)
        } else if any is Int32, let v = any as? Int32 {
            return newObject(Int(v))
        } else if any is UInt, let v = any as? UInt {
            return newObject(v)
        } else if any is UInt32, let v = any as? UInt32 {
            return newObject(UInt(v))
        } else if any is Double, let v = any as? Double {
            return newObject(v)
        } else if any is CGFloat, let v = any as? CGFloat {
            return newObject(v)
        } else if any is Float, let v = any as? Float {
            return newObject(Double(v))
        } else if any is Bool, let v = any as? Bool {
            return newObject(v)
        } else if any is Date, let v = any as? Date {
            return newObject(v)
        } else if any is CGRect, let v = any as? CGRect {
            return v.toFREObject()
        } else if any is CGPoint, let v = any as? CGPoint {
            return v.toFREObject()
        } else if any is NSNumber, let v = any as? NSNumber {
            return v.toFREObject()
        }
        return nil

    }

    public static func arrayToFREArray(_ array: NSPointerArray?) -> UnsafeMutablePointer<FREObject?>? {
        if let array = array {
            let ret = UnsafeMutablePointer<FREObject?>.allocate(capacity: array.count)
            for i in 0..<array.count {
                ret[i] = array.pointer(at: i)
            }
            return ret
        }
        return nil
    }

    public static func getType(_ rawValue: FREObject?) -> FreObjectTypeSwift {
        guard let rawValue = rawValue else { return FreObjectTypeSwift.null }
        var objectType = FRE_TYPE_NULL
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectType(object: rawValue, objectType: &objectType)
#else
        let status = FREGetObjectType(rawValue, &objectType)
#endif
        if FRE_OK == status {
            let type = FreObjectTypeSwift(rawValue: objectType.rawValue) ?? FreObjectTypeSwift.null
            return FreObjectTypeSwift.number == type || FreObjectTypeSwift.object == type
                ? getActionscriptType(rawValue)
                : type
        
        }
        logger.log(message: "cannot get type",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return FreObjectTypeSwift.null
    }

    fileprivate static func getActionscriptType(_ rawValue: FREObject) -> FreObjectTypeSwift {
        if let type = rawValue.className?.lowercased() {
            if type == "int" {
                return FreObjectTypeSwift.int
            } else if type == "date" {
                return FreObjectTypeSwift.date
            } else if type == "string" {
                return FreObjectTypeSwift.string
            } else if type == "number" {
                return FreObjectTypeSwift.number
            } else if type == "boolean" {
                return FreObjectTypeSwift.boolean
            } else if type == "flash.geom::rectangle" {
                return FreObjectTypeSwift.rectangle
            } else if type == "flash.geom::point" {
                return FreObjectTypeSwift.point
            } else {
                return FreObjectTypeSwift.class
            }
        }
        return FreObjectTypeSwift.null
    }

    static func getAsDictionary(_ rawValue: FREObject) -> [String: AnyObject]? {
        var ret = [String: AnyObject]()
        guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
              let classProps = aneUtils.call(method: "getClassProps", args: rawValue) else {
            return nil
        }
        let array = FREArray(classProps)
        for fre in array {
            if let propNameAs = fre["name"],
                let propName = String(propNameAs),
                let propValAs = rawValue[propName],
                let propVal = FreObjectSwift(propValAs).value {
                ret.updateValue(propVal as AnyObject, forKey: propName)
            }
        }
        return ret
    }
    
    static func getAsDictionary(_ rawValue: FREObject) -> [String: Any]? {
        var ret = [String: Any]()
        guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classProps = aneUtils.call(method: "getClassProps", args: rawValue) else {
                return nil
        }
        let array = FREArray(classProps)
        for fre in array {
            if let propNameAs = fre["name"],
                let propName = String(propNameAs),
                let propValAs = rawValue[propName],
                let propVal = FreObjectSwift(propValAs).value {
                ret.updateValue(propVal as Any, forKey: propName)
            }
        }
        return ret
    }
    
    static func getAsDictionary(_ rawValue: FREObject) -> [String: NSObject]? {
        var ret = [String: NSObject]()
        guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classProps = aneUtils.call(method: "getClassProps", args: rawValue) else {
                return nil
        }
        let array = FREArray(classProps)
        for fre in array {
            if let propNameAs = fre["name"],
                let propName = String(propNameAs),
                let propValAs = rawValue[propName],
                let propVal = FreObjectSwift(propValAs).value,
                let pv = propVal as? NSObject {
                ret.updateValue(pv, forKey: propName)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [String]? {
        var ret = [String]()
        let array = FREArray(rawValue)
        for fre in array {
            if let v = String(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Int]? {
        var ret = [Int]()
        let array = FREArray(rawValue)
        for fre in array {
            if let v = Int(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [UInt]? {
        var ret = [UInt]()
        let array = FREArray(rawValue)
        for fre in array {
            if let v = UInt(fre) {
                ret.append(v)
            }
        }
        return ret
    }

    static func getAsArray(_ rawValue: FREObject) -> [Bool]? {
        var ret = [Bool]()
        let array = FREArray(rawValue)
        for fre in array {
            if let v = Bool(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Double]? {
        var ret = [Double]()
        let array = FREArray(rawValue)
        for fre in array {
            if let v = Double(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Date]? {
        var ret = [Date]()
        let array = FREArray(rawValue)
        for fre in array {
            if let v = Date(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Any]? {
        var ret: [Any] = [Any]()
        let array = FREArray(rawValue)
        
        for fre in array {
            if let v = FreObjectSwift(fre).value {
                ret.append(v)
            }
        }
        return ret
    }
    
    public static func getProperty(rawValue: FREObject, name: String) -> FREObject? {
        var ret: FREObject?
        var thrownException: FREObject?

#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetObjectProperty(object: rawValue,
          propertyName: name,
          propertyValue: &ret,
          thrownException: &thrownException)
#else
        let status = FREGetObjectProperty(rawValue, name, &ret, &thrownException)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot get property \(name) of \(rawValue.toString())",
            stackTrace: getActionscriptException(thrownException),
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func setProperty(rawValue: FREObject, name: String, prop: FREObject?) {
        var thrownException: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRESetObjectProperty(object: rawValue,
          propertyName: name,
          propertyValue: prop,
          thrownException: &thrownException)
#else
        let status = FRESetObjectProperty(rawValue, name, prop, &thrownException)
#endif
        if FRE_OK == status { return }
        logger.log(message: "cannot set property \(name) of \(rawValue.toString()) to \(FreObjectSwift(prop).value ?? "unknown")",
            stackTrace: getActionscriptException(thrownException),
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
    }

    static func getActionscriptException(_ thrownException: FREObject?) -> String {
        guard let thrownException = thrownException else {
            return ""
        }
        guard FreObjectTypeSwift.class == thrownException.type else {
            return ""
        }
        guard thrownException.hasOwnProperty(name: "getStackTrace"),
              let asStackTrace = thrownException.call(method: "getStackTrace"),
              FreObjectTypeSwift.string == asStackTrace.type,
              let ret = String(asStackTrace)
          else {
            return ""
        }
        return ret
    }

    public static func newObject(_ string: String) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObjectFromUTF8(length: UInt32(string.utf8.count),
          value: string, object: &ret)
#else
        let status = FRENewObjectFromUTF8(UInt32(string.utf8.count), string, &ret)
#endif
        
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create FREObject from \(string)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ double: Double) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObjectFromDouble(value: double, object: &ret)
#else
        let status = FRENewObjectFromDouble(double, &ret)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create FREObject from \(double)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ cgFloat: CGFloat) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObjectFromDouble(value: Double(cgFloat), object: &ret)
#else
        let status = FRENewObjectFromDouble(Double(cgFloat), &ret)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create FREObject from \(cgFloat)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ date: Date) -> FREObject? {
        var ret: FREObject?
        let secs: Double = Double(date.timeIntervalSince1970) * 1000.0
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        argsArray.addPointer(secs.toFREObject())
        ret = newObject(className: "Date", argsArray)
        return ret
    }

    public static func newObject(_ int: Int) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObjectFromInt32(value: Int32(int), object: &ret)
#else
        let status = FRENewObjectFromInt32(Int32(int), &ret)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create FREObject from \(int)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ uint: UInt) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObjectFromUint32(value: UInt32(uint), object: &ret)
#else
        let status = FRENewObjectFromUint32(UInt32(uint), &ret)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create FREObject from \(uint)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ bool: Bool) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObjectFromBool(value: bool, object: &ret)
#else
        let b: UInt32 = (bool == true) ? 1 : 0
        let status = FRENewObjectFromBool(b, &ret)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create FREObject from \(bool)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(className: String, _ args: NSPointerArray?) -> FREObject? {
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        if args != nil {
            numArgs = UInt32((args?.count)!)
        }
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObject(className: className, argc: numArgs, argv: args,
          object: &ret, thrownException: &thrownException)
#else
        let status = FRENewObject(className, numArgs, arrayToFREArray(args), &ret, &thrownException)
#endif
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create new class \(className)",
            stackTrace: getActionscriptException(thrownException),
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(className: String) -> FREObject? {
        var ret: FREObject?
        var thrownException: FREObject?
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRENewObject(className: className, argc: 0, argv: nil,
          object: &ret, thrownException: &thrownException)
#else
        let status = FRENewObject(className, 0, nil, &ret, &thrownException)
#endif
        
        if FRE_OK == status { return ret }
        logger.log(message: "cannot create new class \(className)",
            stackTrace: getActionscriptException(thrownException),
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    static func getErrorCode(_ result: FREResult) -> FreError.Code {
        switch result {
        case FRE_NO_SUCH_NAME:
            return .noSuchName
        case FRE_INVALID_OBJECT:
            return .invalidObject
        case FRE_TYPE_MISMATCH:
            return .typeMismatch
        case FRE_ACTIONSCRIPT_ERROR:
            return .actionscriptError
        case FRE_INVALID_ARGUMENT:
            return .invalidArgument
        case FRE_READ_ONLY:
            return .readOnly
        case FRE_WRONG_THREAD:
            return .wrongThread
        case FRE_ILLEGAL_STATE:
            return .illegalState
        case FRE_INSUFFICIENT_MEMORY:
            return .insufficientMemory
        default:
            return .ok
        }
    }

}
