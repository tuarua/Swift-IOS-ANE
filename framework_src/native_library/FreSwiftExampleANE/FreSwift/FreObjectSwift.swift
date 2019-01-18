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

/// FreObjectSwift: Wraps a FREObject in a dynamicMemberLookup which allows us to perform easy gets and sets of
/// it's properties
@dynamicMemberLookup
open class FreObjectSwift: NSObject {
    /// rawValue: raw FREObject value
    public var rawValue: FREObject?
    
    /// value:
    public var value: Any? {
        return FreSwiftHelper.getAsId(rawValue)
    }
    
#if os(OSX)
    /// returns the className of the FREOject
    open override var className: String {
        if let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classType = aneUtils.call(method: "getClassType", args: self.rawValue) {
            return String(classType) ?? "unknown"
        }
        return "unknown"
    }
#else
    /// returns the className of the FREOject
    public var className: String {
        if let aneUtils = FREObject(className: "com.tuarua.fre.ANEUtils"),
            let classType = aneUtils.call(method: "getClassType", args: self.rawValue) {
            return String(classType) ?? "unknown"
        }
        return "unknown"
    }
#endif
    
    /// hasOwnProperty: Indicates whether an object has a specified property defined.
    ///
    /// ```swift
    /// if argv[0].hasOwnProperty("name") {
    ///
    /// }
    /// ```
    /// - parameter name: The property of the FREObject.
    /// - returns: Bool
    public func hasOwnProperty(name: String) -> Bool {
        return rawValue?.hasOwnProperty(name: name) ?? false
    }

    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let freFirstName: FREObject? = frePerson.firstName
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: FREObject?
    public subscript(dynamicMember name: String) -> FREObject? {
        get { return rawValue?[name]}
        set { rawValue?[name] = newValue }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let freChildren: FREArray? = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: FREArray?
    public subscript(dynamicMember name: String) -> FREArray? {
        get {
            if let v = rawValue?[name] {
                return FREArray(v)
            }
            return nil
        }
        set { rawValue?[name] = newValue?.rawValue }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let middleName: String? = frePerson.middleName
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: String?
    public subscript(dynamicMember name: String) -> String? {
        get { return String(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let isRightHanded: Bool? = frePerson.isRightHanded
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Bool?
    public subscript(dynamicMember name: String) -> Bool? {
        get { return Bool(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let isRightHanded: Bool = frePerson.isRightHanded
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Bool
    public subscript(dynamicMember name: String) -> Bool {
        get { return Bool(rawValue?[name]) ?? false }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let children: Int? = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Int?
    public subscript(dynamicMember name: String) -> Int? {
        get { return Int(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let children: Int = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Int
    public subscript(dynamicMember name: String) -> Int {
        get { return Int(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let children: UInt? = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: UInt?
    public subscript(dynamicMember name: String) -> UInt? {
        get { return UInt(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let children: UInt = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: UInt
    public subscript(dynamicMember name: String) -> UInt {
        get { return UInt(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let children: NSNumber? = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: NSNumber?
    public subscript(dynamicMember name: String) -> NSNumber? {
        get { return NSNumber(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let children: NSNumber = frePerson.children
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: NSNumber
    public subscript(dynamicMember name: String) -> NSNumber {
        get { return NSNumber(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let height: CGFloat? = frePerson.height
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: CGFloat?
    public subscript(dynamicMember name: String) -> CGFloat? {
        get { return CGFloat(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let height: CGFloat = frePerson.height
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: CGFloat
    public subscript(dynamicMember name: String) -> CGFloat {
        get { return CGFloat(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let height: Float? = frePerson.height
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Float
    public subscript(dynamicMember name: String) -> Float? {
        get { return Float(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let height: Float = frePerson.height
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Float
    public subscript(dynamicMember name: String) -> Float {
        get { return Float(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let height: Double = frePerson.height
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Double
    public subscript(dynamicMember name: String) -> Double? {
        get { return Double(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let frePerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let height: Double = frePerson.height
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Double?
    public subscript(dynamicMember name: String) -> Double {
        get { return Double(rawValue?[name]) ?? 0 }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let date: Date? = newPerson.birthday
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: Date?
    public subscript(dynamicMember name: String) -> Date? {
        get { return Date(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
#if os(iOS) || os(tvOS)
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let eyeColor: UIColor? = newPerson.eyeColor
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: UIColor?
    public subscript(dynamicMember name: String) -> UIColor? {
        get { return UIColor(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let eyeColor: UIColor = newPerson.eyeColor
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: UIColor
    public subscript(dynamicMember name: String) -> UIColor {
        get { return UIColor(rawValue?[name]) ?? UIColor.black }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
#endif
    
#if os(OSX)
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let eyeColor: NSColor? = newPerson.eyeColor
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: NSColor?
    public subscript(dynamicMember name: String) -> NSColor? {
        get { return NSColor(rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person")
    /// let eyeColor: NSColor = newPerson.eyeColor
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: NSColor
    public subscript(dynamicMember name: String) -> NSColor {
        get { return NSColor(rawValue?[name]) ?? NSColor.black }
        set { rawValue?[name] = newValue.toFREObject() }
    }
#endif
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person", args: 1, true, "Free")
    /// let myName = newPerson["name"]
    /// ```
    /// - parameter name: name of the property to return
    /// - returns: FREObject?
    public subscript(_ name: String) -> FREObject? {
        get {
            return self.rawValue?[name]
        }
        set {
            self.rawValue?[name] = newValue
        }
    }

    /// init: Creates a new FreObjectSwift
    /// - parameter freObject: FREObject to wrap
    public init(_ freObject: FREObject?) {
        super.init()
        rawValue = freObject
    }
    
    /// init: Creates a new FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person", args: 1, true, "Free")
    /// ```
    /// - parameter className: name of AS3 class to create
    /// - parameter args: arguments to use. These are automatically converted to FREObjects
    public convenience init?(className: String, args: Any?...) {
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
    
    /// init: Creates a new FreObjectSwift.
    ///
    /// ```swift
    /// let newPerson = FreObjectSwift(className: "com.tuarua.Person")
    /// ```
    /// - parameter className: name of AS3 class to create
    public convenience init?(className: String) {
        if let rv = FreSwiftHelper.newObject(className: className) {
            self.init(rv)
        } else {
            return nil
        }
    }
    
    /// call: Calls a method on a FREObject.
    ///
    /// ```swift
    /// person.call(method: "add", args: 100, 31)
    /// ```
    /// - parameter method: name of AS3 method to call
    /// - parameter args: arguments to pass to the method
    /// - returns: FREObject?
    @discardableResult
    public func call(method: String, args: Any...) -> FREObject? {
        return FreSwiftHelper.callMethod(self.rawValue, name: method, args: args)
    }
    
    /// returns the type of the FREOject
    public var type: FreObjectTypeSwift {
        return FreSwiftHelper.getType(self.rawValue)
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [String]?
    public subscript(dynamicMember name: String) -> [String]? {
        get { return [String](rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [String]
    public subscript(dynamicMember name: String) -> [String] {
        get { return [String](rawValue?[name]) ?? [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Int]?
    public subscript(dynamicMember name: String) -> [Int]? {
        get { return [Int](rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Int]
    public subscript(dynamicMember name: String) -> [Int] {
        get { return [Int](rawValue?[name]) ?? [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [UInt]?
    public subscript(dynamicMember name: String) -> [UInt]? {
        get { return [UInt](rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [UInt]
    public subscript(dynamicMember name: String) -> [UInt] {
        get { return [UInt](rawValue?[name]) ?? [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Double]?
    public subscript(dynamicMember name: String) -> [Double]? {
        get { return [Double](rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Double]
    public subscript(dynamicMember name: String) -> [Double] {
        get { return [Double](rawValue?[name]) ?? [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Bool]?
    public subscript(dynamicMember name: String) -> [Bool]? {
        get { return [Bool](rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Bool]
    public subscript(dynamicMember name: String) -> [Bool] {
        get { return [Bool](rawValue?[name]) ?? [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Date]?
    public subscript(dynamicMember name: String) -> [Date]? {
        get { return [Date](rawValue?[name]) }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
    
    /// subscript: sets/gets the Property of a FreObjectSwift.
    ///
    /// - parameter name: name of the property to return
    /// - returns: [Date]
    public subscript(dynamicMember name: String) -> [Date] {
        get { return [Date](rawValue?[name]) ?? [] }
        set { rawValue?[name] = newValue.toFREObject() }
    }

}
