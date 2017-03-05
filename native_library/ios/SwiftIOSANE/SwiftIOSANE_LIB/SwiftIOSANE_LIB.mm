//
// Created by Eoin Landy on 19/02/2017.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//

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

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {

    static FRENamedFunction extensionFunctions[] = {
            {(const uint8_t *) "runStringTests", NULL, &runStringTests},
            {(const uint8_t *) "runNumberTests", NULL, &runNumberTests},
            {(const uint8_t *) "runIntTests", NULL, &runIntTests},
            {(const uint8_t *) "runArrayTests", NULL, &runArrayTests},
            {(const uint8_t *) "runObjectTests", NULL, &runObjectTests}

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

