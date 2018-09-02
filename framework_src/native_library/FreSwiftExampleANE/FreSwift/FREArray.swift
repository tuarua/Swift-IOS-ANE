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

/// FREArray: Additional type which matches Java version of FRE
public class FREArray: Sequence {
    /// iterator for FREArray
    ///
    /// ```swift
    /// for fre in airArray {
    /// 
    /// }
    /// ```
    public func makeIterator() -> Array<FREObject>.Iterator {
        var items = [FREObject]()
        for i in 0..<self.length {
            if let item = self.at(index: i) {
                items.append(item)
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
    
    /// init: Initialise a FREArray containing a Vector of type specified by className.
    ///
    /// ```swift
    /// let newPerson = try FREArray(className: "com.tuarua.Person", length: 5, fixed: true)
    /// ```
    ///
    /// - parameter className: name of AS3 class to create
    /// - parameter length: number of elements in the array
    /// - parameter fixed: whether the array is fixed
    public init(className: String, length: Int = 0, fixed: Bool = false) {
        let argsArray: NSPointerArray = NSPointerArray(options: .opaqueMemory)
        argsArray.addPointer(length.toFREObject())
        argsArray.addPointer(fixed.toFREObject())
        rawValue = FreSwiftHelper.newObject(className: "Vector.<\(className)>", argsArray)
    }
    
    /// init: Initialise a FREArray with a [Int].
    ///
    /// - parameter intArray: array to be converted
    public init(intArray: [Int]) {
        rawValue = FreSwiftHelper.newObject(className: "Array")
        for v in intArray {
            self.push(v)
        }
    }
    
    /// init: Initialise a FREArray with a [UInt].
    ///
    /// - parameter intArray: array to be converted
    public init(uintArray: [UInt]) {
        rawValue = FreSwiftHelper.newObject(className: "Array")
        for v in uintArray {
            self.push(v)
        }
    }
    
    /// init: Initialise a FREArray with a [String].
    ///
    /// - parameter stringArray: array to be converted
    public init(stringArray: [String]) {
        rawValue = FreSwiftHelper.newObject(className: "Array")
        for v in stringArray {
            self.push(v)
        }
    }
    
    /// init: Initialise a FREArray with a [Double].
    ///
    /// - parameter doubleArray: array to be converted
    public init(doubleArray: [Double]) {
        rawValue = FreSwiftHelper.newObject(className: "Array")
        for v in doubleArray {
            self.push(v)
        }
    }
    
    /// init: Initialise a FREArray with a [Bool].
    ///
    /// - parameter boolArray: array to be converted
    public init(boolArray: [Bool]) {
        rawValue = FreSwiftHelper.newObject(className: "Array")
        for v in boolArray {
            self.push(v)
        }
    }
    
    /// init: Initialise a FREArray with a [Any].
    ///
    /// - parameter anyArray: array to be converted
    public init(anyArray: [Any]) {
        rawValue = FreSwiftHelper.newObject(className: "Array")
        let count = anyArray.count
        for i in 0..<count {
            set(index: UInt(i), freObject: FreSwiftHelper.newObject(any: anyArray[i]))
        }
    }
    
    /// at: Returns FREObject at position index
    ///
    /// - parameter index:
    /// - returns: FREObject?
    fileprivate func at(index: UInt) -> FREObject? {
        guard let rv = rawValue else { return nil }
        var ret: FREObject?
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: &ret)
#else
        let status: FREResult = FREGetArrayElementAt(rv, UInt32(index), &ret)
#endif
        
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared().log(message: "cannot get item at \(index)",
            type: FreSwiftHelper.getErrorCode(status),
            line: #line, column: #column, file: #file)
        return nil
    }
    
    fileprivate func set(index: UInt, freObject: FREObject?) {
        guard let rv = rawValue else { return }
        #if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: freObject)
        #else
        let status: FREResult = FRESetArrayElementAt(rv, UInt32(index), freObject)
        #endif
        
        if FRE_OK == status { return }
        FreSwiftLogger.shared().log(message: "cannot set item at \(index)",
            type: FreSwiftHelper.getErrorCode(status),
            line: #line, column: #column, file: #file)
    }
    
    /// set: Sets FREObject at position index
    ///
    /// - parameter index: index of item
    /// - parameter value: value to set
    /// - returns: FREObject?
    public func set(index: UInt, value: Any) {
        set(index: index, freObject: FreSwiftHelper.newObject(any: value))
    }
    
    /// push: Adds one or more elements to the end of an array and returns the new length of the array.
    ///
    /// - parameter args: One or more values to append to the array.
    public func push(_ args: Any?...) {
        _ = FreSwiftHelper.callMethod(self.rawValue, name: "push", args: args)
    }
    
    /// length: length of FREArray
    public var length: UInt {
        guard let rv = rawValue else { return 0 }
        var ret: UInt32 = 0
#if os(iOS) || os(tvOS)
        let status: FREResult = FreSwiftBridge.bridge.FREGetArrayLength(arrayOrVector: rv, length: &ret)
#else
        let status: FREResult = FREGetArrayLength(rv, &ret)
#endif
        if FRE_OK == status { return UInt(ret) }
        FreSwiftLogger.shared().log(message: "cannot get length of array",
            type: FreSwiftHelper.getErrorCode(status),
            line: #line, column: #column, file: #file)
        return 0
    }
    
    /// value: Converts FREArray to Swift array
    /// - returns: [Any?]
    public var value: [Any?] {
        var ret: [Any?] = []
        for i in 0..<length {
            let elem: FreObjectSwift = FreObjectSwift(at(index: i))
            ret.append(elem.value)
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
            return self.at(index: index)
        }
        set {
            if let rv = newValue {
                self.set(index: index, freObject: rv)
            }
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
        if let val: [Any] = FreSwiftHelper.getAsArray(rv) {
            self = val
        }
    }
    /// toFREObject: Converts an Any Array into a FREObject of AS3 type Array.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(anyArray: self).rawValue
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
        if let val: [Double] = FreSwiftHelper.getAsArray(rv) {
            self = val
        }
    }
    
    /// init: Initialise a [Double] from a FREArray.
    ///
    /// ```swift
    /// let array = [Double](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type Vector.<Number>
    /// - returns: [Double]?
    init?(_ freArray: FREArray) {
        self.init(freArray.rawValue)
    }
    
    /// toFREObject: Converts a Double Array into a FREObject of AS3 type Vector.<Number>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(doubleArray: self).rawValue
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
        if let val: [Bool] = FreSwiftHelper.getAsArray(rv) {
            self = val
        }
    }
    
    /// init: Initialise a [Bool] from a FREArray.
    ///
    /// ```swift
    /// let array = [Bool](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type Vector.<Boolean>
    /// - returns: [Bool]?
    init?(_ freArray: FREArray) {
        self.init(freArray.rawValue)
    }
    
    /// toFREObject: Converts a Bool Array into a FREObject of AS3 type Vector.<Boolean>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(boolArray: self).rawValue
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
        if let val: [UInt] = FreSwiftHelper.getAsArray(rv) {
            self = val
        }
    }
    
    /// init: Initialise a [UInt] from a FREArray.
    ///
    /// ```swift
    /// let array = [UInt](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type Vector.<UInt>
    /// - returns: [UInt]?
    init?(_ freArray: FREArray) {
        self.init(freArray.rawValue)
    }
    
    /// toFREObject: Converts an Int Array into a FREObject of AS3 type Vector.<int>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(uintArray: self).rawValue
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
        if let val: [Int] = FreSwiftHelper.getAsArray(rv) {
            self = val
        }
    }
    
    /// init: Initialise a [Int] from a FREArray.
    ///
    /// ```swift
    /// let array = [Int](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type Vector.<Int>
    /// - returns: [Int]?
    init?(_ freArray: FREArray) {
        self.init(freArray.rawValue)
    }
    
    /// toFREObject: Converts an Int Array into a FREObject of AS3 type Vector.<int>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(intArray: self).rawValue
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
        if let val: [String] = FreSwiftHelper.getAsArray(rv) {
            self = val
        }
    }
    /// init: Initialise a [String] from a FREArray.
    ///
    /// ```swift
    /// let array = [String](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type Vector.<String>
    /// - returns: [String]?
    init?(_ freArray: FREArray) {
        self.init(freArray.rawValue)
    }
    
    /// toFREObject: Converts an String Array into a FREObject of AS3 type Vector.<String>.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(stringArray: self).rawValue
    }
}
