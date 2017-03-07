/*@copyright The code is licensed under the[MIT
 License](http://opensource.org/licenses/MIT):
 
 Copyright © 2017 -  Tua Rua Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files(the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions :
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/

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
}

@objc class FRESwiftBridge: NSObject {
    static var bridge: FRESwiftBridgeProtocol!
    func setDelegate(bridge: FRESwiftBridgeProtocol) {
        FRESwiftBridge.bridge = bridge
    }
}
