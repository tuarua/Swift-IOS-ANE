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
#import "CoreMLANE_LIB.h"
#import <CoreMLANE_FW/CoreMLANE_FW.h>

#define FRE_OBJC_BRIDGE TRCML_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation CoreMLANE_LIB
SWIFT_DECL(TRCML) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRCML) {
    SWIFT_INITS(TRCML)
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRCML, init)
        ,MAP_FUNCTION(TRCML, imageMatch)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRCML) {
    //any clean up code here
}
EXTENSION_INIT(TRCML)
EXTENSION_FIN(TRCML)
@end
