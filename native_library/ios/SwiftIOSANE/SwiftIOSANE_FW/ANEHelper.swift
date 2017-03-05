//
//  ANEHelper.swift
//  SwiftIOSANE
//
//  Created by Eoin Landy on 04/03/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Foundation

class ANEHelper {
    private var dllContext: FREContext!

    enum FREObjectType2: UInt32 {
        case FRE_TYPE_INT = 0
        case FRE_TYPE_NUMBER = 1
        case FRE_TYPE_NULL = 2
        case FRE_TYPE_BOOLEAN = 3
        case FRE_TYPE_STRING = 4
        case FRE_TYPE_CUSTOM = 5
    }

    func setFREContext(ctx: FREContext) {
        dllContext = ctx
    }

    func trace(_ value: Any...) {
        var traceStr: String = ""
        for i in 0 ..< value.count {
            traceStr = traceStr + "\(value[i])" + " "
        }
        _ = FREDispatchStatusEventAsync(ctx: self.dllContext, code: traceStr, level: "TRACE")
    }


    func getString(object: FREObject) -> String {
        var ret: String = ""
        var len: UInt32 = 0
        let status: FREResult = FREGetObjectAsUTF8(object: object, length: &len, value: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert FREGetObject to String.") {
            return ret
        }
        return ""
    }

    func getInt(object: FREObject) -> Int {
        var ret: Int32 = 0
        let status: FREResult = FREGetObjectAsInt32(object: object, value: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert FREGetObject to Int.") {
            return Int(ret)
        }
        return 0
    }

    func getUInt(object: FREObject) -> UInt {
        var ret: UInt32 = 0
        let status: FREResult = FREGetObjectAsUint32(object: object, value: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert FREGetObject to Uint.") {
            return UInt(ret)
        }
        return 0
    }

    func getDouble(object: FREObject) -> Double {
        var ret: Double = 0.0
        let status: FREResult = FREGetObjectAsDouble(object: object, value: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert FREGetObject to Double.") {
            return ret
        }
        return 0.0
    }

    func getBool(object: FREObject) -> Bool {
        var ret: Bool = false
        let status: FREResult = FREGetObjectAsBool(object: object, value: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert FREGetObject to Bool.") {
            return ret
        }
        return false
    }

    func getArrayLength(arrayOrVector: FREObject) -> UInt32 {
        var ret: UInt32 = 0
        let status: FREResult = FREGetArrayLength(arrayOrVector: arrayOrVector, length: &ret)

        if isFREResultOK(errorCode: status, errorMessage: "Could not get Array Length.") {
            return ret
        }
        return 0
    }

    func getArray(arrayOrVector: FREObject) -> Array<Any?>? {
        var ret: [Any?] = []
        let arrayLength: UInt32 = getArrayLength(arrayOrVector: arrayOrVector)
        for i in 0 ..< arrayLength {
            var elem: FREObject? = nil
            let status: FREResult = FREGetArrayElementAt(arrayOrVector: arrayOrVector, index: i, value: &elem)
            if FRE_OK == status && elem != nil {
                let obj = self.getIdObject(object: elem!)
                ret.append(obj)
            }
        }
        return ret
    }


    func getDictionary(object: FREObject) -> Dictionary<String, AnyObject> {
        var ret: Dictionary = Dictionary<String, AnyObject>()
        let aneUtils: FREObject = createFREObject(className: "com.tuarua.ANEUtils")!
        if FRE_TYPE_NULL != getObjectType(object: aneUtils) {
            var classProps: FREObject? = nil
            var thrownException: FREObject? = nil

            let paramsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
            paramsArray.addPointer(object)

            let status: FREResult = FRECallObjectMethod(object: aneUtils, methodName: "getClassProps", argc: 1, argv: paramsArray,
                    result: &classProps, thrownException: &thrownException)

            if FRE_OK == status {
                let arrayLength = self.getArrayLength(arrayOrVector: classProps!)
                for i in 0 ..< arrayLength {
                    var elem: FREObject? = nil
                    let status: FREResult = FREGetArrayElementAt(arrayOrVector: classProps!, index: i, value: &elem)
                    if FRE_OK == status && elem != nil {
                        let propName: String = getString(object: getProperty(object: elem!, name: "name")!) //TODO guard
                        //let propType:String = getString(getProperty(object: elem!, name: "type")!) //TODO guard
                        let propVal: FREObject! = getProperty(object: object, name: propName)
                        if FRE_TYPE_NULL == getObjectType(object: propVal) {
                            continue
                        }
                        let propvalId = getIdObject(object: propVal)
                        if (propvalId != nil) {
                            ret.updateValue(propvalId as AnyObject, forKey: propName)
                        }
                    }
                }
            }
        }
        return ret
    }

    func getIdObject(object: FREObject) -> Any? {
        var objectType: FREObjectType = FRE_TYPE_NULL
        _ = FREGetObjectType(object: object, objectType: &objectType)
        switch objectType {
        case FRE_TYPE_VECTOR, FRE_TYPE_ARRAY:
            return getArray(arrayOrVector: object)
        case FRE_TYPE_STRING:
            return getString(object: object)
        case FRE_TYPE_BOOLEAN:
            return getBool(object: object)
        case FRE_TYPE_OBJECT:
            return getDictionary(object: object)
        case FRE_TYPE_NUMBER:
            switch getActionscriptClassType(object: object) {
            case FREObjectType2.FRE_TYPE_NUMBER:
                return getDouble(object: object)
            case FREObjectType2.FRE_TYPE_INT:
                return getInt(object: object)
            case FREObjectType2.FRE_TYPE_BOOLEAN:
                return getBool(object: object)
            default:
                return getDouble(object: object)
            }
        case FRE_TYPE_BITMAPDATA:
            return nil //TODO
        case FRE_TYPE_BYTEARRAY:
            return nil //TODO
        case FRE_TYPE_NULL:
            return nil
        default:
            break
        }
        return nil
    }

    func createFREObject(className: String, params: Any...) -> FREObject? {
        let paramsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        var ret: FREObject? = nil
        var thrownException: FREObject? = nil

        for i in 0 ..< params.count {
            let param: FREObject? = getFREObject(any: params[i])
            paramsArray.addPointer(param)
        }

        let status: FREResult = FRENewObject(className: className, argc: UInt32(paramsArray.count), argv: paramsArray,
                object: &ret, thrownException: &thrownException)
        if isFREResultOK(errorCode: status, errorMessage: "Could not create FREObject \(className).") {
            return ret
        }
        _ = hasThrownException(thrownException: thrownException!)
        return nil

    }


    func getFREObject(string: String) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromUTF8(length: UInt32(string.utf8.count), value: string, object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert String to FREObject.") {
            return ret
        }
        return nil
    }

    func getFREObject(double: Double) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromDouble(value: double, object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert Double to FREObject.") {
            return ret
        }
        return nil
    }

    func getFREObject(int: Int) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromInt32(value: Int32(int), object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert Int32 to FREObject.") {
            return ret
        }
        return nil
    }

    func getFREObject(int32: Int32) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromInt32(value: int32, object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert Int32 to FREObject.") {
            return ret
        }
        return nil
    }

    func getFREObject(uint: UInt) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromUint32(value: UInt32(uint), object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert Uint to FREObject.") {
            return ret
        }
        return nil

    }

    func getFREObject(uint32: UInt32) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromUint32(value: uint32, object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert Uint to FREObject.") {
            return ret
        }
        return nil
    }

    func getFREObject(bool: Bool) -> FREObject? {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromBool(value: bool, object: &ret)
        if isFREResultOK(errorCode: status, errorMessage: "Could not convert Bool to FREObject.") {
            return ret
        }
        return nil
    }

    func getFREObject(any: Any) -> FREObject? {
        let ret: FREObject? = nil
        if any is String {
            return getFREObject(string: any as! String)
        } else if any is Int {
            return getFREObject(int: any as! Int)
        } else if any is Int32 {
            return getFREObject(int32: any as! Int32)
        } else if any is UInt {
            return getFREObject(uint: any as! UInt)
        } else if any is UInt32 {
            return getFREObject(uint32: any as! UInt32)
        } else if any is Double {
            return getFREObject(double: any as! Double)
        } else if any is Bool {
            return getFREObject(bool: any as! Bool)
        } //TODO add Dict and others
        return ret
    }

    private func hasThrownException(thrownException: FREObject?) -> Bool {
        if thrownException == nil {
            return false
        }
        var objectType: FREObjectType = FRE_TYPE_NULL

        if FRE_OK != FREGetObjectType(object: thrownException, objectType: &objectType) {
            trace("Exception was thrown, but failed to obtain information about it")
            return true
        }

        if FRE_TYPE_OBJECT == objectType {
            var exceptionTextAS: FREObject? = nil
            var newException: FREObject? = nil
            if FRE_OK != FRECallObjectMethod(object: thrownException!, methodName: "toString", argc: 0,
                    argv: nil, result: &exceptionTextAS, thrownException: &newException) {
                trace("Exception was thrown, but failed to obtain information about it")
                return true
            }
            return true
        }
        return false
    }


    func call(object: FREObject, methodName: String, params: Any...) -> FREObject? {
        let paramsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        var ret: FREObject? = nil
        var thrownException: FREObject? = nil
        for i in 0 ..< params.count {
            let param: FREObject? = getFREObject(any: params[i])
            paramsArray.addPointer(param)
        }

        let status: FREResult = FRECallObjectMethod(object: object, methodName: methodName,
                argc: UInt32(paramsArray.count), argv: paramsArray, result: &ret,
                thrownException: &thrownException)

        if isFREResultOK(errorCode: status, errorMessage: "Could not call method \(methodName).") {
            return ret
        }
        _ = hasThrownException(thrownException: thrownException!)
        return nil
    }

    func setProperty(object: FREObject, name: String, prop: FREObject) {
        var thrownException: FREObject? = nil
        let status: FREResult = FRESetObjectProperty(object: object, propertyName: name,
                propertyValue: prop, thrownException: &thrownException)

        if isFREResultOK(errorCode: status, errorMessage: "Could not set property \(name).") {
            return
        }

        _ = hasThrownException(thrownException: thrownException!)

    }

    func getProperty(object: FREObject, name: String) -> FREObject? {
        var ret: FREObject? = nil
        var thrownException: FREObject? = nil
        let status: FREResult = FREGetObjectProperty(object: object, propertyName: name, propertyValue: &ret,
                thrownException: &thrownException)
        if isFREResultOK(errorCode: status, errorMessage: "Could not get FREObject property \(name).") {
            return ret
        }
        _ = hasThrownException(thrownException: thrownException!)
        return nil
    }


    func getObjectType(object: FREObject?) -> FREObjectType {
        var objectType: FREObjectType = FRE_TYPE_NULL
        _ = FREGetObjectType(object: object, objectType: &objectType)
        return objectType
    }

    private func isFREResultOK(errorCode: FREResult, errorMessage: String) -> Bool {
        if FRE_OK == errorCode {
            return true
        }
        trace(errorMessage, errorCode)
        return false
    }

    private func getActionscriptClassType(object: FREObject) -> FREObjectType2 {
        let aneUtils: FREObject? = createFREObject(className: "com.tuarua.ANEUtils")
        if FRE_TYPE_NULL != getObjectType(object: aneUtils) {
            let params: NSPointerArray = NSPointerArray(options: .opaqueMemory)
            params.addPointer(object)

            var classType: FREObject? = nil
            let status: FREResult = FRECallObjectMethod(object: aneUtils!, methodName: "getClassType",
                    argc: 1, argv: params, result: &classType, thrownException: nil)
            if FRE_OK == status {
                let type: String = getString(object: classType!).lowercased()
                if type == "int" {
                    return FREObjectType2.FRE_TYPE_INT
                } else if type == "string" {
                    return FREObjectType2.FRE_TYPE_STRING
                } else if type == "number" {
                    return FREObjectType2.FRE_TYPE_NUMBER
                } else if type == "boolean" {
                    return FREObjectType2.FRE_TYPE_BOOLEAN
                } else {
                    return FREObjectType2.FRE_TYPE_CUSTOM
                }
            }
        }
        return FREObjectType2.FRE_TYPE_NULL
    }

    func traceFriendlyFREResult(tag: String, result: FREResult) {
        switch result {
        case FRE_OK:
            trace(tag, "FRE_OK")
            break
        case FRE_NO_SUCH_NAME:
            trace(tag, "FRE_NO_SUCH_NAME")
            break
        case FRE_INVALID_OBJECT:
            trace(tag, "FRE_INVALID_OBJECT")
            break
        case FRE_TYPE_MISMATCH:
            trace(tag, "FRE_TYPE_MISMATCH")
            break
        case FRE_ACTIONSCRIPT_ERROR:
            trace(tag, "FRE_ACTIONSCRIPT_ERROR")
            break
        case FRE_INVALID_ARGUMENT:
            trace(tag, "FRE_INVALID_ARGUMENT")
            break
        case FRE_READ_ONLY:
            trace(tag, "FRE_READ_ONLY")
            break
        case FRE_WRONG_THREAD:
            trace(tag, "FRE_WRONG_THREAD")
            break
        case FRE_ILLEGAL_STATE:
            trace(tag, "FRE_ILLEGAL_STATE")
            break
        case FRE_INSUFFICIENT_MEMORY:
            trace(tag, "FRE_INSUFFICIENT_MEMORY")
            break
        default:
            trace("")
        }
    }

    func traceObjectType(tag: String, object: FREObject?) {
        guard let object = object else {
            trace(tag, "FRE_TYPE_NULL")
            return
        }
        var objectType: FREObjectType = FRE_TYPE_NULL
        _ = FREGetObjectType(object: object, objectType: &objectType)

        switch objectType {
        case FRE_TYPE_ARRAY:
            trace(tag, "FRE_TYPE_ARRAY")
            break
        case FRE_TYPE_VECTOR:
            trace(tag, "FRE_TYPE_VECTOR")
            break
        case FRE_TYPE_STRING:
            trace(tag, "FRE_TYPE_STRING")
            break
        case FRE_TYPE_BOOLEAN:
            trace(tag, "FRE_TYPE_BOOLEAN")
            break
        case FRE_TYPE_OBJECT:
            trace(tag, "FRE_TYPE_OBJECT")
            break
        case FRE_TYPE_NUMBER:
            switch getActionscriptClassType(object: object) {
            case FREObjectType2.FRE_TYPE_NUMBER:
                trace(tag, "FRE_TYPE_NUMBER")
                break
            case FREObjectType2.FRE_TYPE_INT:
                trace(tag, "FRE_TYPE_INT")
                break
            case FREObjectType2.FRE_TYPE_BOOLEAN:
                trace(tag, "FRE_TYPE_BOOLEAN")
                break
            default:
                trace(tag, "FRE_TYPE_NUMBER")
                break
            }
            break
        case FRE_TYPE_NULL:
            trace(tag, "FRE_TYPE_NULL")
            break
        default:
            break
        }
    }


}
