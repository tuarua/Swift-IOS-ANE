//
// Created by User on 19/02/2017.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwiftIOSANE_FW-Swift.h"
#include "FlashRuntimeExtensions.h"
@interface EventDispatcher : NSObject<SwiftEventDispatcher>
- (void)setFREContext:(FREContext _Nonnull)ctx;
@end