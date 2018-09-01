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
import FreSwift

extension SwiftController: FreSwiftMainController {
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> [String] {
        
        functionsToSet["\(prefix)runStringTests"] = runStringTests
        functionsToSet["\(prefix)runNumberTests"] = runNumberTests
        functionsToSet["\(prefix)runIntTests"] = runIntTests
        functionsToSet["\(prefix)runArrayTests"] = runArrayTests
        functionsToSet["\(prefix)runObjectTests"] = runObjectTests
        functionsToSet["\(prefix)runBitmapTests"] = runBitmapTests
        functionsToSet["\(prefix)runByteArrayTests"] = runByteArrayTests
        functionsToSet["\(prefix)runErrorTests"] = runErrorTests
        functionsToSet["\(prefix)runDataTests"] = runDataTests
        functionsToSet["\(prefix)runExtensibleTests"] = runExtensibleTests
        functionsToSet["\(prefix)runDateTests"] = runDateTests
        functionsToSet["\(prefix)runColorTests"] = runColorTests
        
        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    @objc public func dispose() {
    }
    
    // Must have these 3 functions.
    //Exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    //Here we set our FREContext
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift(freContext: ctx)
        // Turn on FreSwift logging
        FreSwiftLogger.shared().context = context
    }
    
    // Here we add observers for any app delegate stuff
    // Observers are independant of other ANEs and cause no conflicts
    // DO NOT OVERRIDE THE DEFAULT !!
    @objc public func onLoad() {
    }
}
