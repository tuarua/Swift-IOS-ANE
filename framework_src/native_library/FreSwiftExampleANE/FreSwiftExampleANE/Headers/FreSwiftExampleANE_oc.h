/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.*/

#import "FreMacros.h"
#import <Foundation/Foundation.h>

#ifdef OSX
#ifndef FreSwiftExampleANE_FreSwiftExampleANE_H
#define FreSwiftExampleANE_FreSwiftExampleANE_H
#import <Cocoa/Cocoa.h>
#include <Adobe AIR/Adobe AIR.h>

#define EXPORT __attribute__((visibility("default")))

EXPORT
EXTENSION_FIN_DECL(TRFSA);

EXPORT
EXTENSION_INIT_DECL(TRFSA);
#endif // FreSwiftExampleANE_FreSwiftExampleANE_H
#else
#import <UIKit/UIKit.h>
#endif

@interface FreSwiftExampleANE_LIB : NSObject
@end


