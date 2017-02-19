//
// Created by User on 19/02/2017.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//

#import "EventDispatcher.h"


@implementation EventDispatcher {

}

- (instancetype)init {
    self = [super init];
    if (self) {

    }

    return self;
}


- (void)dispatchEventWithName:(NSString *_Nonnull)name value:(NSString *_Nonnull)value {
    NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", name, value]);
}

@end