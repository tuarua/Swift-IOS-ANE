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
#include "FlashRuntimeExtensions.h"
#import "FlashRuntimeExtensionsBridge.h"
#import "SwiftIOSANE_FW-Swift.h"

FlashRuntimeExtensionsBridge *freBridge; // this runs the native FRE calls and returns to Swift
SwiftController *swft; // our main Swift Controller
FreSwiftBridge *swftBridge; // this is the bridge from Swift back to ObjectiveC

NSArray * funcArray;

/****************************************************************************/
/****************** USE PREFIX TRSOA_ TO PREVENT CLASHES  ********************/
/****************************************************************************/


#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (__bridge void *)(data), &TRSOA_callSwiftFunction }

FRE_FUNCTION(TRSOA_callSwiftFunction) {
    static NSString *const prefix = @"TRSOA_";
    NSString* name = (__bridge NSString *)(functionData);
    NSString* fName = [NSString stringWithFormat:@"%@%@", prefix, name];
    return [swft callSwiftFunctionWithName:fName ctx:context argc:argc argv:argv];
}

void TRSOA_contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];
    freBridge = [[FlashRuntimeExtensionsBridge alloc] init];
    swftBridge = [[FreSwiftBridge alloc] init];
    [swftBridge setDelegateWithBridge:freBridge];
    funcArray = [swft getFunctionsWithPrefix:@"TRSOA_"];
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/

    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(runStringTests, @"runStringTests")
        ,MAP_FUNCTION(runNumberTests, @"runNumberTests")
        ,MAP_FUNCTION(runIntTests, @"runIntTests")
        ,MAP_FUNCTION(runArrayTests, @"runArrayTests")
        ,MAP_FUNCTION(runObjectTests, @"runObjectTests")
        ,MAP_FUNCTION(runBitmapTests, @"runBitmapTests")
        ,MAP_FUNCTION(runByteArrayTests, @"runByteArrayTests")
        ,MAP_FUNCTION(runErrorTests, @"runErrorTests")
        ,MAP_FUNCTION(runErrorTests2, @"runErrorTests2")
        ,MAP_FUNCTION(runDataTests, @"runDataTests")
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    *numFunctionsToSet = sizeof( extensionFunctions ) / sizeof( FRENamedFunction );
    *functionsToSet = extensionFunctions;
    
}

void TRSOA_contextFinalizer(FREContext ctx) {}

void TRSOAExtInizer(void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) {
    *ctxInitializer = &TRSOA_contextInitializer;
    *ctxFinalizer = &TRSOA_contextFinalizer;
}

void TRSOAExtFinizer(void *extData) {
    FREContext nullCTX = 0;
    TRSOA_contextFinalizer(nullCTX);
    return;
}


