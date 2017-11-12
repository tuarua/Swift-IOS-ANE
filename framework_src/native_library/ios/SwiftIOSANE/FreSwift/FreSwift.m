//
//  FreSwift.m
//
//  Created by Eoin Landy on 03/07/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FreSwift_oc.h"
#import "FreSwift-Swift.h"
#import <FreSwift/FlashRuntimeExtensions.h>

FreSwift *swft;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])


FRE_FUNCTION(initFreSwift) {
    return [swft initFreSwiftWithCtx:context argc:argc argv:argv];
}

void TRFRE_contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet,
                        const FRENamedFunction **functionsToSet) {
    
    swft = [[FreSwift alloc] init];
    static FRENamedFunction extensionFunctions[] =
    {
        { (const uint8_t*) "initFreSwift", NULL,&initFreSwift }
    };
    *numFunctionsToSet = sizeof( extensionFunctions ) / sizeof( FRENamedFunction );
    *functionsToSet = extensionFunctions;
    
}

void TRFRESExtInizer(void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) {
    *ctxInitializer = &TRFRE_contextInitializer;
    *ctxFinalizer = &TRFRE_contextFinalizer;
}

void TRFRESExtFinizer(void *extData) {
}
