import Foundation
import FreSwift

public class SwiftController: NSObject, FreSwiftMainController {
    public static var TAG: String = "HelloWorldANE"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
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
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
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
    
    @objc public func dispose() {
        NotificationCenter.default.removeObserver(self)
        // Add other clean up code here
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        
    }
    
    // Must have these 3 functions. It exposes the methods to our entry ObjC.
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
    
    // Here we add observers for any app delegate stuff
    // Observers are independant of other ANEs and cause no conflicts
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification, object: nil)
        
    }
    
}
