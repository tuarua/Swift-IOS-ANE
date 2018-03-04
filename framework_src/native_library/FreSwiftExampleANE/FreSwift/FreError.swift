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
/// FreError:
public class FreError: Error {
    /// The stack trace
    public var stackTrace: String = ""
    /// Message to include
    public var message: String = ""
    /// The error code
    public var type: Code
    /// The line at which the error occurred.
    public var line: Int = 0
    /// The column at which the error occurred.
    public var column: Int = 0
    /// The file in which the error occurred.
    public var file: String = ""

    /// Error code. Matches values of FREResult
    public enum Code {
        /// The function succeeded.
        case ok
        /// The name of a class, property, or method passed as a parameter does not match an ActionScript
        /// class name, property, or method.
        case noSuchName
        ///  An FREObject parameter is invalid. For examples of invalid FREObject variables, see
        /// [FREObject validity](https://help.adobe.com/en_US/air/extensions/WS460ee381960520ad-866f9c112aa6e1ad46-7ffa.html#WS460ee381960520ad-866f9c112aa6e1ad46-7ff9).
        case invalidObject
        /// An FREObject parameter does not represent an object of the ActionScript class expected by the called
        /// function.
        case typeMismatch
        /// An ActionScript error occurred, and an exception was thrown. The C API functions that can result in
        /// this error allow you to specify an FREObject to receive information about the exception.
        case actionscriptError
        /// A pointer parameter is NULL.
        case invalidArgument
        /// The function attempted to modify a read-only property of an ActionScript object.
        case readOnly
        /// The method was called from a thread other than the one on which the runtime has an outstanding call
        /// to a native extension function.
        case wrongThread
        /// A call was made to a native extensions C API function when the extension context was in an illegal
        /// state for that call. This return value occurs in the following situation. The context has acquired access
        /// to an ActionScript BitmapData or ByteArray class object. With one exception, the context can call no
        /// other C API functions until it releases the BitmapData or ByteArray object. The one exception is that
        /// the context can call FREInvalidateBitmapDataRect() after calling FREAcquireBitmapData()
        /// or FREAcquireBitmapData2().
        case illegalState
        /// The runtime could not allocate enough memory to change the size of an Array or Vector object.
        case insufficientMemory
    }

    /// init:
    public init(stackTrace: String, message: String, type: Code, line: Int, column: Int, file: String) {
        self.stackTrace = stackTrace
        self.message = message
        self.type = type
        self.line = line
        self.column = column
        self.file = file
    }

    /// init:
    public init(stackTrace: String, message: String, type: Code) {
        self.stackTrace = stackTrace
        self.message = message
        self.type = type
    }

    /// getError: returns a FREObject representation of the FreError. This can be returned to AS3
    public func getError(_ oFile: String, _ oLine: Int, _ oColumn: Int) -> FREObject? {
        do {
            let _aneError = try FREObject.init(className: "com.tuarua.fre.ANEError",
              args: message,
              0,
              String(describing: type),
              "[\(oFile):\(oLine):\(oColumn)]",
              stackTrace)
            return _aneError

        } catch {
        }
        return nil
    }
}
