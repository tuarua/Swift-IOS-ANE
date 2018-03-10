/* Copyright 2018 Tua Rua Ltd.

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
/// FreContextSwift: wrapper for FREContext.
open class FreContextSwift: NSObject {
    /// FREContext
    public var rawValue: FREContext?

    /// init: inits a FreContextSwift.
    /// - parameter freContext: FREContext
    public init(freContext: FREContext) {
        rawValue = freContext
    }
    /// :nodoc:
    public func dispatchStatusEventAsync(code: String, level: String) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREDispatchStatusEventAsync(ctx: rv, code: code, level: level)
#else
        let status: FREResult = FREDispatchStatusEventAsync(rv, code, level)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot dispatch event \(code):\(level)",
              type: FreSwiftHelper.getErrorCode(status), line: #line, column: #column, file: #file)
        }
    }

    /// getActionScriptData: Call this function to get an extension context’s ActionScript data.
    /// - throws: Can throw a `FreError` on fail
    public func getActionScriptData() throws -> FREObject? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetContextActionScriptData(ctx: rv, actionScriptData: &ret)
#else
        let status: FREResult = FREGetContextActionScriptData(rv, &ret)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get actionscript data",
                           type: FreSwiftHelper.getErrorCode(status),
              line: #line, column: #column, file: #file)
        }
        return ret
    }

    /// setActionScriptData: Call this function to set an extension context’s ActionScript data.
    /// - parameter object: FREObject to set
    /// - throws: Can throw a `FreError` on fail
    public func setActionScriptData(object: FREObject) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
#if os(iOS) || os(tvOS)
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
