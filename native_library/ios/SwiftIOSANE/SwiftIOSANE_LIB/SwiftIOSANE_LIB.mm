//
// Created by User on 19/02/2017.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//

#import "SwiftIOSANE_LIB.h"
#include "FlashRuntimeExtensions.h"
/*
 * This is your Swift header, interop methods are defined in here
 */
#import "SwiftIOSANE_FW-Swift.h"
#import "EventDispatcher.h"
#include "ANEhelper.h"

EventDispatcher *eventDispatcher; //this dispatches events from Swift up to Objective C and then FREDispatchStatusEventAsync
SwiftController *swft; // our main Swift Controller
ANEHelper aneHelper = ANEHelper(); // helper functions for FRE

const NSString *ANE_NAME = @"SwiftIOSANE";
FREContext dllContext;

extern "C" {

#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

/*
 * Call Swift method with Boolean return, no args
 */
FRE_FUNCTION (getIsSwiftCool) {
    return aneHelper.getFREObject([swft getIsSwiftCool]);
}
/*
 * Call Swift method with String return, converts args to array of equivalent Swift types
 */
FRE_FUNCTION (getHelloWorld) {
    return aneHelper.getFREObject([swft getHelloWorldWithArgv:aneHelper.getFREargs(argc, argv)]);
}
/*
 * Call Swift method with no return
 */
FRE_FUNCTION (noReturn) {
    [swft noReturnWithArgv:aneHelper.getFREargs(argc, argv)];
    return NULL;
}
/*
 * Call Swift method with Int return, converts args to array of equivalent Swift types
 */
FRE_FUNCTION (getAge) {
    return aneHelper.getFREObject([swft getAgeWithArgv:aneHelper.getFREargs(argc, argv)]);
}
/*
 * Call Swift method with Number return, no args
 */
FRE_FUNCTION(getPrice) {
    return aneHelper.getFREObject([swft getPrice]);
}

void contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet) {

    static FRENamedFunction extensionFunctions[] = {
            {(const uint8_t *) "getHelloWorld", NULL, &getHelloWorld},
            {(const uint8_t *) "getAge", NULL, &getAge},
            {(const uint8_t *) "getPrice", NULL, &getPrice},
            {(const uint8_t *) "getIsSwiftCool", NULL, &getIsSwiftCool},
            {(const uint8_t *) "noReturn", NULL, &noReturn}
    };
    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
    *functionsToSet = extensionFunctions;
    dllContext = ctx;

    eventDispatcher = [[EventDispatcher alloc] init];
    [eventDispatcher setFREContext:ctx];
    swft = [[SwiftController alloc] init];
    [swft setDelegateWithSender:eventDispatcher];
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

