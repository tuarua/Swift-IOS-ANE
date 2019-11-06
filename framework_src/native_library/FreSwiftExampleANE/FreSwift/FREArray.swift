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

/// FREArray: Additional type which matches Java version of FRE
open class FREArray: Sequence {
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
    /// let newPerson = FREArray(className: "com.tuarua.Person", length: 5, fixed: true)
    /// ```
    ///
    /// - parameter className: name of AS3 class to create
    /// - parameter length: number of elements in the array
    /// - parameter fixed: whether the array is fixed
    /// - parameter items: populates the FREArray with the supplied Array of FREObjects
    public init?(className: String, length: Int = 0, fixed: Bool = false, items: [FREObject?]? = nil) {
        create(className: className, length: length, fixed: fixed, items: items)
    }
    
    /// :nodoc:
    private func create(className: String, length: Int = 0, fixed: Bool = false, items: [FREObject?]? = nil) {
        rawValue = FREObject(className: "Vector.<\(className)>", args: length, fixed)
        var cnt: UInt = 0
        for v in items ?? [] {
            if length > 0 {
                self[cnt] = v
            } else {
                self.push(v)
            }
            cnt += 1
        }
    }
    
    /// init: Initialise a FREArray with a [Int].
    ///
    /// - parameter intArray: array to be converted
    public init?(intArray array: [Int]) {
        create(className: "int", items: array.compactMap { $0.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [UInt].
    ///
    /// - parameter intArray: array to be converted
    public init(uintArray array: [UInt]) {
        create(className: "uint", items: array.compactMap { $0.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [String].
    ///
    /// - parameter stringArray: array to be converted
    public init(stringArray array: [String]) {
        rawValue = FREArray(className: "String", items: array.map { $0.toFREObject() })?.rawValue
    }
    
    /// init: Initialise a FREArray with a [String?].
    ///
    /// - parameter stringArray: array to be converted
    public init(optionalStringArray array: [String?]) {
        create(className: "String", items: array.map { $0?.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [Double].
    ///
    /// - parameter doubleArray: array to be converted
    public init(doubleArray array: [Double]) {
        create(className: "Number", items: array.compactMap { $0.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [NSNumber].
    ///
    /// - parameter doubleArray: array to be converted
    public init(numberArray array: [NSNumber]) {
        create(className: "Number", items: array.compactMap { $0.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [Bool].
    ///
    /// - parameter boolArray: array to be converted
    public init(boolArray array: [Bool]) {
        create(className: "Boolean", items: array.compactMap { $0.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [Date].
    ///
    /// - parameter dateArray: array to be converted
    public init(dateArray array: [Date]) {
        create(className: "Date", items: array.compactMap { $0.toFREObject() })
    }
    
    /// init: Initialise a FREArray with a [Any].
    ///
    /// - parameter anyArray: array to be converted
    public init(anyArray array: [Any]) {
        if let fre = FreSwiftHelper.newObject(className: "Array") {
            rawValue = fre
            for any in array {
                push(FreSwiftHelper.newObject(any: any))
            }
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
        let status = FreSwiftBridge.bridge.FREGetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: &ret)
#else
        let status = FREGetArrayElementAt(rv, UInt32(index), &ret)
#endif
        
        if FRE_OK == status { return ret }
        FreSwiftLogger.shared.error(message: "cannot get item at \(index)",
            type: FreSwiftHelper.getErrorCode(status))
        return nil
    }
    
    fileprivate func set(index: UInt, freObject: FREObject?) {
        guard let rv = rawValue else { return }
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FRESetArrayElementA(arrayOrVector: rv, index: UInt32(index),
                                                                          value: freObject)
#else
        let status = FRESetArrayElementAt(rv, UInt32(index), freObject)
#endif
        
        if FRE_OK == status { return }
        FreSwiftLogger.shared.error(message: "cannot set item at \(index)",
            type: FreSwiftHelper.getErrorCode(status))
    }
    
    /// set: Sets FREObject at position index
    ///
    /// - parameter index: Index of item
    /// - parameter value: Value to set
    /// - returns: FREObject?
    fileprivate func set(index: UInt, value: Any) {
        set(index: index, freObject: FreSwiftHelper.newObject(any: value))
    }
    
    /// push: Adds one or more elements to the end of an array and returns the new length of the array.
    ///
    /// - parameter args: One or more values to append to the array.
    /// - returns: UInt An integer representing the length of the new array.
    @discardableResult
    public func push(_ args: Any?...) -> UInt {
        return UInt(FreSwiftHelper.callMethod(self.rawValue, name: "push", args: args)) ?? 0
    }
    
    /// insert: Insert a single element into the FREArray.
    ///
    /// - parameter freObject: FREObject
    /// - parameter at: An Int that specifies the position in the Vector where the element is to be inserted.
    /// You can use a negative Int to specify a position relative to the end of the FREArray
    /// (for example, -1 for the last element of the FREArray)
    public func insert(_ freObject: FREObject?, at index: Int) {
        self.rawValue?.call(method: "insertAt", args: index, freObject)
    }
    
    /// remove: Remove a single element from the Vector. This method modifies the FREArray without making a copy.
    ///
    /// - parameter at: An Int that specifies the index of the element in the FREArray that is to be deleted.
    //// You can use a negative Int to specify a position relative to the end of the FREArray
    //// (for example, -1 for the last element of the Vector).
    /// - returns: FREObject? The element that was removed from the original FREArray
    @discardableResult
    public func remove(at index: Int) -> FREObject? {
        return self.rawValue?.call(method: "removeAt", args: index)
    }
    
    /// length: Length of FREArray
    public var length: UInt {
        guard let rv = rawValue else { return 0 }
        var ret: UInt32 = 0
#if os(iOS) || os(tvOS)
        let status = FreSwiftBridge.bridge.FREGetArrayLength(arrayOrVector: rv, length: &ret)
#else
        let status = FREGetArrayLength(rv, &ret)
#endif
        if FRE_OK == status { return UInt(ret) }
        FreSwiftLogger.shared.error(message: "cannot get length of array",
            type: FreSwiftHelper.getErrorCode(status))
        return 0
    }
    
    /// isEmpty: A Boolean value indicating whether the FREArray is empty.
    public var isEmpty: Bool {
        return length == 0
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
        guard let rv = freObject else {
            return nil
        }
        self.init()
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
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<Number>`.
    /// - returns: [Double]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { Double($0) }
    }
    
    /// init: Initialise a [Double] from a FREArray.
    ///
    /// ```swift
    /// let array = [Double](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<Number>`.
    /// - returns: [Double]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { Double($0) }
    }
    
    /// toFREObject: Converts a Double Array into a FREObject of AS3 type `Vector.<Number>`.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(doubleArray: self).rawValue
    }
}

public extension Array where Element == NSNumber {
    /// init: Initialise a [NSNumber] from a FREObject.
    ///
    /// ```swift
    /// let array = [NSNumber](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<Number>`.
    /// - returns: [NSNumber]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { NSNumber($0) }
    }
    
    /// init: Initialise a [NSNumber] from a FREArray.
    ///
    /// ```swift
    /// let array = [NSNumber](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<Number>`.
    /// - returns: [NSNumber]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { NSNumber($0) }
    }
    
    /// toFREObject: Converts a NSNumber Array into a FREObject of AS3 type `Vector.<Number>`.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(numberArray: self).rawValue
    }
}

public extension Array where Element == Bool {
    /// init: Initialise a [Bool] from a FREObject.
    ///
    /// ```swift
    /// let array = [Bool](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<Boolean>`.
    /// - returns: [Bool]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { Bool($0) }
    }
    
    /// init: Initialise a [Bool] from a FREArray.
    ///
    /// ```swift
    /// let array = [Bool](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type Vector.<Boolean>
    /// - returns: [Bool]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { Bool($0) }
    }
    
    /// toFREObject: Converts a Bool Array into a FREObject of AS3 type `Vector.<Boolean>`.
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
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<uint>`.
    /// - returns: [UInt]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { UInt($0) }
    }
    
    /// init: Initialise a [UInt] from a FREArray.
    ///
    /// ```swift
    /// let array = [UInt](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<uint>`.
    /// - returns: [UInt]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { UInt($0) }
    }
    
    /// toFREObject: Converts an Int Array into a FREObject of AS3 type `Vector.<int>`.
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
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<int>`.
    /// - returns: [Int]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { Int($0) }
    }
    
    /// init: Initialise a [Int] from a FREArray.
    ///
    /// ```swift
    /// let array = [Int](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<int>`.
    /// - returns: [Int]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { Int($0) }
    }
    
    /// toFREObject: Converts an Int Array into a FREObject of AS3 type `Vector.<int>`.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(intArray: self)?.rawValue
    }
}

public extension Array where Element == String {
    /// init: Initialise a [String] from a FREObject.
    ///
    /// ```swift
    /// let array = [String](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<String>`.
    /// - returns: [String]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { String($0) }
    }
    /// init: Initialise a [String] from a FREArray.
    ///
    /// ```swift
    /// let array = [String](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<String>`.
    /// - returns: [String]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { String($0) }
    }
    
    /// toFREObject: Converts an String Array into a FREObject of AS3 type `Vector.<String>`.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(stringArray: self).rawValue
    }
}

public extension Array where Element == String? {
    /// init: Initialise a [String] from a FREObject.
    ///
    /// ```swift
    /// let array = [String?](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<String>`.
    /// - returns: [String?]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).map { String($0) }
    }
    /// init: Initialise a [String] from a FREArray.
    ///
    /// ```swift
    /// let array = [String?](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<String>`.
    /// - returns: [String?]?
    init?(_ freArray: FREArray) {
        self = freArray.map { String($0) }
    }
    
    /// toFREObject: Converts an String Array into a FREObject of AS3 type `Vector.<String>`.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(optionalStringArray: self).rawValue
    }
}

public extension Array where Element == Date {
    /// init: Initialise a [Date] from a FREObject.
    ///
    /// ```swift
    /// let array = [Date](argv[0])
    /// ```
    /// - parameter freObject: FREObject which is of AS3 type `Vector.<Date>`.
    /// - returns: [Date]?
    init?(_ freObject: FREObject?) {
        guard let rv = freObject else {
            return nil
        }
        self = FREArray(rv).compactMap { Date($0) }
    }
    /// init: Initialise a [Date] from a FREArray.
    ///
    /// ```swift
    /// let array = [Date](FREArray(argv[0]))
    /// ```
    /// - parameter freArray: FREArray which is of AS3 type `Vector.<Date>`.
    /// - returns: [Date]?
    init?(_ freArray: FREArray) {
        self = freArray.compactMap { Date($0) }
    }
    
    /// toFREObject: Converts an Date Array into a FREObject of AS3 type `Vector.<Date>`.
    ///
    /// - returns: FREObject
    func toFREObject() -> FREObject? {
        return FREArray(dateArray: self).rawValue
    }
}
