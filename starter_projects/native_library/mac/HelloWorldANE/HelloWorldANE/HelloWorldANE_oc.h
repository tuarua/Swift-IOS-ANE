#ifndef HelloWorldANE_oc_h
#define HelloWorldANE_oc_h
#import "FreMacros.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include <Adobe AIR/Adobe AIR.h>

#define EXPORT __attribute__((visibility("default")))

EXPORT
EXTENSION_FIN_DECL(MCHW);

EXPORT
EXTENSION_INIT_DECL(MCHW);

#endif /* HelloWorldANE_oc_h */

@interface HelloWorldANE : NSObject
@end
