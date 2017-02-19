/*@copyright The code is licensed under the[MIT
License](http://opensource.org/licenses/MIT):

Copyright 2015 - 2017 Tua Rua Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files(the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions :

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/
#pragma once

#include "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>

class ANEHelper {
public:

    NSMutableArray* getFREargs(uint32_t argc, FREObject argv[]);
    
    static FREObject getFREObject(NSString *value);

    static FREObject getFREObject(double arg);

    static FREObject getFREObject(bool arg);

    static FREObject getFREObject(NSInteger arg);

    static FREObject getProperty(FREObject objAS, NSString *propertyName);

    static void setProperty(FREObject objAS, NSString *name, FREObject value);

    static void setProperty(FREObject objAS, NSString *name, NSString *value);

    static void setProperty(FREObject objAS, NSString *name, double value);

    static void setProperty(FREObject objAS, NSString *name, bool value);

    static void setProperty(FREObject objAS, NSString *name, NSInteger value);

    static NSInteger getNSInteger(FREObject intAS);

    static NSString *getNSString(FREObject arg);

    static bool getBool(FREObject val);

    static double getDouble(FREObject arg);

    static uint32_t getArrayLength(FREObject arrayAS);

    id getIdObject(FREObject arg);

    static FREObject createFREObject(NSString *className);

    static void dispatchEvent(FREContext ctx, NSString *name, NSString *value);

    id getNSNumber(FREObject arg);

    NSMutableArray *getArray(FREObject arg);
};
