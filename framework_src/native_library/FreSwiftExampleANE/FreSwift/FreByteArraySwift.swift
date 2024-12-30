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
/// FreByteArraySwift: wrapper for FREByteArray.
public class FreByteArraySwift: NSObject {
    private var logger: FreSwiftLogger {
        return FreSwiftLogger.shared
    }
    /// raw FREObject value.
    public var rawValue: FREObject?
    ///  An UnsafeMutablePointer<UInt8> that is a pointer to the bytes in the ActionScript ByteArray object.
    public var bytes: UnsafeMutablePointer<UInt8>!
    /// A UInt that is the number of bytes in the bytes array.
    public var length: UInt = 0
    private var _byteArray: FREByteArray = FREByteArray()

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
#if os(iOS) || os(tvOS)
                _ = FreSwiftBridge.bridge.FREReleaseByteArray(object: rv)
#else
                FREReleaseByteArray(rv)
#endif
            }
        }

        // https://forums.adobe.com/thread/1037977
        if let targetBA = FREObject(className: "flash.utils.ByteArray") {
            rawValue = targetBA
            FreSwiftHelper.setProperty(rawValue: targetBA, name: "name", prop: data.length.toFREObject())
#if os(iOS) || os(tvOS)
            let status = FreSwiftBridge.bridge.FREAcquireByteArray(object: targetBA,
                                                                              byteArrayToSet: &_byteArray)
#else
            let status = FREAcquireByteArray(targetBA, &_byteArray)
#endif
            guard FRE_OK == status else {
                logger.error(message: "cannot acquire ByteArray",
                                            type: FreSwiftHelper.getErrorCode(status))
                return
            }
            memcpy(_byteArray.bytes, data.bytes, data.length)
            length = UInt(_byteArray.length)
            bytes = _byteArray.bytes
        }
    }

    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b14342e2bac129470ccccb-8000.html)
    public func acquire() {
        guard let rv = rawValue else { return }

#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREAcquireByteArray(object: rv, byteArrayToSet: &_byteArray)
#else
        let status = FREAcquireByteArray(rv, &_byteArray)
#endif
        guard FRE_OK == status else {
            logger.error(message: "cannot acquire ByteArray",
                                        type: FreSwiftHelper.getErrorCode(status))
            return
        }
        
        length = UInt(_byteArray.length)
        bytes = _byteArray.bytes
    }
    
    /// See the original [Adobe documentation](https://help.adobe.com/en_US/air/extensions/WSb464b1207c184b1466485a1a1294715f88b-8000.html)
    public func releaseBytes() { // can't override release
        guard let rv = rawValue else {
            return
        }
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREReleaseByteArray(object: rv)
#else
        let status = FREReleaseByteArray(rv)
#endif
        if FRE_OK == status { return }
        logger.error(message: "cannot release ByteArray",
                                    type: FreSwiftHelper.getErrorCode(status))
    }

    /// Handles conversion to a NSData
    /// returns: NSData
    func getAsData() -> NSData {
        self.acquire()
        return NSData(bytes: bytes, length: Int(length))
    }

    /// Handles conversion to a NSData
    /// returns: NSData?
    public var value: NSData? {
        return getAsData()
    }

}
