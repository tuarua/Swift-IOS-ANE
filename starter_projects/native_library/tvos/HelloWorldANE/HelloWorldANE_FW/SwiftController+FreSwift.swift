import Foundation
import FreSwift

extension SwiftController: FreSwiftMainController {
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)sayHello"] = sayHello
        
        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        return arr
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        
    }
    
    // Must have these 4 functions.
    @objc public func dispose() {
        NotificationCenter.default.removeObserver(self)
        // Add other clean up code here
    }
    
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
        FreSwiftLogger.shared.context = context
    }
    
    // Here we add observers for any app delegate stuff
    // Observers are independant of other ANEs and cause no conflicts
    // DO NOT OVERRIDE THE DEFAULT !!
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
}
