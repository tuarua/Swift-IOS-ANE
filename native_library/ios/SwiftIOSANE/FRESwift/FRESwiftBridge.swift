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

@objc protocol FRESwiftBridgeProtocol {
    func FREDispatchStatusEventAsync(ctx: FREContext, code: String, level: String) -> FREResult

    func FRENewObjectFromBool(value: Bool, object: FREObject?) -> FREResult

    func FRENewObjectFromInt32(value: Int32, object: FREObject?) -> FREResult

    func FRENewObjectFromUint32(value: UInt32, object: FREObject?) -> FREResult

    func FRENewObjectFromDouble(value: Double, object: FREObject?) -> FREResult

    func FRENewObjectFromUTF8(length: UInt32, value: String, object: FREObject?) -> FREResult

    func FREGetObjectAsBool(object: FREObject, value: UnsafeMutablePointer<UInt32>) -> FREResult

    func FREGetObjectAsInt32(object: FREObject, value: UnsafeMutablePointer<Int32>) -> FREResult

    func FREGetObjectAsUint32(object: FREObject, value: UnsafeMutablePointer<UInt32>) -> FREResult

    func FREGetObjectAsDouble(object: FREObject, value: UnsafeMutablePointer<Double>) -> FREResult

    func FRENewObject(className: String, argc: UInt32, argv: NSPointerArray?, object: FREObject?, thrownException: FREObject?) -> FREResult

    func FREGetObjectProperty(object: FREObject, propertyName: String, propertyValue: FREObject?, thrownException: FREObject?) -> FREResult

    func FRESetObjectProperty(object: FREObject, propertyName: String, propertyValue: FREObject?, thrownException: FREObject?) -> FREResult

    func FREGetObjectType(object: FREObject?, objectType: UnsafeMutablePointer<FREObjectType>) -> FREResult

    func FREGetObjectAsUTF8(object: FREObject, length: UnsafeMutablePointer<UInt32>, value: UnsafePointer<UnsafePointer<UInt8>?>?) -> FREResult

    func FRECallObjectMethod(object: FREObject, methodName: String, argc: UInt32, argv: NSPointerArray?, result: FREObject?, thrownException: FREObject?) -> FREResult

    func FRESetArrayElementA(arrayOrVector: FREObject, index: UInt32, value: FREObject?) -> FREResult

    func FREGetArrayElementA(arrayOrVector: FREObject, index: UInt32, value: FREObject?) -> FREResult

    func FREGetArrayLength(arrayOrVector: FREObject, length: UnsafeMutablePointer<UInt32>) -> FREResult

    func FRESetArrayLength(arrayOrVector: FREObject, length: UInt32) -> FREResult
    
    func FREAcquireBitmapData2(object: FREObject, descriptorToSet: UnsafeMutablePointer<FREBitmapData2>) -> FREResult
    
    func FREReleaseBitmapData(object: FREObject) -> FREResult
    
    func FREAcquireByteArray(object: FREObject, byteArrayToSet: UnsafeMutablePointer<FREByteArray>) -> FREResult

    func FREReleaseByteArray(object: FREObject) -> FREResult

    func FRESetContextActionScriptData(ctx: FREContext, actionScriptData: FREObject) -> FREResult
    
    func FREGetContextActionScriptData(ctx: FREContext, actionScriptData: FREObject) -> FREResult
    
    func FREInvalidateBitmapDataRect(object: FREObject, x:UInt32, y:UInt32, width:UInt32, height:UInt32) -> FREResult
    
    func FRESetContextNativeData(ctx: FREContext, nativeData: UnsafeRawPointer) -> FREResult
    
    func FREGetContextNativeData(ctx: FREContext, nativeData: UnsafeMutablePointer<UnsafeRawPointer>) -> FREResult

}

@objc class FRESwiftBridge: NSObject {
    static var bridge: FRESwiftBridgeProtocol!
    func setDelegate(bridge: FRESwiftBridgeProtocol) {
        FRESwiftBridge.bridge = bridge
    }
}
