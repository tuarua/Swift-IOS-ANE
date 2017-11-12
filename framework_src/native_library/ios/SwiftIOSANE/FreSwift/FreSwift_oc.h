//
//  FreSwift.h
//  SwiftOSXANE
//
//  Created by Eoin Landy on 03/07/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

#ifndef FRESWIFT_FRESWIFT_H
#define FRESWIFT_FRESWIFT_H

#import <Cocoa/Cocoa.h>

#include <Adobe AIR/Adobe AIR.h>

#define EXPORT __attribute__((visibility("default")))
EXPORT
void TRFRESExtInizer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer);

EXPORT
void TRFRESExtFinizer(void* extData);


#endif //FRESWIFT_FRESWIFT_H
