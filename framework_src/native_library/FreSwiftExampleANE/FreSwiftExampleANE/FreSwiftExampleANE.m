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
#import "FreSwiftExampleANE_oc.h"

#if defined(IOS) || defined(TVOS)
#import <FreSwiftExampleANE_FW/FreSwiftExampleANE_FW.h>
#define FRE_OBJC_BRIDGE TRFSA_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end
#else
#import <FreSwiftExampleANE/FreSwiftExampleANE-Swift.h>
#endif

@implementation FreSwiftExampleANE_LIB
SWIFT_DECL(TRFSA) // use unique prefix throughout to prevent clashes with other ANEs

CONTEXT_INIT(TRFSA) {
    SWIFT_INITS(TRFSA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFSA, init)
        ,MAP_FUNCTION(TRFSA, runStringTests)
        ,MAP_FUNCTION(TRFSA, runNumberTests)
        ,MAP_FUNCTION(TRFSA, runIntTests)
        ,MAP_FUNCTION(TRFSA, runArrayTests)
        ,MAP_FUNCTION(TRFSA, runObjectTests)
        ,MAP_FUNCTION(TRFSA, runBitmapTests)
        ,MAP_FUNCTION(TRFSA, runByteArrayTests)
        ,MAP_FUNCTION(TRFSA, runErrorTests)
        ,MAP_FUNCTION(TRFSA, runDataTests)
        ,MAP_FUNCTION(TRFSA, runExtensibleTests)
        ,MAP_FUNCTION(TRFSA, runDateTests)
        ,MAP_FUNCTION(TRFSA, runColorTests)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFSA) {
    [TRFSA_swft dispose];
    TRFSA_swft = nil;
#if defined(IOS) || defined(TVOS)
    TRFSA_freBridge = nil;
    TRFSA_swftBridge = nil;
#endif
    TRFSA_funcArray = nil;
}
EXTENSION_INIT(TRFSA)
EXTENSION_FIN(TRFSA)
@end
