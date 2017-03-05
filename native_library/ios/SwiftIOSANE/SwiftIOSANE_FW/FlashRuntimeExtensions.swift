//
//  FlashRuntimeExtensions.swift
//  SwiftIOSANE
//
//  Created by Eoin Landy on 01/03/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Foundation

/// new objects
func FRENewObjectFromBool(value: Bool, object: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRENewObjectFromBool(value: value, object: object)
}

func FRENewObjectFromInt32(value: Int32, object: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRENewObjectFromInt32(value: value, object: object)
}

func FRENewObjectFromUint32(value: UInt32, object: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRENewObjectFromUint32(value: value, object: object)
}

func FRENewObjectFromUTF8(length: UInt32, value: String, object: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRENewObjectFromUTF8(length: length, value: value, object: object)
}

func FRENewObjectFromDouble(value: Double, object: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRENewObjectFromDouble(value: value, object: object)
}

func FRENewObject(className: String, argc: UInt32, argv: NSPointerArray?, object: FREObject?, thrownException: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRENewObject(className: className, argc: argc, argv: argv, object: object, thrownException: thrownException)
}


///get objects


func FREGetObjectProperty(object: FREObject, propertyName: String, propertyValue: FREObject?, thrownException: FREObject?) -> FREResult {
    let res: FREResult = FRESwiftBridge.bridge.FREGetObjectProperty(object: object,
            propertyName: propertyName,
            propertyValue: propertyValue,
            thrownException: thrownException)
    return res
}

func FREGetObjectType(object: FREObject?, objectType: inout FREObjectType) -> FREResult {
    return FRESwiftBridge.bridge.FREGetObjectType(object: object, objectType: &objectType)
}

func FREGetObjectAsBool(object: FREObject, value: inout Bool) -> FREResult {
    var val: UInt32 = 0
    let res: FREResult = FRESwiftBridge.bridge.FREGetObjectAsBool(object: object, value: &val)
    value = val == 1 ? true : false
    return res
}

func FREGetObjectAsInt32(object: FREObject, value: inout Int32) -> FREResult {
    return FRESwiftBridge.bridge.FREGetObjectAsInt32(object: object, value: &value)
}

func FREGetObjectAsUint32(object: FREObject, value: inout UInt32) -> FREResult {
    return FRESwiftBridge.bridge.FREGetObjectAsUint32(object: object, value: &value)
}

func FREGetObjectAsDouble(object: FREObject, value: inout Double) -> FREResult {
    return FRESwiftBridge.bridge.FREGetObjectAsDouble(object: object, value: &value)
}

func FREGetObjectAsUTF8(object: FREObject, length: inout UInt32, value: inout String) -> FREResult {
    var valuePtr: UnsafePointer<UInt8>? = nil
    let res: FREResult = FRESwiftBridge.bridge.FREGetObjectAsUTF8(object: object, length: &length, value: &valuePtr)
    value = (NSString(bytes: valuePtr!, length: Int(length), encoding: String.Encoding.utf8.rawValue) as? String)!
    return res
}

func FRESetObjectProperty(object: FREObject, propertyName: String, propertyValue: FREObject?, thrownException: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRESetObjectProperty(object: object,
            propertyName: propertyName,
            propertyValue: propertyValue,
            thrownException: thrownException)
}

func FRESetArrayElementAt(arrayOrVector: FREObject, index: UInt32, value: FREObject?) -> FREResult {
    //"At" is reserved, justUsing A
    return (FRESwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: arrayOrVector, index: index, value: value))
}

func FREGetArrayLength(arrayOrVector: FREObject, length: inout UInt32) -> FREResult {
    return FRESwiftBridge.bridge.FREGetArrayLength(arrayOrVector: arrayOrVector, length: &length)
}


func FRESetArrayLength(arrayOrVector: FREObject, length: UInt32) -> FREResult {
    return FRESwiftBridge.bridge.FRESetArrayLength(arrayOrVector: arrayOrVector, length: length)
}

func FREGetArrayElementAt(arrayOrVector: FREObject, index: UInt32, value: FREObject?) -> FREResult {
    //"At" is reserved, justUsing A
    return (FRESwiftBridge.bridge.FREGetArrayElementA(arrayOrVector: arrayOrVector, index: index, value: value))
}


func FRECallObjectMethod(object: FREObject, methodName: String, argc: UInt32, argv: NSPointerArray?, result: FREObject?, thrownException: FREObject?) -> FREResult {
    return FRESwiftBridge.bridge.FRECallObjectMethod(object: object, methodName: methodName, argc: argc, argv: argv, result: result, thrownException: thrownException)
}

func FREDispatchStatusEventAsync(ctx: FREContext, code: String, level: String) -> FREResult {
    return FRESwiftBridge.bridge.FREDispatchStatusEventAsync(ctx: ctx, code: code, level: level)
}

