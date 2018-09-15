/* Copyright 2017 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "FreMacros.h"
#import <Foundation/Foundation.h>
#import <FreSwift_oc.h>

FreSwift *swft;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION(initFreSwift) {
    return [swft initFreSwiftWithCtx:context argc:argc argv:argv];
}

CONTEXT_INIT(TRFRES) {
    
    swft = [[FreSwift alloc] init];
    static FRENamedFunction extensionFunctions[] =
    {
        { (const uint8_t*) "initFreSwift", NULL, &initFreSwift }
    };
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFRES){
    //any clean up code here
}

EXTENSION_INIT(TRFRES)

EXTENSION_FIN(TRFRES)
