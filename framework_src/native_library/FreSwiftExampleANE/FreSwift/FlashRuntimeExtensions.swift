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
/// FREObject arguments
public typealias FREArgv = UnsafeMutablePointer<FREObject?>
/// Number of arguments
public typealias FREArgc = UInt32
/// Dictionary of FREFunctions
public typealias FREFunctionMap = [String: (_: FREContext, _: FREArgc, _: FREArgv) -> FREObject?]

/// FreSwiftMainController: Our SwiftController extends this Protocol.
public protocol FreSwiftMainController {
    /// Map of functions to connect Objective C to Swift
    var functionsToSet: FREFunctionMap { get set }
    /// FREContext
    var context: FreContextSwift! { get set }
    /// Tag used when tracing logs
    var TAG: String? { get set }
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
    ///                                           name: NSNotification.Name.UIApplicationDidFinishLaunching,
    ///                                           object: nil)
    ///
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
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        dispatchEvent(name: "TRACE", value: traceStr)
    }
    
    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [INFO]
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        dispatchEvent(name: "TRACE", value: "ℹ️ INFO: \(traceStr)")
    }
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [WARNING]
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
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
}

/// FreSwiftController: Protocol for Swift classes to conform to
public protocol FreSwiftController {
    /// FREContext
    var context: FreContextSwift! { get set }
    /// Tag used when tracing logs
    var TAG: String? { get set }
}

public extension FreSwiftController {
    /// trace: sends StatusEvent to our swc with a level of "TRACE"
    ///
    /// ```swift
    /// trace("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func trace(_ value: Any...) {
        var traceStr: String = ""
        for i in 0..<value.count {
            traceStr.append("\(value[i]) ")
        }
        dispatchEvent(name: "TRACE", value: traceStr)
    }
    
    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [INFO]
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        dispatchEvent(name: "TRACE", value: "ℹ️ INFO: \(traceStr)")
    }
    
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [WARNING]
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value: value to trace to console
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
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
}

/// FREObject: Extends FREObject with Swift syntax.
public extension FREObject {
    
    /// hasOwnProperty: Indicates whether an object has a specified property defined.
    ///
    /// ```swift
    /// if argv[0].hasOwnProperty("name") {
    ///
    /// }
    /// ```
    /// - parameter name: The property of the FREObject.
    /// - returns: Bool
    func hasOwnProperty(name: String) -> Bool {
        if let hasOwnProperty = self.call(method: "hasOwnProperty", args: name) {
            return Bool(hasOwnProperty) ?? false
        }
        return false
    }
    
    /// hasOwnProperty: Calls toString() on a FREObjectCalls toString() on a FREObject
    /// - returns: String
    func toString(_ suppressStrings: Bool = false) -> String {
        if (suppressStrings && self.type == FreObjectTypeSwift.string) || (self.type == FreObjectTypeSwift.null) {
            return ""
        }
        if let toString = self.call(method: "toString") {
            return String(toString) ?? ""
        }
        return ""
    }
    
    /// getProp: returns the Property of a FREObject.
    ///
    /// ```swift
    /// let myName = argv[0].getProp("name")
    /// ```
    /// - parameter name: name of the property to return
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    @available(*, deprecated, message: "use accessor or FreSwiftObject wrapper instead")
    func getProp(name: String) throws -> FREObject? {
        if let ret = FreSwiftHelper.getProperty(rawValue: self, name: name) {
            return ret
        }
        return nil
    }

    /// setProp: sets the Property of a FREObject.
    /// - parameter name: name of the property to set
    /// - parameter value: value to set to
    /// - throws: Can throw a `FreError` on fail
    /// - returns: Void
    @available(*, deprecated, message: "use accessor or FreSwiftObject wrapper instead")
    func setProp(name: String, value: Any?) throws {
        if value is FREObject {
            FreSwiftHelper.setProperty(rawValue: self, name: name, prop: value as? FREObject)
        } else if value is FREArray {
            if let v = value as? FREArray {
              FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.rawValue)
            }
        } else if value is FreObjectSwift {
            if let v = value as? FreObjectSwift {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.rawValue)
            }
        } else if value is String {
            if let v = value as? String {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is Int {
            if let v = value as? Int {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is Int32 {
            if let v = value as? Int32 {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (Int(v)).toFREObject())
            }
        } else if value is UInt {
            if let v = value as? UInt {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is UInt32 {
            if let v = value as? UInt32 {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (UInt(v)).toFREObject())
            }
        } else if value is Double {
            if let v = value as? Double {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is CGFloat {
            if let v = value as? CGFloat {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is Bool {
            if let v = value as? Bool {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is Date {
            if let v = value as? Date {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is CGRect {
            if let v = value as? CGRect {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        } else if value is CGPoint {
            if let v = value as? CGPoint {
                FreSwiftHelper.setProperty(rawValue: self, name: name, prop: v.toFREObject())
            }
        }
    }
    
    /// init: Creates a new FREObject.
    ///
    /// ```swift
    /// let newPerson = FREObject(className: "com.tuarua.Person", args: 1, true, "Free")
    /// ```
    /// - parameter className: name of AS3 class to create
    /// - parameter args: arguments to use. These are automatically converted to FREObjects
    /// - returns: FREObject?
    init?(className: String, args: Any?...) {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            argsArray.addPointer(FreSwiftHelper.newObject(any: args[i]))
        }
        if let rv = FreSwiftHelper.newObject(className: className, argsArray) {
            self.init(rv)
        } else {
            return nil
        }
    }
    
    /// init: Creates a new FREObject.
    ///
    /// ```swift
    /// let newPerson = FREObject(className: "com.tuarua.Person")
    /// ```
    /// - parameter className: name of AS3 class to create
    /// - returns: FREObject?
    init?(className: String) {
        if let rv = FreSwiftHelper.newObject(className: className) {
            self.init(rv)
        } else {
            return nil
        }
    }
    
    /// call: Calls a method on a FREObject.
    ///
    /// ```swift
    /// try person.call(method: "add", args: 100, 31)
    /// ```
    /// - parameter method: name of AS3 method to call
    /// - parameter args: arguments to pass to the method
    /// - returns: FREObject?
    func call(method: String, args: Any...) -> FREObject? {
        return FreSwiftHelper.callMethod(self, name: method, args: args)
    }
    
    /// returns the type of the FREOject
    var type: FreObjectTypeSwift {
        return FreSwiftHelper.getType(self)
    }
    
    /// accessor: sets/gets the Property of a FREObject.
    ///
    /// ```swift
    /// let myName = argv[0]["name"]
    /// argv[0]["name"] = "New Name".toFREOject()
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: FREObject?
    subscript(_ name: String) -> FREObject? {
        get {
            return FreSwiftHelper.getProperty(rawValue: self, name: name)
        }
        set {
            FreSwiftHelper.setProperty(rawValue: self, name: name, prop: newValue)
        }
    }
    
    /// value: returns the Swift value of a FREObject.
    ///
    /// - returns: Any?
    public var value: Any? {
        return FreObjectSwift(self).value
    }
}

public extension NSNumber {
    /// init: Initialise a NSNumber from a FREObject.
    ///
    /// ```swift
    /// let myDouble = NSNumber(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Number
    /// - returns: NSNumber?
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let d = FreSwiftHelper.getAsDouble(rv) {
            self.init(value: d)
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a NSNumber into a FREObject of AS3 type Number.
    ///
    /// ```swift
    /// let fre = myNSNumber.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(Double(truncating: self))
    }
}

public extension Double {
    /// init: Initialise a Double from a FREObject.
    ///
    /// ```swift
    /// let myDouble = Double(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Number
    /// - returns: Double?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        } // TODO need to change
        /*if let i = FreSwiftHelper.getAsInt(rv) {
            self.init(i)
        } else */if let d = FreSwiftHelper.getAsDouble(rv) {
            self.init(d)
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a Double into a FREObject of AS3 type Number.
    ///
    /// ```swift
    // let myDouble = 1.0
    /// let fre = myDouble.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

public extension Float {
    /// init: Initialise a Float from a FREObject.
    ///
    /// ```swift
    /// let myFloat = Float(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Number
    /// - returns: Float?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let d = FreSwiftHelper.getAsDouble(rv) {
            self.init(Float(d))
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a Float into a FREObject of AS3 type Number.
    ///
    /// ```swift
    // let myFloat = Float()
    /// let fre = myFloat.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(CGFloat(self))
    }
    
}

public extension CGFloat {
    /// init: Initialise a CGFloat from a FREObject.
    ///
    /// ```swift
    /// let myCGFloat = CGFloat(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Number
    /// - returns: CGFloat?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let d =  FreSwiftHelper.getAsDouble(rv) {
            self.init(d)
        } else {
            return nil
        }
        
    }
    /// toFREObject: Converts a CGFloat into a FREObject of AS3 type Number.
    ///
    /// ```swift
    // let myCGFloat = CGFloat()
    /// let fre = myCGFloat.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

public extension Bool {
    /// init: Initialise a Bool from a FREObject.
    ///
    /// ```swift
    /// let myBool= Bool(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Boolean
    /// - returns: Bool?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let b = FreSwiftHelper.getAsBool(rv) {
            self.init(b)
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a Bool into a FREObject of AS3 type Boolean.
    ///
    /// ```swift
    /// let fre = true.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

public extension Date {
    /// init: Initialise a Date from a FREObject.
    ///
    /// ```swift
    /// let d = Date(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Date.
    /// - returns: Date?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let d = FreSwiftHelper.getAsDate(rv) {
            self.init(timeIntervalSince1970: d.timeIntervalSince1970)
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a Date into a FREObject of AS3 type Date.
    ///
    /// ```swift
    /// let fre = Date().toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

public extension Int {
    /// init: Initialise a Int from a FREObject.
    ///
    /// ```swift
    /// let myInt= Int(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type int
    /// - returns: Int?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let i = FreSwiftHelper.getAsInt(rv) {
            self.init(i)
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a Int into a FREObject of AS3 type int.
    ///
    /// ```swift
    /// let v:Int = 3
    /// let fre = v.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

public extension UInt {
    /// init: Initialise a UInt from a FREObject.
    ///
    /// ```swift
    /// let myUInt = UInt(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type uint
    /// - returns: UInt?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        if let i = FreSwiftHelper.getAsInt(rv) {
            self.init(i)
        } else {
            return nil
        }
    }
    
    /// toFREObject: Converts a UInt into a FREObject of AS3 type uint.
    ///
    /// ```swift
    /// let v:UInt = 3
    /// let fre = v.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

public extension String {
    /// init: Initialise a String from a FREObject.
    ///
    /// ```swift
    /// let myString = String(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type String
    /// - returns: String?
    
    init?(_ freObject: FREObject?) {
        guard let rv = freObject, FreSwiftHelper.getType(rv) == FreObjectTypeSwift.string else {
            return nil
        }
        if let s = FreSwiftHelper.getAsString(rv) {
            self.init(s)
        } else {
            return nil
        }
    }
    
    /// toFREObject: Converts a String into a FREObject of AS3 type String.
    ///
    /// ```swift
    /// let fre = "Hello".toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FreSwiftHelper.newObject(self)
    }
}

#if os(OSX)
    public extension NSColor {
        /// init: Initialise a NSColor from a FREObject.
        /// alpha is set as 1.0
        ///
        /// ```swift
        /// let clr = NSColor(freObject: argv[0])
        /// ```
        /// - parameter freObject: FREObject which is of AS3 type uint
        /// - returns: NSColor?
        convenience init?(_ freObject: FREObject?, hasAlpha: Bool = true) {
            guard let rv = freObject else {
                return nil
            }
            guard let fli = CGFloat(rv) else { return nil }
            let rgb = Int(fli)
            let a = hasAlpha ? (rgb >> 24) & 0xFF : 255
            let r = (rgb >> 16) & 0xFF
            let g = (rgb >> 8) & 0xFF
            let b = rgb & 0xFF
            let aFl = CGFloat(a) / 255
            let rFl = CGFloat(r) / 255
            let gFl = CGFloat(g) / 255
            let bFl = CGFloat(b) / 255
            self.init(red: rFl, green: gFl, blue: bFl, alpha: aFl)
        }
        
        func toFREObject() -> FREObject? {
            var colorAsUInt: UInt32 = 0
            colorAsUInt += UInt32(self.alphaComponent * 255.0) << 24
                + UInt32(self.redComponent * 255.0) << 16
                + UInt32(self.greenComponent * 255.0) << 8
                + UInt32(self.blueComponent * 255.0)
            return UInt(colorAsUInt).toFREObject()
        }
        
    }
#endif

#if os(iOS) || os(tvOS)
    public extension UIColor {
        /// init: Initialise a UIColor from a FREObject.
        /// alpha is set as 1.0
        ///
        /// ```swift
        /// let clr = UIColor(freObject: argv[0])
        /// ```
        /// - parameter freObject: FREObject which is of AS3 type uint
        /// - returns: UIColor?
        convenience init?(_ freObject: FREObject?, hasAlpha: Bool = true) {
            guard let rv = freObject else {
                return nil
            }
            guard let fli = CGFloat(rv) else { return nil }
            let rgb = Int(fli)
            let a = hasAlpha ? (rgb >> 24) & 0xFF : 255
            let r = (rgb >> 16) & 0xFF
            let g = (rgb >> 8) & 0xFF
            let b = rgb & 0xFF
            let aFl = CGFloat(a) / 255
            let rFl = CGFloat(r) / 255
            let gFl = CGFloat(g) / 255
            let bFl = CGFloat(b) / 255
            self.init(red: rFl, green: gFl, blue: bFl, alpha: aFl)
        }
        
        /// toFREObject: Converts a UIColor into a FREObject of AS3 type uint (ARGB).
        ///
        /// - returns: FREObject
        func toFREObject() -> FREObject? {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                var colorAsUInt: UInt32 = 0
                colorAsUInt += UInt32(alpha * 255.0) << 24
                    + UInt32(red * 255.0) << 16
                    + UInt32(green * 255.0) << 8
                    + UInt32(blue * 255.0)
                return UInt(colorAsUInt).toFREObject()
            }
            return nil
        }
        
    }
#endif

public extension Dictionary where Key == String, Value == Any {
    /// init: Initialise a Dictionary<String, Any> from a FREObjects.
    ///
    /// ```swift
    /// let dictionary:[String: Any]? = Dictionary(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        if let val: [String: Any] = FreSwiftHelper.getAsDictionary(rv) {
            self = val
        }
    }
}

public extension Dictionary where Key == String, Value == AnyObject {
    /// init: Initialise a Dictionary<String, AnyObject> from a FREObject.
    ///
    /// ```swift
    /// let dictionary:[String: AnyObject]? = Dictionary(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        if let val: [String: AnyObject] = FreSwiftHelper.getAsDictionary(rv) {
            self = val
        }
    }
}

public extension Dictionary where Key == String, Value == NSObject {
    /// init: Initialise a Dictionary<String, NSObject> from a FREObject.
    ///
    /// ```swift
    /// let dictionary:[String: NSObject]? = Dictionary(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        if let val: [String: NSObject] = FreSwiftHelper.getAsDictionary(rv) {
            self = val
        }
    }
}
