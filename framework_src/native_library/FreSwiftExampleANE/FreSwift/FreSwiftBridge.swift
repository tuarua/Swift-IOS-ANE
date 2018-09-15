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
/// :nodoc:
@objc public protocol FreSwiftBridgeProtocol {
    @objc func FREDispatchStatusEventAsync(ctx: FREContext, code: String, level: String) -> FREResult

    @objc func FRENewObjectFromBool(value: Bool, object: FREObject?) -> FREResult

    @objc func FRENewObjectFromInt32(value: Int32, object: FREObject?) -> FREResult

    @objc func FRENewObjectFromUint32(value: UInt32, object: FREObject?) -> FREResult

    @objc func FRENewObjectFromDouble(value: Double, object: FREObject?) -> FREResult

    @objc func FRENewObjectFromUTF8(length: UInt32, value: String, object: FREObject?) -> FREResult

    @objc func FREGetObjectAsBool(object: FREObject, value: UnsafeMutablePointer<UInt32>) -> FREResult

    @objc func FREGetObjectAsInt32(object: FREObject, value: UnsafeMutablePointer<Int32>) -> FREResult

    @objc func FREGetObjectAsUint32(object: FREObject, value: UnsafeMutablePointer<UInt32>) -> FREResult

    @objc func FREGetObjectAsDouble(object: FREObject, value: UnsafeMutablePointer<Double>) -> FREResult

    @objc func FRENewObject(className: String, argc: UInt32, argv: NSPointerArray?, object: FREObject?,
                            thrownException: FREObject?) -> FREResult

    @objc func FREGetObjectProperty(object: FREObject, propertyName: String, propertyValue: FREObject?,
                                    thrownException: FREObject?) -> FREResult

    @objc func FRESetObjectProperty(object: FREObject, propertyName: String, propertyValue: FREObject?,
                                    thrownException: FREObject?) -> FREResult

    @objc func FREGetObjectType(object: FREObject?, objectType: UnsafeMutablePointer<FREObjectType>) -> FREResult

    @objc func FREGetObjectAsUTF8(object: FREObject, length: UnsafeMutablePointer<UInt32>,
                                  value: UnsafePointer<UnsafePointer<UInt8>?>?) -> FREResult

    @objc func FRECallObjectMethod(object: FREObject, methodName: String, argc: UInt32,
                                   argv: NSPointerArray?,
                                   result: FREObject?,
                                   thrownException: FREObject?) -> FREResult

    @objc func FRESetArrayElementA(arrayOrVector: FREObject, index: UInt32, value: FREObject?) -> FREResult

    @objc func FREGetArrayElementA(arrayOrVector: FREObject, index: UInt32, value: FREObject?) -> FREResult

    @objc func FREGetArrayLength(arrayOrVector: FREObject, length: UnsafeMutablePointer<UInt32>) -> FREResult

    @objc func FRESetArrayLength(arrayOrVector: FREObject, length: UInt32) -> FREResult
    
    @objc func FREAcquireBitmapData2(object: FREObject,
                                     descriptorToSet: UnsafeMutablePointer<FREBitmapData2>) -> FREResult
    
    @objc func FREReleaseBitmapData(object: FREObject) -> FREResult
    
    @objc func FREAcquireByteArray(object: FREObject, byteArrayToSet: UnsafeMutablePointer<FREByteArray>) -> FREResult

    @objc func FREReleaseByteArray(object: FREObject) -> FREResult

    @objc func FRESetContextActionScriptData(ctx: FREContext, actionScriptData: FREObject) -> FREResult
    
    @objc func FREGetContextActionScriptData(ctx: FREContext, actionScriptData: FREObject) -> FREResult
    
    @objc func FREInvalidateBitmapDataRect(object: FREObject, x: UInt32, y: UInt32,
                                           width: UInt32, height: UInt32) -> FREResult
    
    @objc func FRESetContextNativeData(ctx: FREContext, nativeData: UnsafeRawPointer) -> FREResult
    
    @objc func FREGetContextNativeData(ctx: FREContext,
                                       nativeData: UnsafeMutablePointer<UnsafeRawPointer>) -> FREResult

}
/// :nodoc:
public class FreSwiftBridge: NSObject {
    @objc public static var bridge: FreSwiftBridgeProtocol!
    @objc public func setDelegate(bridge: FreSwiftBridgeProtocol) {
        FreSwiftBridge.bridge = bridge
    }
}
