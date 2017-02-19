//
//  ViewController.m
//  SwiftIOSANE
//
//  Created by User on 18/02/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

#import "ViewController.h"

#import "SwiftIOSANE_FW.h"
#import "EventDispatcher.h"
#import "SwiftIOSANE_FW-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    EventDispatcher *eventDispatcher;
    eventDispatcher = [[EventDispatcher alloc] init];

    SwiftController *swft;
    swft = [[SwiftController alloc] init];
    [swft setDelegateWithSender:eventDispatcher];


    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *test = @"hi";
    [array addObject:test];
    _lbl.text = [swft getHelloWorldWithArgv:array];
    
}


@end
