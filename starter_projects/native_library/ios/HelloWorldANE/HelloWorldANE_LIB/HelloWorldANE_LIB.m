#import "HelloWorldANE_LIB.h"
#import <HelloWorldANE_FW/HelloWorldANE_FW.h>

#define FRE_OBJC_BRIDGE MCHW_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation HelloWorldANE_LIB
SWIFT_DECL(MCHW) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(MCHW) {
    SWIFT_INITS(MCHW)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(MCHW, init)
        ,MAP_FUNCTION(MCHW, sayHello)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(MCHW) {
    [MCHW_swft dispose];
    MCHW_swft = nil;
    MCHW_freBridge = nil;
    MCHW_swftBridge = nil;
    MCHW_funcArray = nil;
}
EXTENSION_INIT(MCHW)
EXTENSION_FIN(MCHW)
@end
