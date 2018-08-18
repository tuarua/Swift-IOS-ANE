/* Copyright 2018 Tua Rua Ltd.
 
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

public class FreSwiftLogger {
    open var context: FreContextSwift?
    private static var sharedLogger: FreSwiftLogger = {
        let logger = FreSwiftLogger()
        return logger
    }()
    
    private init() {
    }
    
    open class func shared() -> FreSwiftLogger {
        return sharedLogger
    }
    
    func log(message: String, stackTrace: String? = nil, type: FreError.Code, line: Int, column: Int, file: String) {
        guard let ctx = context else { return }
        do {
            try ctx.dispatchStatusEventAsync(code: "[FreSwift] \(String(describing: type)) \(message)", level: "TRACE")
            try ctx.dispatchStatusEventAsync(code: "[FreSwift] \(URL.init(string: file)?.lastPathComponent ?? "") line:\(line):\(column)", level: "TRACE")
            if let stackTrace = stackTrace {
                try ctx.dispatchStatusEventAsync(code: "[FreSwift] \(stackTrace)", level: "TRACE")
            }
        } catch {
        }
    }
    
}
