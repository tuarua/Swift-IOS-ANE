//
//  SwiftController.swift
//  HelloWorldANE
//
//  Created by Eoin Landy on 14/11/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Foundation
import Cocoa
import FreSwift

public class SwiftController: NSObject, FreSwiftMainController {
    public static var TAG: String = "HelloWorldANE"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]

    @objc public func getFunctions(prefix: String) -> Array<String> {
        
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)sayHello"] = sayHello
        
        var arr: Array<String> = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    func sayHello(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let myString = String(argv[0]),
            let uppercase = Bool(argv[1]),
            let numRepeats = Int(argv[2])
            else {
                return FreArgError(message: "sayHello").getError(#file, #line, #column)
        }
        
        dispatchEvent(name: "MY_EVENT", value: "ok") //async event
        
        for i in 0..<numRepeats {
            trace("Hello \(i)")
            // or
            // trace("Hello", i)
        }
        
        var ret = myString
        if uppercase {
            ret = ret.uppercased()
        }
        
        return ret.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    @objc public func dispose() {
        // Any clean up code here
    }
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
        FreSwiftLogger.shared().context = context
    }
    
    @objc public func onLoad() {
        
    }
    
}
