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

public protocol FreSwiftMainController {
    var functionsToSet: FREFunctionMap { get set }
    var context: FreContextSwift! { get set }
    var TAG: String? { get set }
    func getFunctions(prefix: String) -> Array<String>
    func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject?
}

public extension FreSwiftMainController {
    func trace(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: traceStr)
    }

    func info(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: "INFO: \(traceStr)")
    }

    func warning(_ value: Any...) {
        var traceStr: String = "\(self.TAG ?? ""):"
        for i in 0..<value.count {
            traceStr = "\(traceStr) \(value[i]) "
        }
        sendEvent(name: "TRACE", value: "WARNING: \(traceStr)")
    }

    func sendEvent(name: String, value: String) {
        autoreleasepool {
            do {
                try context.dispatchStatusEventAsync(code: value, level: name)
            } catch {
            }
        }
    }
}

public protocol FreSwiftController {
    var context: FreContextSwift! { get set }
    var TAG: String? { get set }
}

public extension FreSwiftController {
    func trace(_ value: Any...) {
        var traceStr: String = ""
        for i in 0..<value.count {
            traceStr = traceStr + "\(value[i])" + " "
        }
        sendEvent(name: "TRACE", value: traceStr)
    }

    func sendEvent(name: String, value: String) {
        autoreleasepool {
            do {
                try context.dispatchStatusEventAsync(code: value, level: name)
            } catch {
            }
        }
    }
}

//****** Extensions *****//

public extension FREObject {
    func getProp(name: String) throws -> FREObject? {
        if let ret = try FreSwiftHelper.getProperty(rawValue: self, name: name) {
            return ret
        }
        return nil
    }

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

    init?(className: String, args: Any...) throws {
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

    init?(className: String) throws {
        if let rv = try FreSwiftHelper.newObject(className: className) {
            self.init(rv)
        } else {
            return nil
        }
    }

    func call(method: String, args: Any...) throws -> FREObject? {
        return try FreSwiftHelper.callMethod(self, name: method, args: args)
    }

    var type: FreObjectTypeSwift {
        get {
            return FreSwiftHelper.getType(self)
        }
    }

}

public class FREArray: NSObject {
    public var rawValue: FREObject? = nil

    public init(_ freObject: FREObject) {
        rawValue = freObject
    }

    public init(className: String, args: Any...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        rawValue = try FreSwiftHelper.newObject(className: className, argsArray)
    }

    public init(intArray: Array<Int>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = intArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(int: intArray[i]))
        }
    }

    public init(stringArray: Array<String>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = stringArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(string: stringArray[i]))
        }
    }

    public init(doubleArray: Array<Double>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = doubleArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(double: doubleArray[i]))
        }
    }

    public init(boolArray: Array<Bool>) throws {
        super.init()
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = boolArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(bool: boolArray[i]))
        }
    }

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

    public func set(index: UInt, value: Any) throws {
        try set(index: index, object: FreObjectSwift.init(any: value))
    }


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

    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(double: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Float {
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

    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(cgFloat: CGFloat.init(self)).rawValue
        } catch {
        }
        return nil
    }

}

public extension CGFloat {
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

    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(cgFloat: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Bool {
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

    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(bool: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Date {
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
    /// Converts Date into a FREObject.
    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(date: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Int {
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
    /// Converts Int into a FREObject.
    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(int: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension UInt {
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

    /// Converts UInt into a FREObject.
    func toFREObject() -> FREObject? {
        do {
            return try FreObjectSwift(uint: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension String {
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

    /// Converts String into a FREObject.
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
}

public extension UIColor {
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


public extension Dictionary where Key == String, Value == AnyObject {
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
