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

public class FreError: Error {
    public var stackTrace: String = ""
    public var message: String = ""
    public var type: Code
    public var line: Int = 0
    public var column: Int = 0
    public var file: String = ""

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

    public init(stackTrace: String, message: String, type: Code, line: Int, column: Int, file: String) {
        self.stackTrace = stackTrace
        self.message = message
        self.type = type
        self.line = line
        self.column = column
        self.file = file
    }

    public init(stackTrace: String, message: String, type: Code) {
        self.stackTrace = stackTrace
        self.message = message
        self.type = type
    }

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

