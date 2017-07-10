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

public class FreSwiftHelper {
    static func getAsString(_ rawValue: FREObject) throws -> String {
        var ret: String = ""
        var len: UInt32 = 0
        var valuePtr: UnsafePointer<UInt8>?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsUTF8(object: rawValue, length: &len, value: &valuePtr)
        #else
            let status: FREResult = FREGetObjectAsUTF8(rawValue, &len, &valuePtr)
        #endif
        if FRE_OK == status {
            ret = (NSString(bytes: valuePtr!, length: Int(len), encoding: String.Encoding.utf8.rawValue) as String?)!
        } else {
            throw FreError(stackTrace: "", message: "cannot get FREObject as String", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    static func getAsBool(_ rawValue: FREObject) throws -> Bool {
        var ret: Bool = false
        var val: UInt32 = 0
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsBool(object: rawValue, value: &val)
        #else
            let status: FREResult = FREGetObjectAsBool(rawValue, &val)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get FREObject as Bool", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        ret = val == 1 ? true : false
        return ret
    }
    
    
    static func getAsDouble(_ rawValue: FREObject) throws -> Double {
        var ret: Double = 0.0
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsDouble(object: rawValue, value: &ret)
        #else
            let status: FREResult = FREGetObjectAsDouble(rawValue, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get FREObject as Double", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    static func getAsInt(_ rawValue: FREObject) throws -> Int {
        var ret: Int32 = 0
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsInt32(object: rawValue, value: &ret)
        #else
            let status: FREResult = FREGetObjectAsInt32(rawValue, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get FREObject as Int", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return Int(ret)
    }
    
    static func getAsUInt(_ rawValue: FREObject) throws -> UInt {
        var ret: UInt32 = 0
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetObjectAsUint32(object: rawValue, value: &ret)
        #else
            let status: FREResult = FREGetObjectAsUint32(rawValue, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get FREObject as UInt", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return UInt(ret)
    }
    
    
    static func getAsId(_ rawValue: FREObject) throws -> Any? {
        let objectType: FreObjectTypeSwift = getType(rawValue)
        
        //Swift.debugPrint("getAsId is of type ", objectType)
        switch objectType {
        case .int:
            return try getAsInt(rawValue)
        case .vector, .array:
            return FreArraySwift.init(freObject: rawValue).value
        case .string:
            return try getAsString(rawValue)
        case .boolean:
            return try getAsBool(rawValue)
        case .object, .cls:
            return try getAsDictionary(rawValue)
        case .number:
            return try getAsDouble(rawValue)
        case .bitmapdata: //TODO
            break
        //return try self.getAsImage()
        case .bytearray:
            let asByteArray = FreByteArraySwift.init(freByteArray: rawValue)
            let byteData = asByteArray.value
            asByteArray.releaseBytes() //don't forget to release
            return byteData
        case .null:
            return nil
        }
        return nil
    }
    
    public static func toPointerArray(args: Any...) throws -> NSPointerArray {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FreObjectSwift = try FreObjectSwift.init(any: args[i])
            argsArray.addPointer(arg.rawValue)
        }
        return argsArray
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
    
    public static func getType(_ rawValue: FREObject) -> FreObjectTypeSwift {
        var objectType: FREObjectType = FRE_TYPE_NULL
        #if os(iOS)
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
        
        //Swift.debugPrint("GET ACTIONSCRIPT TYPE----------------")
        if let aneUtils: FreObjectSwift = try? FreObjectSwift.init(className: "com.tuarua.fre.ANEUtils") {
            let param: FreObjectSwift = FreObjectSwift.init(freObject: rawValue)
            if let classType: FreObjectSwift = try! aneUtils.callMethod(name: "getClassType", args: param) {
                let type: String? = try! FreSwiftHelper.getAsString(classType.rawValue!).lowercased()
                
                if type == "int" {
                    return FreObjectTypeSwift.int
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
        return FreObjectTypeSwift.null
    }
    
    static func getAsDictionary(_ rawValue: FREObject) throws -> Dictionary<String, AnyObject> {
        //Swift.debugPrint("GET AS DICTIONARY **************************")
        
        var ret: Dictionary = Dictionary<String, AnyObject>()
        guard let aneUtils: FreObjectSwift = try? FreObjectSwift.init(className: "com.tuarua.fre.ANEUtils") else {
            return ret
        }
        
        let param: FreObjectSwift = FreObjectSwift.init(freObject: rawValue)
        guard let classProps1: FreObjectSwift = try aneUtils.callMethod(name: "getClassProps", args: param),
            let rValue = classProps1.rawValue
            else {
                return Dictionary<String, AnyObject>()
        }
        
        let array: FreArraySwift = FreArraySwift.init(freObject: rValue)
        let arrayLength = array.length
        for i in 0..<arrayLength {
            if let elem: FreObjectSwift = try array.getObjectAt(index: i) {
                if let propNameAs = try elem.getProperty(name: "name") {
                    let propName: String = propNameAs.value as! String
                    if let propval = try param.getProperty(name: propNameAs.value as! String) {
                        if let propvalId = propval.value {
                            ret.updateValue(propvalId as AnyObject, forKey: propName)
                        }
                    }
                }
                
                
            }
        }
        
        return ret
    }
    
    static func getProperty(rawValue: FREObject, name: String) throws -> FREObject? {
        var ret: FREObject?
        var thrownException: FREObject?
        
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetObjectProperty(object: rawValue,
                                                                               propertyName: name,
                                                                               propertyValue: &ret,
                                                                               thrownException: &thrownException)
        #else
            let status: FREResult = FREGetObjectProperty(rawValue, name, &ret, &thrownException)
        #endif
        
        guard FRE_OK == status else {
            throw FreError(stackTrace: getActionscriptException(thrownException),
                           message: "cannot get property \"\(name)\"", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    
    static func setProperty(rawValue: FREObject, name: String, prop: FREObject?) throws {
        var thrownException: FREObject?
        #if os(iOS)
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
        let thrownExceptionSwift: FreObjectSwift = FreObjectSwift.init(freObject: thrownException)
        
        guard FreObjectTypeSwift.cls == thrownExceptionSwift.getType() else {
            return ""
        }
        do {
            guard let rv = try thrownExceptionSwift.callMethod(name: "hasOwnProperty", args: "getStackTrace")?.rawValue,
                let hasStackTrace = try? getAsBool(rv),
                hasStackTrace,
                let asStackTrace = try thrownExceptionSwift.callMethod(name: "getStackTrace"),
                FreObjectTypeSwift.string == asStackTrace.getType(),
                let ret: String = asStackTrace.value as? String
                else {
                    return ""
            }
            return ret
        } catch {
        }
        
        return ""
    }
    
    static func newObject(_ string: String) throws -> FREObject? {
        var ret: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromUTF8(length: UInt32(string.utf8.count),
                                                                               value: string, object: &ret)
        #else
            let status: FREResult = FRENewObjectFromUTF8(UInt32(string.utf8.count), string, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot create new  object ", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    
    static func newObject(_ double: Double) throws -> FREObject? {
        var ret: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromDouble(value: double, object: &ret)
        #else
            let status: FREResult = FRENewObjectFromDouble(double, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot create new  object ", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    static func newObject(_ int: Int) throws -> FREObject? {
        var ret: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromInt32(value: Int32(int), object: &ret)
        #else
            let status: FREResult = FRENewObjectFromInt32(Int32(int), &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot create new  object ", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    static func newObject(_ uint: UInt) throws -> FREObject? {
        var ret: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromUint32(value: UInt32(uint), object: &ret)
        #else
            let status: FREResult = FRENewObjectFromUint32(UInt32(uint), &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot create new  object ", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    static func newObject(_ bool: Bool) throws -> FREObject? {
        var ret: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRENewObjectFromBool(value: bool, object: &ret)
        #else
            let b: UInt32 = (bool == true) ? 1 : 0
            let status: FREResult = FRENewObjectFromBool(b, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot create new  object ", type: getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    static func newObject(_ className: String, _ args: NSPointerArray?) throws -> FREObject? {
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        if args != nil {
            numArgs = UInt32((args?.count)!)
        }
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRENewObject(className: className, argc: numArgs, argv: args,
                                                                       object: &ret, thrownException: &thrownException)
        #else
            let status: FREResult = FRENewObject(className, numArgs, arrayToFREArray(args), &ret, &thrownException)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: getActionscriptException(thrownException),
                           message: "cannot create new  object \(className)", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
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
    
    #if os(iOS)
    
    public static func toUIColor(freObject: FREObject, alpha: FREObject) throws -> UIColor {
    let rgb = try FreSwiftHelper.getAsUInt(freObject);
    let r = (rgb >> 16) & 0xFF
    let g = (rgb >> 8) & 0xFF
    let b = rgb & 0xFF
    var a: CGFloat = CGFloat.init(1)
    let aFre = FreObjectSwift.init(freObject: alpha)
    if let alphaInt = aFre.value as? Int, alphaInt == 0 {
    return UIColor.clear
    }
    if let alphaD = aFre.value as? Double {
    a = CGFloat.init(alphaD)
    }
    let rFl: CGFloat = CGFloat.init(r) / 255
    let gFl: CGFloat = CGFloat.init(g) / 255
    let bFl: CGFloat = CGFloat.init(b) / 255
    return UIColor.init(red: rFl, green: gFl, blue: bFl, alpha: a)
    }
    
    #else
    
    public static func toCGColor(freObject: FREObject, alpha: FREObject) throws -> CGColor {
        let rgb = try FreSwiftHelper.getAsUInt(freObject);
        let r = (rgb >> 16) & 0xFF
        let g = (rgb >> 8) & 0xFF
        let b = rgb & 0xFF
        var a: CGFloat = CGFloat.init(1)
        let aFre = FreObjectSwift.init(freObject: alpha)
        if let alphaInt = aFre.value as? Int, alphaInt == 0 {
            return CGColor.clear
        }
        if let alphaD = aFre.value as? Double {
            a = CGFloat.init(alphaD)
        }
        let rFl: CGFloat = CGFloat.init(r) / 255
        let gFl: CGFloat = CGFloat.init(g) / 255
        let bFl: CGFloat = CGFloat.init(b) / 255
        return CGColor.init(red: rFl, green: gFl, blue: bFl, alpha: a)
    }
    
    #endif
    
}


open class FreContextSwift: NSObject {
    public var rawValue: FREContext? = nil
    
    public init(freContext: FREContext) {
        rawValue = freContext
    }
    
    public func dispatchStatusEventAsync(code: String, level: String) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREDispatchStatusEventAsync(ctx: rv, code: code, level: level)
        #else
            let status: FREResult = FREDispatchStatusEventAsync(rv, code, level)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot dispatch event \(code):\(level)",
                type: FreSwiftHelper.getErrorCode(status), line: #line, column: #column, file: #file)
        }
    }
    
    public func getActionScriptData() throws -> FREObject? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        var ret: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetContextActionScriptData(ctx: rv, actionScriptData: &ret)
        #else
            let status: FREResult = FREGetContextActionScriptData(rv, &ret)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get actionscript data", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        return ret
    }
    
    
    public func setActionScriptData(object: FREObject) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRESetContextActionScriptData(ctx: rv, actionScriptData: object)
        #else
            let status: FREResult = FRESetContextActionScriptData(rv, object)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot set actionscript data", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        
    }
    
}

public struct FreError: Error {
    
    public enum Code {
        case ok
        case noSuchName
        case invalidObject
        case typeMismatch
        case actionscriptError
        case invalidArgument
        case readOnly
        case wrongThread
        case illegalState
        case insufficientMemory
    }
    
    public func getError(_ oFile: String, _ oLine: Int, _ oColumn: Int) -> FREObject? {
        do {
            let _aneError = try FreObjectSwift.init(className: "com.tuarua.fre.ANEError",
                                                    args: message,
                                                    0,
                                                    String(describing: type),
                                                    "[\(oFile):\(oLine):\(oColumn)]",
                stackTrace)
            return _aneError.rawValue
            
        } catch {
        }
        
        return nil
    }
    
    public let stackTrace: String
    public let message: String
    public let type: Code
    public let line: Int
    public let column: Int
    public let file: String
}

public enum FreObjectTypeSwift: UInt32 {
    case object = 0
    case number = 1
    case string = 2
    case bytearray = 3
    case array = 4
    case vector = 5
    case bitmapdata = 6
    case boolean = 7
    case null = 8
    case int = 9
    case cls = 10 //aka class
}

open class FreObjectSwift: NSObject {
    public var rawValue: FREObject? = nil
    public var value: Any? {
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
    
    public init(string: String) throws {
        rawValue = try FreSwiftHelper.newObject(string)
    }
    
    public init(double: Double) throws {
        rawValue = try FreSwiftHelper.newObject(double)
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
    
    public init(any: Any) throws {
        super.init()
        rawValue = try _newObject(any: any)
    }
    
    public init(className: String, args: Any...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        rawValue = try FreSwiftHelper.newObject(className, argsArray)
    }
    
    public func callMethod(name: String, args: Any...) throws -> FreObjectSwift? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        
        var ret: FREObject?
        var thrownException: FREObject?
        var numArgs: UInt32 = 0
        numArgs = UInt32((argsArray.count))
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRECallObjectMethod(object: rv, methodName: name,
                                                                              argc: numArgs, argv: argsArray,
                                                                              result: &ret, thrownException: &thrownException)
            
        #else
            let status: FREResult = FRECallObjectMethod(rv, name, numArgs, FreSwiftHelper.arrayToFREArray(argsArray), &ret, &thrownException)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: FreSwiftHelper.getActionscriptException(thrownException),
                           message: "cannot call method \"\(name)\"", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        
        if let ret = ret {
            return FreObjectSwift(freObject: ret)
        }
        return nil
    }
    
    
    public func getProperty(name: String) throws -> FreObjectSwift? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        if let ret = try FreSwiftHelper.getProperty(rawValue: rv, name: name) {
            return FreObjectSwift.init(freObject: ret)
        }
        return nil
    }
    
    public func setProperty(name: String, prop: FreObjectSwift?) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        
        if let p = prop {
            try FreSwiftHelper.setProperty(rawValue: rv, name: name, prop: p.rawValue)
        } else {
            try FreSwiftHelper.setProperty(rawValue: rv, name: name, prop: nil)
        }
    }
    
    public func setProperty(name: String, array: FreArraySwift?) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        if let p = array {
            try FreSwiftHelper.setProperty(rawValue: rv, name: name, prop: p.rawValue)
        } else {
            try FreSwiftHelper.setProperty(rawValue: rv, name: name, prop: nil)
        }
    }
    
    public func getType() -> FreObjectTypeSwift {
        guard let rv = rawValue else {
            return FreObjectTypeSwift.null
        }
        return FreSwiftHelper.getType(rv)
    }
    
    fileprivate func _newObject(any: Any) throws -> FREObject? {
        if any is FREObject {
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
        } else if any is Bool {
            return try FreSwiftHelper.newObject(any as! Bool)
        } //TODO add Dict and others
        
        Swift.debugPrint("_newObject NO MATCH")
        
        return nil
        
    }
    
}


public class FreArraySwift: NSObject {
    public var rawValue: FREObject? = nil
    
    public init(freObject: FREObject) {
        rawValue = freObject
    }
    
    public init(className: String, args: Any...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        rawValue = try FreSwiftHelper.newObject(className, argsArray)
    }
    
    public func getObjectAt(index: UInt) throws -> FreObjectSwift? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        var object: FREObject?
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                              value: &object)
        #else
            let status: FREResult = FREGetArrayElementAt(rv, UInt32(index), &object)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get object at \(index) ", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        if let object = object {
            return FreObjectSwift.init(freObject: object)
        }
        
        return nil
    }
    
    public func setObjectAt(index: UInt, object: FreObjectSwift) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                              value: object.rawValue)
        #else
            let status: FREResult = FRESetArrayElementAt(rv, UInt32(index), object.rawValue)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot set object at \(index) ", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
    }
    
    public var length: UInt {
        get {
            guard let rv = rawValue else {
                return 0
            }
            do {
                var ret: UInt32 = 0
                #if os(iOS)
                    let status: FREResult = FreSwiftBridge.bridge.FREGetArrayLength(arrayOrVector: rv, length: &ret)
                #else
                    let status: FREResult = FREGetArrayLength(rv, &ret)
                #endif
                guard FRE_OK == status else {
                    throw FreError(stackTrace: "", message: "cannot get length of array", type: FreSwiftHelper.getErrorCode(status),
                                   line: #line, column: #column, file: #file)
                }
                return UInt(ret)
                
            } catch {
            }
            return 0
        }
    }
    
    public var value: Array<Any?> {
        get {
            var ret: [Any?] = []
            do {
                for i in 0..<length {
                    if let elem: FreObjectSwift = try getObjectAt(index: i) {
                        ret.append(elem.value)
                    }
                }
            } catch {
            }
            return ret
        }
    }
    
}

public class FreByteArraySwift: NSObject {
    public var rawValue: FREObject? = nil
    public var bytes: UnsafeMutablePointer<UInt8>!
    public var length: UInt = 0
    private var _byteArray: FREByteArray = FREByteArray.init()
    
    public init(freByteArray: FREObject) {
        rawValue = freByteArray
    }
    
    public init(data: NSData) {
        super.init()
        
        /*
         //fancy way
         let rrrr = data.bytes.assumingMemoryBound(to: UInt8.self)
         let ptr = UnsafeMutablePointer<UInt8>.init(mutating: rrrr)
         _byteArray = FREByteArray.init(length: UInt32(data.length), bytes: ptr)
         Swift.debugPrint(_byteArray)
         */
        
        defer {
            if let rv = rawValue {
                #if os(iOS)
                    _ = FreSwiftBridge.bridge.FREReleaseByteArray(object: rv)
                #else
                    FREReleaseByteArray(rv)
                #endif
            }
        }
        
        do {
            
            //https://forums.adobe.com/thread/1037977
            
            let targetBA = try FreObjectSwift.init(className: "flash.utils.ByteArray")
            try targetBA.setProperty(name: "length", prop: FreObjectSwift.init(int: data.length))
            rawValue = targetBA.rawValue
            
            if let rv = rawValue {
                #if os(iOS)
                    let status: FREResult = FreSwiftBridge.bridge.FREAcquireByteArray(object: rv, byteArrayToSet: &_byteArray)
                #else
                    let status: FREResult = FREAcquireByteArray(rv, &_byteArray)
                #endif
                
                
                guard FRE_OK == status else {
                    throw FreError(stackTrace: "", message: "cannot acquire ByteArray", type: FreSwiftHelper.getErrorCode(status),
                                   line: #line, column: #column, file: #file)
                }
                
                memcpy(_byteArray.bytes, data.bytes, data.length);
                length = UInt(_byteArray.length)
                bytes = _byteArray.bytes
            }
        } catch let e as FreError {
            Swift.debugPrint(e.message)
            Swift.debugPrint(e.stackTrace)
            Swift.debugPrint(e.type)
        } catch {
        }
    }
    
    public func acquire() throws {
        guard let rv = rawValue else {
            Swift.debugPrint("acquire rawValue is nil")
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREAcquireByteArray(object: rv, byteArrayToSet: &_byteArray)
        #else
            let status: FREResult = FREAcquireByteArray(rv, &_byteArray)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot acquire ByteArray", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        length = UInt(_byteArray.length)
        bytes = _byteArray.bytes
    }
    
    public func releaseBytes() { //can't override release
        guard let rv = rawValue else {
            return
        }
        #if os(iOS)
            _ = FreSwiftBridge.bridge.FREReleaseByteArray(object: rv)
        #else
            FREReleaseByteArray(rv)
        #endif
    }
    
    func getAsData() throws -> NSData {
        try self.acquire()
        return NSData.init(bytes: bytes, length: Int(length))
    }
    
    public var value: NSData? {
        get {
            do {
                try self.acquire()
                guard let b = bytes else {
                    return nil
                }
                return NSData.init(bytes: b, length: Int(length))
            } catch {
            }
            
            defer {
                releaseBytes()
            }
            return nil
        }
    }
    
}

public class FreBitmapDataSwift: NSObject {
    private typealias FREBitmapData = FREBitmapData2
    
    public var rawValue: FREObject? = nil
    private var _bitmapData: FREBitmapData = FREBitmapData.init()
    public var width: Int = 0
    public var height: Int = 0
    public var hasAlpha: Bool = false
    public var isPremultiplied: Bool = false
    public var isInvertedY: Bool = false
    public var lineStride32: UInt = 0
    public var bits32: UnsafeMutablePointer<UInt32>!
    
    public init(freObject: FREObject) {
        rawValue = freObject
    }
    
    public init(cgImage: CGImage) {
        //TODO
        /*
         case none /* For example, RGB. */
         case premultipliedLast /* For example, premultiplied RGBA */
         case premultipliedFirst /* For example, premultiplied ARGB */
         case last /* For example, non-premultiplied RGBA */
         case first /* For example, non-premultiplied ARGB */
         case noneSkipLast /* For example, RBGX. */
         case noneSkipFirst /* For example, XRGB. */
         case alphaOnly /* No color data, alpha data only */
         */
        
        
        
        /*
         typedef struct {
         uint32_t  width;           /* width of the BitmapData bitmap */
         uint32_t  height;          /* height of the BitmapData bitmap */
         uint32_t  hasAlpha;        /* if non-zero, pixel format is ARGB32, otherwise pixel format is _RGB32, host endianness */
         uint32_t  isPremultiplied; /* pixel color values are premultiplied with alpha if non-zero, un-multiplied if zero */
         uint32_t  lineStride32;    /* line stride in number of 32 bit values, typically the same as width */
         uint32_t* bits32;          /* pointer to the first 32-bit pixel of the bitmap data */
         } FREBitmapData;
         */
        
        //cgImage.alphaInfo.rawValue
        //_bitmapData = FREBitmapData.init(width: cgImage.width, height: cgImage.height, hasAlpha: <#T##UInt32#>, isPremultiplied: <#T##UInt32#>, lineStride32: <#T##UInt32#>, isInvertedY: <#T##UInt32#>, bits32: nil)
    }
    
    public func acquire() throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREAcquireBitmapData2(object: rv, descriptorToSet: &_bitmapData)
        #else
            let status: FREResult = FREAcquireBitmapData2(rv, &_bitmapData)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot acquire BitmapData", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        width = Int(_bitmapData.width)
        height = Int(_bitmapData.height)
        hasAlpha = _bitmapData.hasAlpha == 1
        isPremultiplied = _bitmapData.isPremultiplied == 1
        isInvertedY = _bitmapData.isInvertedY == 1
        lineStride32 = UInt(_bitmapData.lineStride32)
        bits32 = _bitmapData.bits32
    }
    
    public func releaseData() {
        guard let rv = rawValue else {
            return
        }
        #if os(iOS)
            _ = FreSwiftBridge.bridge.FREReleaseBitmapData(object: rv)
        #else
            FREReleaseBitmapData(rv)
        #endif
    }
    
    public func setPixels(cgImage: CGImage) throws {
        if let dp = cgImage.dataProvider {
            if let data: NSData = dp.data {
                memcpy(bits32, data.bytes, data.length);
            }
            try invalidateRect(x: 0, y: 0, width: UInt(cgImage.width), height: UInt(cgImage.height))
        }
    }
    
    public func getAsImage() throws -> CGImage? {
        try self.acquire()
        
        let releaseProvider: CGDataProviderReleaseDataCallback = { (info: UnsafeMutableRawPointer?,
            data: UnsafeRawPointer, size: Int) -> () in
            // https://developer.apple.com/reference/coregraphics/cgdataproviderreleasedatacallback
            // N.B. 'CGDataProviderRelease' is unavailable: Core Foundation objects are automatically memory managed
            return
        }
        let provider: CGDataProvider = CGDataProvider(dataInfo: nil, data: bits32, size: (width * height * 4),
                                                      releaseData: releaseProvider)!
        
        
        let bytesPerPixel = 4;
        let bitsPerPixel = 32;
        let bytesPerRow: Int = bytesPerPixel * Int(lineStride32);
        let bitsPerComponent = 8;
        let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: CGBitmapInfo
        
        if hasAlpha {
            if isPremultiplied {
                bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                    CGImageAlphaInfo.premultipliedFirst.rawValue)
            } else {
                bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                    CGImageAlphaInfo.first.rawValue)
            }
        } else {
            bitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Little.rawValue |
                CGImageAlphaInfo.noneSkipFirst.rawValue)
        }
        
        let renderingIntent: CGColorRenderingIntent = CGColorRenderingIntent.defaultIntent;
        let imageRef: CGImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent,
                                        bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpaceRef,
                                        bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false,
                                        intent: renderingIntent)!;
        
        return imageRef
        
    }
    
    
    public func invalidateRect(x: UInt, y: UInt, width: UInt, height: UInt) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        #if os(iOS)
            let status: FREResult = FreSwiftBridge.bridge.FREInvalidateBitmapDataRect(object: rv, x: UInt32(x),
                                                                                      y: UInt32(y), width: UInt32(width), height: UInt32(height))
        #else
            let status: FREResult = FREInvalidateBitmapDataRect(rv, UInt32(x), UInt32(y), UInt32(width), UInt32(height))
        #endif
        
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot invalidateRect", type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
    }
    
}

public func freTrace(ctx:FreContextSwift, value: [Any]) {
    var traceStr: String = ""
    for i in value {
        traceStr = traceStr + "\(i)" + " "
    }
    do {
        try ctx.dispatchStatusEventAsync(code: traceStr, level: "TRACE")
    } catch {
    }
}

public func traceError(ctx:FreContextSwift, message: String, line: Int, column: Int, file: String, freError: FreError?) {
    freTrace(ctx: ctx, value: ["ERROR:", "message:", message, "file:", "[\(file):\(line):\(column)]"])
    if let freError = freError {
        freTrace(ctx: ctx, value: [freError.type])
        freTrace(ctx: ctx, value: [freError.stackTrace])
    }
}

public typealias FREArgv = UnsafeMutablePointer<FREObject?>!
public typealias FREArgc = UInt32
public typealias FREFunctionMap = [String: (_: FREContext, _: FREArgc, _: FREArgv) -> FREObject?]
public var functionsToSet: FREFunctionMap = [:]
public typealias FreSwiftController = NSObject

public extension FreSwiftController {
    func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
}
