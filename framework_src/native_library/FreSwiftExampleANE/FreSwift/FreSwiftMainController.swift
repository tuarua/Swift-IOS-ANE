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

/// FreSwiftMainController: Our SwiftController extends this Protocol.
public protocol FreSwiftMainController {
    /// Map of functions to connect Objective C to Swift
    var functionsToSet: FREFunctionMap { get set }
    /// FREContext
    var context: FreContextSwift! { get set }
    /// Tag used when tracing logs
    static var TAG: String { get set }
    /// Returns functions which connect Objective C to Swift
    func getFunctions(prefix: String) -> [String]
    /// Allows Objective C to call our Swift Controller
    /// - parameter name: name of the function
    /// - parameter ctx: context
    /// - parameter argc: number of arguments
    /// - parameter argv: array of FREObject arguments
    func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject?
    /// Called by Objective C when ANE is loaded into memory
    /// ```swift
    /// @objc func applicationDidFinishLaunching(_ notification: Notification) {
    ///     appDidFinishLaunchingNotif = notification
    /// }
    ///
    /// public func onLoad() {
    ///    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
    ///    name: UIApplication.didFinishLaunchingNotification, object: nil)
    /// }
    /// ```
    func onLoad()
}

public extension FreSwiftMainController {
    /// trace: sends StatusEvent to our swc with a level of "TRACE"
    ///
    /// ```swift
    /// trace("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func trace(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        dispatchEvent(name: "TRACE", value: traceStr)
    }
    
    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with ℹ️ INFO:
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        dispatchEvent(name: "TRACE", value: "ℹ️ INFO: \(traceStr)")
    }
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with ⚠️ WARNING:
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr = "\(Self.TAG):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        dispatchEvent(name: "TRACE", value: "⚠️ WARNING: \(traceStr)")
    }
    
    /// dispatchEvent: sends StatusEvent to our swc with a level of name and code of value
    /// replaces DispatchStatusEventAsync
    ///
    /// ```swift
    /// dispatchEvent("MY_EVENT", "ok")
    /// ```
    /// - parameter name: name of event
    /// - parameter value: value passed with event
    /// - returns: Void
    func dispatchEvent(name: String, value: String) {
        autoreleasepool {
            context.dispatchStatusEventAsync(code: value, level: name)
        }
    }
    
    @available(*, obsoleted: 3.0.0, renamed: "dispatchEvent()")
    func sendEvent(name: String, value: String) { }
}
