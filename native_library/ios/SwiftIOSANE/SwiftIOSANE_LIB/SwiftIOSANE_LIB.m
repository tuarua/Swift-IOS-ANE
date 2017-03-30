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
FRESwiftBridge *swftBridge; // this is the bridge from Swift back to ObjectiveC

NSArray * funcArray;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION(callSwiftFunction) {
    NSString* fName = (__bridge NSString *)(functionData);
    return [swft callSwiftFunctionWithName:fName ctx:context argc:argc argv:argv];
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {

    /******* MAKE SURE TO SET NUM OF FUNCTIONS MANUALLY *****/
    /********************************************************/
    
    const int numFunctions = 9;
    
    /********************************************************/
    /********************************************************/
    
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];
    freBridge = [[FlashRuntimeExtensionsBridge alloc] init];
    swftBridge = [[FRESwiftBridge alloc] init];
    [swftBridge setDelegateWithBridge:freBridge];
    
    funcArray = [swft getFunctions];
    static FRENamedFunction extensionFunctions[numFunctions] = {};
    for (int i = 0; i < [funcArray count]; ++i) {
        NSString * nme = [funcArray objectAtIndex:i];
        FRENamedFunction nf = {(const uint8_t *) [nme UTF8String], (__bridge void *)(nme), &callSwiftFunction};
        extensionFunctions[i] = nf;
    }
    
    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
    *functionsToSet = extensionFunctions;
    
}

void contextFinalizer(FREContext ctx) {
    return;
}

void TRSOAExtInizer(void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) {
    *ctxInitializer = &contextInitializer;
    *ctxFinalizer = &contextFinalizer;
}

void TRSOAExtFinizer(void *extData) {
    FREContext nullCTX;
    nullCTX = 0;
    contextFinalizer(nullCTX);
    return;
}


