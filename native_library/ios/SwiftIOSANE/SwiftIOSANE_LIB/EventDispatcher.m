//
// Created by User on 19/02/2017.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//

#import "EventDispatcher.h"


@implementation EventDispatcher {
    FREContext dllContext;
}
- (void)dispatchEventWithName:(NSString *_Nonnull)name value:(NSString *_Nonnull)value {
    FREDispatchStatusEventAsync(dllContext,( uint8_t * ) [value UTF8String],( uint8_t * ) [name UTF8String]);
}

- (void)setFREContext:(FREContext _Nonnull)ctx {
    dllContext = ctx;
}
@end