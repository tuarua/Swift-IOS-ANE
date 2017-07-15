/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

#import "FreMacros.h"
#import "SwiftIOSANE_LIB.h"

#include "FlashRuntimeExtensions.h"

#import "FreSwift-iOS-Swift.h"
#import <FreSwift/FlashRuntimeExtensions.h>
#import "SwiftIOSANE_FW-Swift.h"

#define FRE_OBJC_BRIDGE TRSOA_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end


SWIFT_DECL(TRSOA) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRSOA) {
    SWIFT_INITS(TRSOA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRSOA, runStringTests)
        ,MAP_FUNCTION(TRSOA, runNumberTests)
        ,MAP_FUNCTION(TRSOA, runIntTests)
        ,MAP_FUNCTION(TRSOA, runArrayTests)
        ,MAP_FUNCTION(TRSOA, runObjectTests)
        ,MAP_FUNCTION(TRSOA, runBitmapTests)
        ,MAP_FUNCTION(TRSOA, runByteArrayTests)
        ,MAP_FUNCTION(TRSOA, runErrorTests)
        ,MAP_FUNCTION(TRSOA, runErrorTests2)
        ,MAP_FUNCTION(TRSOA, runDataTests)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRSOA) {
    //any clean up code here
}
EXTENSION_INIT(TRSOA)
EXTENSION_FIN(TRSOA)
