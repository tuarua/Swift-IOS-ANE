/*@copyright The code is licensed under the[MIT
 License](http://opensource.org/licenses/MIT):
 
 Copyright © 2017 -  Tua Rua Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files(the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions :
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/


#import "SwiftIOSANE_LIB.h"
#import "FreMacros.h"
#include "FlashRuntimeExtensions.h"

#import "FreSwift-Swift.h"
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
    
    *numFunctionsToSet = sizeof( extensionFunctions ) / sizeof( FRENamedFunction );
    *functionsToSet = extensionFunctions;
    
}

CONTEXT_FIN(TRSOA) {
    //any clean up code here
}
EXTENSION_INIT(TRSOA)
EXTENSION_FIN(TRSOA)
