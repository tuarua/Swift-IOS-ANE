/* Copyright 2018 Tua Rua Ltd.
 
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

    static func callMethod(_ rawValue: FREObject?, name: String, args: [Any]) throws -> FREObject? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(FreObjectSwift(args[i]).rawValue)
        }
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        numArgs = UInt32((argsArray.count))
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRECallObjectMethod(object: rv, methodName: name,
          argc: numArgs, argv: argsArray,
          result: &ret, thrownException: &thrownException)

#else
        let status: FREResult = FRECallObjectMethod(rv,
                                                    name,
                                                    numArgs,
                                                    FreSwiftHelper.arrayToFREArray(argsArray),
                                                    &ret, &thrownException)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: FreSwiftHelper.getActionscriptException(thrownException),
              message: "cannot call method \"\(name)\"", type: FreSwiftHelper.getErrorCode(status),
              line: #line, column: #column, file: #file)
        }

        return ret
    }

    static func getAsString(_ rawValue: FREObject) -> String? {
        var len: UInt32 = 0
        var valuePtr: UnsafePointer<UInt8>?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsUTF8(object: rawValue,
                                                                         length: &len, value: &valuePtr)
#else
        let status: FREResult = FREGetObjectAsUTF8(rawValue, &len, &valuePtr)
#endif
        if FRE_OK == status {
            return NSString(bytes: valuePtr!, length: Int(len), encoding: String.Encoding.utf8.rawValue) as String?
        }
        
        FreSwiftLogger.shared().log(message: "cannot get FREObject as String",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsBool(_ rawValue: FREObject) -> Bool? {
        var val: UInt32 = 0
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsBool(object: rawValue, value: &val)
#else
        let status: FREResult = FREGetObjectAsBool(rawValue, &val)
#endif
        
        if FRE_OK == status  { return val == 1 }
        FreSwiftLogger.shared().log(message: "cannot get FREObject as Bool",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsDouble(_ rawValue: FREObject) -> Double? {
        var ret: Double = 0.0
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsDouble(object: rawValue, value: &ret)
#else
        let status: FREResult = FREGetObjectAsDouble(rawValue, &ret)
#endif
        if FRE_OK == status  { return ret }
        FreSwiftLogger.shared().log(message: "cannot get FREObject as Double",
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
        let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsInt32(object: rawValue, value: &ret)
#else
        let status: FREResult = FREGetObjectAsInt32(rawValue, &ret)
#endif
        
        if FRE_OK == status { return Int(ret) }
        FreSwiftLogger.shared().log(message: "cannot get FREObject as Int",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsUInt(_ rawValue: FREObject) -> UInt? {
        var ret: UInt32 = 0
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsUint32(object: rawValue, value: &ret)
#else
        let status: FREResult = FREGetObjectAsUint32(rawValue, &ret)
#endif
        if FRE_OK == status { return UInt(ret) }
        FreSwiftLogger.shared().log(message: "cannot get FREObject as UInt",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    static func getAsId(_ rawValue: FREObject) throws -> Any? {
        let objectType: FreObjectTypeSwift = getType(rawValue)
        switch objectType {
        case .int:
            return getAsInt(rawValue)
        case .vector, .array:
            return FREArray(rawValue).value
        case .string:
            return getAsString(rawValue)
        case .boolean:
            return getAsBool(rawValue)
        case .object, .cls:
            return try getAsDictionary(rawValue) as [String: AnyObject]?
        case .number:
            return getAsDouble(rawValue)
        case .bitmapdata:
            return try FreBitmapDataSwift(freObject: rawValue).asCGImage()
        case .bytearray:
            let asByteArray = FreByteArraySwift(freByteArray: rawValue)
            let byteData = asByteArray.value
            asByteArray.releaseBytes()
            return byteData
        case .point:
            return CGPoint(rawValue)
        case .rectangle:
            return CGRect(rawValue)
        case .date:
            return getAsDate(rawValue)
        case .null:
            return nil
        }
    }

#if os(OSX)
    public static func toCGColor(freObject: FREObject, alpha: FREObject) throws -> CGColor {
        // TODO
        if let rgb = FreSwiftHelper.getAsUInt(freObject) {
            let r = (rgb >> 16) & 0xFF
            let g = (rgb >> 8) & 0xFF
            let b = rgb & 0xFF
            var a: CGFloat = CGFloat(1)
            let aFre = FreObjectSwift(alpha)
            if let alphaInt = aFre.value as? Int, alphaInt == 0 {
                return CGColor.clear
            }
            if let alphaD = aFre.value as? Double {
                a = CGFloat(alphaD)
            }
            let rFl: CGFloat = CGFloat(r) / 255
            let gFl: CGFloat = CGFloat(g) / 255
            let bFl: CGFloat = CGFloat(b) / 255
            return CGColor(red: rFl, green: gFl, blue: bFl, alpha: a)
        }
        return CGColor.black
    }
#endif

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

    public static func getType(_ rawValue: FREObject) -> FreObjectTypeSwift {
        var objectType: FREObjectType = FRE_TYPE_NULL
#if os(iOS) || os(tvOS)
        _ = FreSwiftBridge.bridge.FREGetObjectType(object: rawValue, objectType: &objectType)
#else
        FREGetObjectType(rawValue, &objectType)
#endif
        let type: FreObjectTypeSwift = FreObjectTypeSwift(rawValue: objectType.rawValue)!

        return FreObjectTypeSwift.number == type || FreObjectTypeSwift.object == type
          ? getActionscriptType(rawValue)
          : type
    }

    fileprivate static func getActionscriptType(_ rawValue: FREObject) -> FreObjectTypeSwift {
        do {
            if let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils") {
                if let classType = try aneUtils.call(method: "getClassType", args: rawValue) {
                    if let type = FreSwiftHelper.getAsString(classType)?.lowercased() {
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
                        } else {
                            return FreObjectTypeSwift.cls
                        }
                    }
                }
            }
        } catch {
            return FreObjectTypeSwift.null
        }
        return FreObjectTypeSwift.null
    }

    static func getAsDictionary(_ rawValue: FREObject) throws -> [String: AnyObject]? {
        var ret = [String: AnyObject]()
        guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
              let classProps = try aneUtils.call(method: "getClassProps", args: rawValue) else {
            return nil
        }
        let array: FREArray = FREArray(classProps)
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
    
    static func getAsDictionary(_ rawValue: FREObject) throws -> [String: Any]? {
        var ret = [String: Any]()
        guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classProps = try aneUtils.call(method: "getClassProps", args: rawValue) else {
                return nil
        }
        let array: FREArray = FREArray(classProps)
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
    
    static func getAsDictionary(_ rawValue: FREObject) throws -> [String: NSObject]? {
        var ret = [String: NSObject]()
        guard let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classProps = try aneUtils.call(method: "getClassProps", args: rawValue) else {
                return nil
        }
        let array: FREArray = FREArray(classProps)
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
        let array: FREArray = FREArray(rawValue)
        for fre in array {
            if let v = String(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Int]? {
        var ret = [Int]()
        let array: FREArray = FREArray(rawValue)
        for fre in array {
            if let v = Int(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [UInt]? {
        var ret = [UInt]()
        let array: FREArray = FREArray(rawValue)
        for fre in array {
            if let v = UInt(fre) {
                ret.append(v)
            }
        }
        return ret
    }

    static func getAsArray(_ rawValue: FREObject) -> [Bool]? {
        var ret = [Bool]()
        let array: FREArray = FREArray(rawValue)
        for fre in array {
            if let v = Bool(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Double]? {
        var ret = [Double]()
        let array: FREArray = FREArray(rawValue)
        for fre in array {
            if let v = Double(fre) {
                ret.append(v)
            }
        }
        return ret
    }
    
    static func getAsArray(_ rawValue: FREObject) -> [Any]? {
        var ret: [Any] = [Any]()
        let array: FREArray = FREArray(rawValue)
        
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
        let status: FREResult = FreSwiftBridge.bridge.FREGetObjectProperty(object: rawValue,
          propertyName: name,
          propertyValue: &ret,
          thrownException: &thrownException)
#else
        let status: FREResult = FREGetObjectProperty(rawValue, name, &ret, &thrownException)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(stackTrace: getActionscriptException(thrownException),
                                    message: "cannot get property \"\(name)\"",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    public static func setProperty(rawValue: FREObject, name: String, prop: FREObject?) throws {
        var thrownException: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRESetObjectProperty(object: rawValue,
          propertyName: name,
          propertyValue: prop,
          thrownException: &thrownException)
#else
        let status: FREResult = FRESetObjectProperty(rawValue, name, prop, &thrownException)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: getActionscriptException(thrownException),
              message: "cannot set property \"\(name)\"", type: getErrorCode(status),
              line: #line, column: #column, file: #file)
        }
    }

    static func getActionscriptException(_ thrownException: FREObject?) -> String {
        guard let thrownException = thrownException else {
            return ""
        }
        guard FreObjectTypeSwift.cls == thrownException.type else {
            return ""
        }
        do {
            guard thrownException.hasOwnProperty(name: "getStackTrace"),
                  let asStackTrace = try thrownException.call(method: "getStackTrace"),
                  FreObjectTypeSwift.string == asStackTrace.type,
                  let ret = String(asStackTrace)
              else {
                return ""
            }
            return ret
        } catch {
        }
        return ""
    }

    public static func newObject(_ string: String) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromUTF8(length: UInt32(string.utf8.count),
          value: string, object: &ret)
#else
        let status: FREResult = FRENewObjectFromUTF8(UInt32(string.utf8.count), string, &ret)
#endif
        
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot create FREObject from \(string)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ double: Double) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromDouble(value: double, object: &ret)
#else
        let status: FREResult = FRENewObjectFromDouble(double, &ret)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot create FREObject from \(double)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ cgFloat: CGFloat) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromDouble(value: Double(cgFloat), object: &ret)
#else
        let status: FREResult = FRENewObjectFromDouble(Double(cgFloat), &ret)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot create FREObject from \(cgFloat)",
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
        let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromInt32(value: Int32(int), object: &ret)
#else
        let status: FREResult = FRENewObjectFromInt32(Int32(int), &ret)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot create FREObject from \(int)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ uint: UInt) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromUint32(value: UInt32(uint), object: &ret)
#else
        let status: FREResult = FRENewObjectFromUint32(UInt32(uint), &ret)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot create FREObject from \(uint)",
            type: getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(_ bool: Bool) -> FREObject? {
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromBool(value: bool, object: &ret)
#else
        let b: UInt32 = (bool == true) ? 1 : 0
        let status: FREResult = FRENewObjectFromBool(b, &ret)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot create FREObject from \(bool)",
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
        let status: FREResult = FreSwiftBridge.bridge.FRENewObject(className: className, argc: numArgs, argv: args,
          object: &ret, thrownException: &thrownException)
#else
        let status: FREResult = FRENewObject(className, numArgs, arrayToFREArray(args), &ret, &thrownException)
#endif
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(stackTrace: getActionscriptException(thrownException),
                                    message: "cannot create new  object \(className)",
                                    type: getErrorCode(status),
                                    line: #line, column: #column, file: #file)
        return nil
    }

    public static func newObject(className: String) -> FREObject? {
        var ret: FREObject?
        var thrownException: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRENewObject(className: className, argc: 0, argv: nil,
          object: &ret, thrownException: &thrownException)
#else
        let status: FREResult = FRENewObject(className, 0, nil, &ret, &thrownException)
#endif
        
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(stackTrace: getActionscriptException(thrownException),
                                    message: "cannot create new  object \(className)",
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
