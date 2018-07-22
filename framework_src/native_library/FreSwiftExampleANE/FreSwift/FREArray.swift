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

/// FREArray: Additional type which matches Java version of FRE
public class FREArray: Sequence {
    /// iterator for FREArray
    public func makeIterator() -> Array<FREObject>.Iterator {
        var items = [FREObject]()
        for i in 0..<self.length {
            if let item = try? self.at(index: i), let t = item {
                items.append(t)
            }
        }
        return items.makeIterator()
    }
    
    /// raw FREObject value
    public var rawValue: FREObject?
    
    /// init: Initialise a FREArray from a FREObject.
    ///
    /// - parameter freObject: FREObject which is of AS3 type Array
    public init(_ freObject: FREObject) {
        rawValue = freObject
    }
    
    /// init: Initialise a FREArray of type specified by className.
    ///
    /// - parameter className: name of AS3 class to create
    /// - parameter args: arguments to pass to the method
    /// - throws: Can throw a `FreError` on fail
    @available(*, deprecated, renamed: "FREArray()", message: "Use the newer FREArray(className: String, length: Int, fixed: Bool)")
    public init(className: String, args: Any...) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        for i in 0..<args.count {
            let arg: FREObject? = try FreObjectSwift.init(any: args[i]).rawValue
            argsArray.addPointer(arg)
        }
        rawValue = try FreSwiftHelper.newObject(className: className, argsArray)
    }
    
    /// init: Initialise a FREArray containing a Vector of type specified by className.
    ///
    /// ```swift
    /// let newPerson = try FREArray(className: "com.tuarua.Person", length: 5, fixed: true)
    /// ```
    ///
    /// - parameter className: name of AS3 class to create
    /// - parameter length: number of elements in the array
    /// - parameter fixed: whether the array is fixed
    /// - throws: Can throw a `FreError` on fail
    public init(className: String, length: Int = 0, fixed: Bool = false) throws {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        argsArray.addPointer(length.toFREObject())
        argsArray.addPointer(fixed.toFREObject())
        rawValue = try FreSwiftHelper.newObject(className: "Vector.<\(className)>", argsArray)
    }
    
    /// init: Initialise a FREArray with a [Int].
    ///
    /// - parameter intArray: array to be converted
    /// - throws: Can throw a `FreError` on fail
    public init(intArray: [Int]) throws {
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = intArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(int: intArray[i]))
        }
    }
    
    /// init: Initialise a FREArray with a [UInt].
    ///
    /// - parameter intArray: array to be converted
    /// - throws: Can throw a `FreError` on fail
    public init(uintArray: [UInt]) throws {
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = uintArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(uint: uintArray[i]))
        }
    }
    
    /// init: Initialise a FREArray with a [String].
    ///
    /// - parameter stringArray: array to be converted
    /// - throws: Can throw a `FreError` on fail
    public init(stringArray: [String]) throws {
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = stringArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(string: stringArray[i]))
        }
    }
    
    /// init: Initialise a FREArray with a [Double].
    ///
    /// - parameter doubleArray: array to be converted
    /// - throws: Can throw a `FreError` on fail
    public init(doubleArray: [Double]) throws {
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = doubleArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(double: doubleArray[i]))
        }
    }
    
    /// init: Initialise a FREArray with a [Bool].
    ///
    /// - parameter boolArray: array to be converted
    /// - throws: Can throw a `FreError` on fail
    public init(boolArray: [Bool]) throws {
        rawValue = try FreSwiftHelper.newObject(className: "Array")
        let count = boolArray.count
        for i in 0..<count {
            try set(index: UInt(i), object: FreObjectSwift.init(bool: boolArray[i]))
        }
    }
    
    /// init: Initialise a FREArray with a [Any].
    ///
    /// - parameter anyArray: array to be converted
    /// - throws: Can throw a `FreError` on fail
    public init(anyArray: [Any]) throws {
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
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: &object)
#else
        let status: FREResult = FREGetArrayElementAt(rv, UInt32(index), &object)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot get object at \(index) ",
                type: FreSwiftHelper.getErrorCode(status),
                line: #line, column: #column, file: #file)
        }
        return object
    }
    
    fileprivate func set(index: UInt, object: FreObjectSwift) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: object.rawValue)
#else
        let status: FREResult = FRESetArrayElementAt(rv, UInt32(index), object.rawValue)
#endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot set object at \(index) ",
                type: FreSwiftHelper.getErrorCode(status),
                line: #line, column: #column, file: #file)
        }
    }
    
    fileprivate func set(index: UInt, freObject: FREObject) throws {
        guard let rv = rawValue else {
            throw FreError(stackTrace: "", message: "FREObject is nil", type: FreError.Code.invalidObject,
                           line: #line, column: #column, file: #file)
        }
        #if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: freObject)
        #else
        let status: FREResult = FRESetArrayElementAt(rv, UInt32(index), freObject)
        #endif
        guard FRE_OK == status else {
            throw FreError(stackTrace: "", message: "cannot set object at \(index) ",
                type: FreSwiftHelper.getErrorCode(status),
                line: #line, column: #column, file: #file)
        }
    }
    
    /// set: Sets FREObject at position index
    ///
    /// - parameter index: index of item
    /// - parameter value: value to set
    /// - throws: Can throw a `FreError` on fail
    /// - returns: FREObject?
    public func set(index: UInt, value: Any) throws {
        try set(index: index, object: FreObjectSwift.init(any: value))
    }
    
    /// length: length of FREArray
    public var length: UInt {
        guard let rv = rawValue else {
            return 0
        }
        do {
            var ret: UInt32 = 0
#if os(iOS) || os(tvOS)
            let status: FREResult = FreSwiftBridge.bridge.FREGetArrayLength(arrayOrVector: rv, length: &ret)
#else
            let status: FREResult = FREGetArrayLength(rv, &ret)
#endif
            guard FRE_OK == status else {
                throw FreError(stackTrace: "", message: "cannot get length of array",
                               type: FreSwiftHelper.getErrorCode(status),
                               line: #line, column: #column, file: #file)
            }
            return UInt(ret)
            
        } catch {
        }
        return 0
    }
    
    /// value: Converts FREArray to Swift array
    /// - returns: [Any?]
    public var value: [Any?] {
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

public extension FREArray {
    /// accessor: gets/sets FREObject at position index
    ///
    /// - parameter index:
    /// - returns: FREObject?
    subscript(index: UInt) -> FREObject? {
        get {
            if let ret = try? self.at(index: index) {
                return ret
            }
            return nil
        }
        set {
            do {
                if let rv = newValue {
                    try self.set(index: index, freObject: rv)
                }
            } catch { }
        }
    }
}

public extension Array where Element == Any {
    /// init: Initialise a [Any] from a FREObject.
    ///
    /// ```swift
    /// let array = [Any](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Array
    /// - returns: [Any]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: [Any] = try FreSwiftHelper.getAsArray(rv) {
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
            return try FREArray(anyArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == Double {
    /// init: Initialise a [Double] from a FREObject.
    ///
    /// ```swift
    /// let array = [Double](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<Number>
    /// - returns: [Double]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: [Double] = try FreSwiftHelper.getAsArray(rv) {
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
            return try FREArray(doubleArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == Bool {
    /// init: Initialise a [Bool] from a FREObject.
    ///
    /// ```swift
    /// let array = [Bool](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<Boolean>
    /// - returns: [Bool]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: [Bool] = try FreSwiftHelper.getAsArray(rv) {
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
            return try FREArray(boolArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == UInt {
    /// init: Initialise a [UInt] from a FREObject.
    ///
    /// ```swift
    /// let array = [UInt](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<UInt>
    /// - returns: [UInt]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: [UInt] = try FreSwiftHelper.getAsArray(rv) {
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
            return try FREArray(uintArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == Int {
    /// init: Initialise a [Int] from a FREObject.
    ///
    /// ```swift
    /// let array = [Int](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<Int>
    /// - returns: [Int]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: [Int] = try FreSwiftHelper.getAsArray(rv) {
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
            return try FREArray(intArray: self).rawValue
        } catch {
        }
        return nil
    }
}

public extension Array where Element == String {
    /// init: Initialise a [String] from a FREObject.
    ///
    /// ```swift
    /// let array = [String](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type Vector.<String>
    /// - returns: [String]?
    init?(_ freObject: FREObject?) {
        self.init()
        guard let rv = freObject else {
            return
        }
        do {
            if let val: [String] = try FreSwiftHelper.getAsArray(rv) {
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
            return try FREArray(stringArray: self).rawValue
        } catch {
        }
        return nil
    }
}
