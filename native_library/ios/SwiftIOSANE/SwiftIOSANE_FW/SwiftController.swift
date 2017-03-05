//
//  SwiftController.swift
//  SwiftIOSANE
//
//  Created by Eoin Landy on 18/02/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Foundation

@objc class SwiftController: NSObject {
    private var dllContext: FREContext!
    private var aneHelper = ANEHelper()
    func trace(value: String) {
        _ = FREDispatchStatusEventAsync(ctx: self.dllContext, code: value, level: "TRACE")
    }

    func runStringTests(argv: NSPointerArray) -> FREObject? {
        trace(value: "\n***********Start String test***********")
        let airString: String = aneHelper.getString(object: argv.pointer(at: 0)!)
        trace(value: "String passed from AIR: \(airString)");
        let swiftString: String = "I am a string from Swift"
        let swiftString2 = "I am a string in Swift as Any"

        let testAsAny: FREObject = aneHelper.getFREObject(any: swiftString2)!
        aneHelper.traceObjectType(tag: "What type swiftString2: ", object: testAsAny)

        return aneHelper.getFREObject(string: swiftString)
    }

    func runNumberTests(argv: NSPointerArray) -> FREObject? {
        trace(value: "\n***********Start Number test***********")
        let airNumber: Double = aneHelper.getDouble(object: argv.pointer(at: 0)!)
        trace(value: "Number passed from AIR: \(airNumber)");
        let swiftDouble: Double = 34343.31
        return aneHelper.getFREObject(double: swiftDouble)
    }

    func runIntTests(argv: NSPointerArray) -> FREObject? {
        trace(value: "\n***********Start Int Uint test***********")
        let airInt: Int = aneHelper.getInt(object: argv.pointer(at: 0)!)
        let airUint: UInt = aneHelper.getUInt(object: argv.pointer(at: 1)!)
        let swiftInt: Int32 = -666
        let swiftUInt: UInt = 888
        trace(value: "Int passed from AIR: \(airInt)");
        trace(value: "Uint passed from AIR: \(airUint)");
        _ = aneHelper.getFREObject(uint: swiftUInt)
        return aneHelper.getFREObject(int32: swiftInt);
    }

    func runArrayTests(argv: NSPointerArray) -> FREObject? {
        let inFRE: FREObject = argv.pointer(at: 0)!
        trace(value: "\n***********Start Array test***********")
        let airArray = aneHelper.getArray(arrayOrVector: inFRE)
        trace(value: "Array passed from AIR: \(airArray!)");
        trace(value: "AIR Array length: \(aneHelper.getArrayLength(arrayOrVector: inFRE))");

        var itemZero: FREObject? = nil
        _ = FREGetArrayElementAt(arrayOrVector: inFRE, index: 0, value: &itemZero)
        aneHelper.traceObjectType(tag: "AIR Array elem at 0 type", object: itemZero);
        trace(value: "AIR Array item 0: \(aneHelper.getInt(object: itemZero!))");

        let newVal: FREObject? = aneHelper.getFREObject(int32: 56)
        _ = FRESetArrayElementAt(arrayOrVector: inFRE, index: 0, value: newVal)

        return inFRE
    }

    func runObjectTests(argv: NSPointerArray) -> FREObject? {
        trace(value: "\n***********Start Object test***********")
        let person: FREObject = argv.pointer(at: 0)!
        let oldAge: Int = aneHelper.getInt(object: aneHelper.getProperty(object: person, name: "age")!)
        let newAge: FREObject = aneHelper.getFREObject(int: oldAge + 10)!


        aneHelper.setProperty(object: person, name: "age", prop: newAge)
        aneHelper.traceObjectType(tag: "person type is: ", object: person)
        trace(value: "current person age is \(oldAge)")

        let addition: FREObject = aneHelper.call(object: person, methodName: "add", params: 100, 33)!

        if FRE_TYPE_NULL != aneHelper.getObjectType(object: addition) {
            trace(value: "addition result: \(aneHelper.getInt(object: addition))")
        }

        let dictionary = aneHelper.getDictionary(object: person)
        trace(value: "AIR Object converted to Dictionary: \(dictionary.description)")

        return person
    }

    func setFREContext(ctx: FREContext) {
        dllContext = ctx
        aneHelper.setFREContext(ctx: ctx)
    }


}
