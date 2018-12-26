import Foundation
import FreSwift

public class SwiftController: NSObject {
    public static var TAG: String = "HelloWorldANE"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
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
    
}
