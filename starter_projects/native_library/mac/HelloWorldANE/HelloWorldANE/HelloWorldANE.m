#import "HelloWorldANE_oc.h"
#import <HelloWorldANE/HelloWorldANE-Swift.h>

@implementation HelloWorldANE
SWIFT_DECL(MCHW) // use unique prefix throughout to prevent clashes with other ANEs

CONTEXT_INIT(MCHW) {
    SWIFT_INITS(MCHW)
    
    /****************************************************************************/
    /***** Make sure to add functions here and SwiftController+FreSwift.swift ***/
    /****************************************************************************/
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(MCHW, init)
        ,MAP_FUNCTION(MCHW, sayHello)
    };
    /****************************************************************************/
    /****************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(MCHW) {
    [MCHW_swft dispose];
    MCHW_swft = nil;
    MCHW_funcArray = nil;
}
EXTENSION_INIT(MCHW)
EXTENSION_FIN(MCHW)
@end
