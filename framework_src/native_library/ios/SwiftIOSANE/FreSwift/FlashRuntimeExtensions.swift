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

public typealias FREArgv = UnsafeMutablePointer<FREObject?>!
public typealias FREArgc = UInt32
public typealias FREFunctionMap = [String: (_: FREContext, _: FREArgc, _: FREArgv) -> FREObject?]

/// FreSwiftMainController: Out SwiftController extends this Protocol.
public protocol FreSwiftMainController {
    /// Map of functions to connect Objective C to Swift
    var functionsToSet: FREFunctionMap { get set }
    /// FREContext
    var context: FreContextSwift! { get set }
    /// Tag used when tracing logs
    var TAG: String? { get set }
    /// Returns functions which connect Objective C to Swift
    func getFunctions(prefix: String) -> Array<String>
    /// Allows Objective C to call our Swift Controller
    func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject?
    /// Called by Objective C when ANE is loaded into memory
    /// ```swift
    /// @objc func applicationDidFinishLaunching(_ notification: Notification) {
    ///     appDidFinishLaunchingNotif = notification
    /// }
    ///
    /// public func onLoad() {
    ///    NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
    ///                                           name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
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
    /// - parameter value:
    /// - returns: Void
    func trace(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: traceStr)
    }

    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [INFO]
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value:
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: "INFO: \(traceStr)")
    }
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [WARNING]
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value:
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: "WARNING: \(traceStr)")
    }

    /// sendEvent: sends StatusEvent to our swc with a level of name and code of value
    /// replaces DispatchStatusEventAsync
    ///
    /// ```swift
    /// sendEvent("MY_EVENT", "ok")
    /// ```
    /// - parameter name: name of event
    /// - parameter value: value passed with event
    /// - returns: Void
    func sendEvent(name: String, value: String) {
        autoreleasepool {
            do {
                try context.dispatchStatusEventAsync(code: value, level: name)
            } catch {
            }
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
    /// - parameter value:
    /// - returns: Void
    func trace(_ value: Any...) {
        var traceStr: String = ""
        for i in 0..<value.count {
            traceStr = traceStr + "\(value[i])" + " "
        }
        sendEvent(name: "TRACE", value: traceStr)
    }
    
    /// info: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [INFO]
    ///
    /// ```swift
    /// info("Hello")
    /// ```
    /// - parameter value:
    /// - returns: Void
    func info(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: "INFO: \(traceStr)")
    }
    
    /// warning: sends StatusEvent to our swc with a level of "TRACE"
    /// The output string is prefixed with [WARNING]
    ///
    /// ```swift
    /// warning("Hello")
    /// ```
    /// - parameter value:
    /// - returns: Void
    func warning(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: "WARNING: \(traceStr)")
    }

    /// sendEvent: sends StatusEvent to our swc with a level of name and code of value
    /// replaces DispatchStatusEventAsync
    ///
    /// ```swift
    /// sendEvent("MY_EVENT", "ok")
    /// ```
    /// - parameter name: name of event
    /// - parameter value: value passed with event
    /// - returns: Void
    func sendEvent(name: String, value: String) {
        autoreleasepool {
            do {
                try context.dispatchStatusEventAsync(code: value, level: name)
            } catch {
            }
        }
    }
}

/// FREObject: Extends FREObject with Swift syntax.
public extension FREObject {
    /// getProp: returns the Property of a FREObject.
    ///
    /// ```swift
    /// let myName = argv[0].getProp("name")
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: FREObject?
    func getProp(name: String) throws -> FREObject? {
        if let ret = try FreSwiftHelper.getProperty(rawValue: self, name: name) {
            return ret
        }
        return nil
    }

    /// setProp: sets the Property of a FREObject.
    /// - throws: Can throw a `FreError` on fail
    /// - returns: Void
    func setProp(name: String, value: Any?) throws {
        if value is FREObject {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: value as? FREObject)
        } else if value is FREArray {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! FREArray).rawValue)
        } else if value is FreObjectSwift {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! FreObjectSwift).rawValue)
        } else if value is String {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! String).toFREObject())
        } else if value is Int {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! Int).toFREObject())
        } else if value is Int32 {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! Int).toFREObject())
        } else if value is UInt {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! UInt).toFREObject())
        } else if value is UInt32 {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! UInt).toFREObject())
        } else if value is Double {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! Double).toFREObject())
        } else if value is CGFloat {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! CGFloat).toFREObject())
        } else if value is Bool {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! Bool).toFREObject())
        } else if value is Date {
            try FreSwiftHelper.setProperty(rawValue: self, name: name, prop: (value as! Date).toFREObject())
        }
    }

    /// init: Creates a new FREObject.
    ///
    /// ```swift
    /// let newPerson = try FREObject(className: "com.tuarua.Person", args: 1, true, "Free")
    /// ```
    /// - parameter className: name of AS3 class to create
    /// - parameter args: arguments to use. These are automatically converted to FREObjects
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    init?(className: String, args: Any?...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        if let rv = try FreSwiftHelper.newObject(className: className, argsArray) {
            self.init(rv)
        } else {
            return nil
        }
    }

    /// init: Creates a new FREObject.
    ///
    /// ```swift
    /// let newPerson = try FREObject(className: "com.tuarua.Person")
    /// ```
    /// - parameter className: name of AS3 class to create
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    init?(className: String) throws {
        if let rv = try FreSwiftHelper.newObject(className: className) {
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
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    func call(method: String, args: Any...) throws -> FREObject? {
        return try FreSwiftHelper.callMethod(self, name: method, args: args)
    }

    /// returns the type of the FREOject
    var type: FreObjectTypeSwift {
        get {
            return FreSwiftHelper.getType(self)
        }
    }

}

/// FREArray: Additional type which matches Java version of FRE
public class FREArray: NSObject {
    /// raw FREObject value
    public var rawValue: FREObject? = nil

    /// init: Initialise a FREArray from a FREObject.
    ///
    /// - parameter freObject: FREObject which is of AS3 type Array
    public init(_ freObject: FREObject) {
        rawValue = freObject
    }

    /// init: Initialise a FREArray of type specified by className.
    ///
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    public init(className: String, args: Any...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        rawValue = try FreSwiftHelper.newObject(className: className, argsArray)
    }

    /// init: Initialise a FREArray with a Array<Int>.
    ///
    /// - parameter intArray: array to be converted
    public init(intArray: Array<Int>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = intArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(int: intArray[i]))
        }
    }

    /// init: Initialise a FREArray with a Array<String>.
    ///
    /// - parameter stringArray: array to be converted
    public init(stringArray: Array<String>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = stringArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(string: stringArray[i]))
        }
    }

    /// init: Initialise a FREArray with a Array<Double>.
    ///
    /// - parameter doubleArray: array to be converted
    public init(doubleArray: Array<Double>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = doubleArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(double: doubleArray[i]))
        }
    }

    /// init: Initialise a FREArray with a Array<Bool>.
    ///
    /// - parameter boolArray: array to be converted
    public init(boolArray: Array<Bool>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = boolArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(bool: boolArray[i]))
        }
    }
    
    /// init: Initialise a FREArray with a Array<Any>.
    ///
    /// - parameter anyArray: array to be converted
    public init(anyArray: Array<Any>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = anyArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(any: anyArray[i]))
        }
    }

    /// at: Returns FREObject at position index
    ///
    /// - parameter index:
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    public func at(index: UInt) throws -> FREObject? {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
        var object: FREObject?
#if os(iOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetArrayElementA(arrayOrVector: rv, index: UInt32(index),
          value: &object)
#else
        let status: FREResult = FREGetArrayElementAt(rv, UInt32(index), &object)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get object at \(index) ", type: FreSwiftHelper.getErrorCode(status),
              line: #line, column: #column, file: #file)
        }
        return object
    }

    fileprivate func set(index: UInt, object: FreObjectSwift) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
              line: #line, column: #column, file: #file)
        }
#if os(iOS)
        let status: FREResult = FreSwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: rv, index: UInt32(index),
          value: object.rawValue)
#else
        let status: FREResult = FRESetArrayElementAt(rv, UInt32(index), object.rawValue)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot set object at \(index) ", type: FreSwiftHelper.getErrorCode(status),
              line: #line, column: #column, file: #file)
        }
    }

    /// set: Sets FREObject at position index
    ///
    /// - parameter index:
    /// - parameter value:
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    public func set(index: UInt, value: Any) throws {
        try set(index: index, object: FreObjectSwift.init(any: value))
    }

    /// length: length of FREArray
    public var length: UInt {
        get {
            guard let rv = rawValue else {
                return 0
            }
            do {
                var ret: UInt32 = 0
#if os(iOS)
                let status: FREResult = FreSwiftBridge.bridge.FREGetArrayLength(arrayOrVector: rv, length: &ret)
#else
                let status: FREResult = FREGetArrayLength(rv, &ret)
#endif
                guard FRE_OK == status else {
                    throw FreError(stackTrace: "", message: "cannot get length of array", type: FreSwiftHelper.getErrorCode(status),
                      line: #line, column: #column, file: #file)
                }
                return UInt(ret)

            } catch {
            }
            return 0
        }
    }

    /// value: Converts FREArray to Swift array
    /// - returns: Array<Any?>
    public var value: Array<Any?> {
        get {
            var ret: [Any?] = []
            do {
                for i in 0..<length {
                    let elem: FreObjectSwift = try FreObjectSwift.init(freObject: at(index: i))
                    ret.append(elem.value)
                }
            } catch {
            }
            return ret
        }
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
        }
        let freObjectSwift: FreObjectSwift = FreObjectSwift.init(freObject: rv)
        if let i = freObjectSwift.value as? Int {
            self.init(i)
        } else if let d = freObjectSwift.value as? Double {
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
        do {
            return try FreObjectSwift(double: self).rawValue
        } catch {
        }
        return nil
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
        if let d = Double(rv) {
            self.init(Float(d))
        } else {
            return nil
        }
    }
    /// toFREObject: Converts a Float into a FREObject of AS3 type Number.
    ///
    /// ```swift
    // let myFloat = Float.init()
    /// let fre = myFloat.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(cgFloat: CGFloat.init(self)).rawValue
        } catch {
        }
        return nil
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
        if let d = Double(rv) {
            self.init(d)
        } else {
            return nil
        }

    }
    /// toFREObject: Converts a CGFloat into a FREObject of AS3 type Number.
    ///
    /// ```swift
    // let myCGFloat = CGFloat.init()
    /// let fre = myCGFloat.toFREObject()
    /// ```
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(cgFloat: self).rawValue
        } catch {
        }
        return nil
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
        if let b = FreObjectSwift.init(freObject: rv).value as? Bool {
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
        do {
            return try FreObjectSwift(bool: self).rawValue
        } catch {
        }
        return nil
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
        if let d = FreObjectSwift.init(freObject: rv).value as? Date {
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
        do {
            return try FreObjectSwift(date: self).rawValue
        } catch {
        }
        return nil
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
        if let i = FreObjectSwift.init(freObject: rv).value as? Int {
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
        do {
            return try FreObjectSwift(int: self).rawValue
        } catch {
        }
        return nil
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
        if let i = FreObjectSwift.init(freObject: rv).value as? Int {
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
        do {
            return try FreObjectSwift(uint: self).rawValue
        } catch {
        }
        return nil
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
        if let s = FreObjectSwift.init(freObject: rv).value as? String {
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
        do {
            return try FreObjectSwift(string: self).rawValue
        } catch {
        }
        return nil
    }
}

#if os(iOS)
public extension UIColor {
    /// init: Initialise a UIColor from 2 FREObjects.
    ///
    /// ```swift
    /// let clr = UIColor(freObject: argv[0], alpha: argv[1])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type uint
    /// - parameter alpha: FREObject which is of AS3 type Number
    /// - returns: UIColor?
    convenience init(freObject: FREObject?, alpha: FREObject?) {
        guard let rv = freObject, let rv2 = alpha else {
            self.init()
            return
        }
        do {
            let rgb = try FreSwiftHelper.getAsUInt(rv);
            let r = (rgb >> 16) & 0xFF
            let g = (rgb >> 8) & 0xFF
            let b = rgb & 0xFF
            var a: CGFloat = CGFloat.init(1)
            let aFre = FreObjectSwift.init(freObject: rv2)
            if let alphaInt = aFre.value as? Int, alphaInt == 0 {
                self.init(white: 1.0, alpha: 0.0)
            } else {
                if let alphaD = aFre.value as? Double {
                    a = CGFloat.init(alphaD)
                }
                let rFl: CGFloat = CGFloat.init(r) / 255
                let gFl: CGFloat = CGFloat.init(g) / 255
                let bFl: CGFloat = CGFloat.init(b) / 255
                self.init(red: rFl, green: gFl, blue: bFl, alpha: a)
            }
        } catch {
            self.init()
        }
    }
    /// init: Initialise a UIColor from a FREObject.
    /// alpha is set as 1.0
    ///
    /// ```swift
    /// let clr = UIColor(freObject: argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type uint
    /// - returns: UIColor?
    convenience init(freObject: FREObject?) {
        guard let rv = freObject else {
            self.init()
            return
        }
        do {
            let rgb = try FreSwiftHelper.getAsUInt(rv);
            let r = (rgb >> 16) & 0xFF
            let g = (rgb >> 8) & 0xFF
            let b = rgb & 0xFF
            let a: CGFloat = CGFloat.init(1)
            let rFl: CGFloat = CGFloat.init(r) / 255
            let gFl: CGFloat = CGFloat.init(g) / 255
            let bFl: CGFloat = CGFloat.init(b) / 255
            self.init(red: rFl, green: gFl, blue: bFl, alpha: a)
        } catch {
            self.init()
        }
    }
}
#endif

public extension Dictionary where Key == String, Value == Any {
    /// init: Initialise a Dictionary<String, Any> from a FREObjects.
    ///
    /// ```swift
    /// let dictionary:Dictionary<String, Any>? = Dictionary.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Dictionary<String, Any> = try FreSwiftHelper.getAsDictionary(rv) {
                self = val
            }
        } catch {
            return
        }
        
    }
}

public extension Dictionary where Key == String, Value == AnyObject {
    /// init: Initialise a Dictionary<String, AnyObject> from a FREObject.
    ///
    /// ```swift
    /// let dictionary:Dictionary<String, AnyObject>? = Dictionary.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Dictionary<String, AnyObject> = try FreSwiftHelper.getAsDictionary(rv) {
                self = val
            }
        } catch {
            return
        }

    }
}

public extension Dictionary where Key == String, Value == NSObject {
    /// init: Initialise a Dictionary<String, NSObject> from a FREObject.
    ///
    /// ```swift
    /// let dictionary:Dictionary<String, NSObject>? = Dictionary.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Object or a Class
    /// - returns: Dictionary?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Dictionary<String, NSObject> = try FreSwiftHelper.getAsDictionary(rv) {
                self = val
            }
        } catch {
            return
        }
        
    }
}

public extension Array where Element == String {
    /// init: Initialise a Array<String> from a FREObject.
    ///
    /// ```swift
    /// let array = Array<String>.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<String>
    /// - returns: Array<String>?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Array<String> = try FreSwiftHelper.getAsArray(rv) {
                self = val
            }
        } catch {
            return
        }
    }
    /// toFREObject: Converts an String Array into a FREObject of AS3 type Vector.<String>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FREArray.init(stringArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == Int {
    /// init: Initialise a Array<Int> from a FREObject.
    ///
    /// ```swift
    /// let array = Array<Int>.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<Int>
    /// - returns: Array<Int>?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Array<Int> = try FreSwiftHelper.getAsArray(rv) {
                self = val
            }
        } catch {
            return
        }
    }
    /// toFREObject: Converts an Int Array into a FREObject of AS3 type Vector.<int>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FREArray.init(intArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == Bool {
    /// init: Initialise a Array<Bool> from a FREObject.
    ///
    /// ```swift
    /// let array = Array<Bool>.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<Boolean>
    /// - returns: Array<Bool>?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Array<Bool> = try FreSwiftHelper.getAsArray(rv) {
                self = val
            }
        } catch {
            return
        }
    }
    /// toFREObject: Converts a Bool Array into a FREObject of AS3 type Vector.<Boolean>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FREArray.init(boolArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == Double {
    /// init: Initialise a Array<Double> from a FREObject.
    ///
    /// ```swift
    /// let array = Array<Double>.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<Number>
    /// - returns: Array<Double>?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Array<Double> = try FreSwiftHelper.getAsArray(rv) {
                self = val
            }
        } catch {
            return
        }
    }
    /// toFREObject: Converts a Double Array into a FREObject of AS3 type Vector.<Number>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FREArray.init(doubleArray: self).rawValue
        } catch {
        }
        return nil
    }
}


public extension Array where Element == Any {
    /// init: Initialise a Array<Any> from a FREObject.
    ///
    /// ```swift
    /// let array = Array<Any>.init(argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Array
    /// - returns: Array<Any>?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: Array<Any> = try FreSwiftHelper.getAsArray(rv) {
                self = val
            }
        } catch {
            return
        }
    }
    /// toFREObject: Converts an Any Array into a FREObject of AS3 type Array.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        do {
            return try FREArray.init(anyArray: self).rawValue
        } catch {
        }
        return nil
    }
}


