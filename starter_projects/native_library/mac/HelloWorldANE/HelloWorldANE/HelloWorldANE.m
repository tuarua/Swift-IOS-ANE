#import <Foundation/Foundation.h>
#import "FreMacros.h"
#import "HelloWorldANE_oc.h"
#import <HelloWorldANE/HelloWorldANE-Swift.h>

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
    MCHW_funcArray = nil;
}
EXTENSION_INIT(MCHW)
EXTENSION_FIN(MCHW)
