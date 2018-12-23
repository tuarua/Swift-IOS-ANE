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
/// FreSwiftLogger: Logger utility for logging any FRE errors which occur
public class FreSwiftLogger {
    /// context: sets/gets the FreContextSwift
    open var context: FreContextSwift?
    
    /// shared: returns the shared instance
    public static let shared = FreSwiftLogger()
    
    private init() {
    }
    
    /// log: traces the message to the console
    /// - parameter message: message to log
    /// - parameter stackTrace: stack trace to log
    /// - parameter type: type of error
    /// - parameter line: line where error occurred
    /// - parameter column: column where error occurred
    /// - parameter file: file name where error occurred
    public func log(message: String, stackTrace: String? = nil, type: FreError.Code, line: Int, column: Int, file: String) {
        guard let ctx = context else { return }
        ctx.dispatchStatusEventAsync(code: "[FreSwift] ‼️ \(String(describing: type)) \(message)", level: "TRACE")
        ctx.dispatchStatusEventAsync(code: "[FreSwift] ‼️ \(URL(string: file)?.lastPathComponent ?? "") line:\(line):\(column)", level: "TRACE")
        if let stackTrace = stackTrace {
            ctx.dispatchStatusEventAsync(code: "[FreSwift] ‼️ \(stackTrace)", level: "TRACE")
        }
    }
    
}
