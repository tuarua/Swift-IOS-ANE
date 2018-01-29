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
/// FreByteArraySwift: wrapper for FREByteArray.
public class FreByteArraySwift: NSObject {
    /// raw FREObject value.
    public var rawValue: FREObject?
    ///  An UnsafeMutablePointer<UInt8> that is a pointer to the bytes in the ActionScript ByteArray object.
    public var bytes: UnsafeMutablePointer<UInt8>!
    /// A UInt that is the number of bytes in the bytes array.
    public var length: UInt = 0
    private var _byteArray: FREByteArray = FREByteArray.init()

    /// init: inits with a FREObject
    /// - parameter freByteArray: FREObject of AS3 type ByteArray
    public init(freByteArray: FREObject) {
        rawValue = freByteArray
    }

    // init: inits with a NSData
    /// - parameter data: NSData which will be converted into FREByteArray
    public init(data: NSData) {
        super.init()
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
            if let targetBA = try FREObject.init(className: "flash.utils.ByteArray") {
                rawValue = targetBA
                try targetBA.setProp(name: "length", value: data.length)
#if os(iOS)
                let status: FREResult = FreSwiftBridge.bridge.FREAcquireByteArray(object: targetBA,
                                                                                  byteArrayToSet: &_byteArray)
#else
                let status: FREResult = FREAcquireByteArray(targetBA, &_byteArray)
#endif
                guard FRE_OK == status else {
                    throw FreError(stackTrace: "", message: "cannot acquire ByteArray",
                                   type: FreSwiftHelper.getErrorCode(status),
                      line: #line, column: #column, file: #file)
                }
                memcpy(_byteArray.bytes, data.bytes, data.length)
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

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14342e2bac129470ccccb-8000.html)
    /// - throws: Can throw a `FreError` on fail
    public func acquire() throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }

#if os(iOS)
        let status: FREResult = FreSwiftBridge.bridge.FREAcquireByteArray(object: rv, byteArrayToSet: &_byteArray)
#else
        let status: FREResult = FREAcquireByteArray(rv, &_byteArray)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "",
                           message: "cannot acquire ByteArray",
                           type: FreSwiftHelper.getErrorCode(status),
                           line: #line, column: #column, file: #file)
        }
        length = UInt(_byteArray.length)
        bytes = _byteArray.bytes
    }
    
    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b1466485a1a1294715f88b-8000.html)
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

    /// Handles conversion to a NSData
    /// - throws: Can throw a `FreError` on fail
    /// returns: NSData
    func getAsData() throws -> NSData {
        try self.acquire()
        return NSData.init(bytes: bytes, length: Int(length))
    }

    /// Handles conversion to a NSData
    /// - throws: Can throw a `FreError` on fail
    /// returns: NSData?
    public var value: NSData? {
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
