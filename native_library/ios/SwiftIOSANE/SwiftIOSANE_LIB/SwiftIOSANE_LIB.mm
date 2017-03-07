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
#import "FlashRuntimeExtensionsBridge.h"

FlashRuntimeExtensionsBridge *freBridge; // this runs the native FRE calls and returns to Swift
SwiftController *swft; // our main Swift Controller
FRESwiftBridge *swftBridge; // this is the bridge from Swift back to ObjectiveC

const NSString *ANE_NAME = @"SwiftIOSANE";
FREContext dllContext;

extern "C" {

#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

// convert argv into a pointer array which can be passed to Swift
NSPointerArray * getFREargs(uint32_t argc, FREObject argv[]) {
    NSPointerArray * pa = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];
    for (int i = 0; i < argc; ++i) {
        FREObject freObject;
        freObject = argv[i];
        [pa addPointer:freObject];
    }
    return pa;
}
    
FRE_FUNCTION (runStringTests) {
    return [swft runStringTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runNumberTests) {
    return [swft runNumberTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runIntTests) {
    return [swft runIntTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runArrayTests) {
    return [swft runArrayTestsWithArgv:getFREargs(argc, argv)];
}
FRE_FUNCTION (runObjectTests) {
    return [swft runObjectTestsWithArgv:getFREargs(argc, argv)];
}
    
FRE_FUNCTION (runBitmapTests) {
    return [swft runBitmapTestsWithArgv:getFREargs(argc, argv)];
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {

    static FRENamedFunction extensionFunctions[] = {
            {(const uint8_t *) "runStringTests", NULL, &runStringTests},
            {(const uint8_t *) "runNumberTests", NULL, &runNumberTests},
            {(const uint8_t *) "runIntTests", NULL, &runIntTests},
            {(const uint8_t *) "runArrayTests", NULL, &runArrayTests},
            {(const uint8_t *) "runObjectTests", NULL, &runObjectTests},
            {(const uint8_t *) "runBitmapTests", NULL, &runBitmapTests}

    };
    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
    *functionsToSet = extensionFunctions;
    dllContext = ctx;
    
    freBridge = [[FlashRuntimeExtensionsBridge alloc] init];
    
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];
    
    swftBridge = [[FRESwiftBridge alloc] init];
    [swftBridge setDelegateWithBridge:freBridge];
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


}

