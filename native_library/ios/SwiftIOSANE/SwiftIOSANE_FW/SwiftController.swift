//
//  SwiftController.swift
//  SwiftIOSANE
//
//  Created by User on 18/02/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Foundation

@objc protocol SwiftEventDispatcher {
    func dispatchEvent(name: String, value:String)
}

@objc class SwiftController: NSObject {
    var eventDispatcher: SwiftEventDispatcher?

    private func dispatchEvent(name: String, value: String) {
       eventDispatcher?.dispatchEvent(name: name, value: value)
    }

    func trace(msg: String) {
        dispatchEvent(name: "TRACE", value: msg)
    }

    func setDelegate(sender: SwiftEventDispatcher) {
        eventDispatcher = sender
    }

    func getIsSwiftCool() -> Bool {
        return true
    }

    func getPrice() -> Double {
        return 59.99
    }

    func getHelloWorld(argv:NSMutableArray) -> String {
        dispatchEvent(name: "ANE.ON_EVENT", value: "I am a param")
        trace(msg: "I will be a trace")
        
        let inString:String = argv[0] as! String
        return "Hello World " + inString
    }
    
    func getAge(argv:NSMutableArray) -> Int {
        var age = 31
        let person = argv[0] as! Dictionary<String, AnyObject>;
        if let val = person["age"] as? NSNumber { // AnyObject is read back as NSNumber
            age = Int(val) + 7
        }
        return age
    }
    
    func noReturn(argv:NSMutableArray) {
        trace(msg: "I trace but don't return")
    }
    
    



}
