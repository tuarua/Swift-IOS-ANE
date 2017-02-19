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

#include "ANEHelper.h"


NSMutableArray* ANEHelper::getFREargs(uint32_t argc, FREObject argv[]) {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:argc];
    for (int i = 0; i < argc; ++i) {
        FREObject freObject;
        freObject = argv[i];
        [array addObject:getIdObject(freObject)];
    }
    return array;
}

FREObject ANEHelper::getFREObject(NSString *value) {
    FREObject result;
    FRENewObjectFromUTF8((uint32_t) [value length], (const uint8_t *) [value UTF8String], &result);
    return result;
}

FREObject ANEHelper::getFREObject(double arg) {
    FREObject result;
    FRENewObjectFromDouble(arg, &result);
    return result;
}

FREObject ANEHelper::getFREObject(bool arg) {
    FREObject result;
    FRENewObjectFromBool(arg, &result);
    return result;
}

FREObject ANEHelper::getFREObject(NSInteger arg) {
    FREObject result;
    FRENewObjectFromInt32((int32_t) arg, &result);
    return result;
}

FREObject ANEHelper::getProperty(FREObject objAS, NSString *propertyName) {
    FREObject result = nullptr;
    FREGetObjectProperty(objAS, (const uint8_t *) [propertyName UTF8String], &result, nullptr);
    return result;
}

void ANEHelper::setProperty(FREObject objAS, NSString *name, FREObject value) {
    FRESetObjectProperty(objAS, (const uint8_t *) [name UTF8String], value, nullptr);
}

void ANEHelper::setProperty(FREObject objAS, NSString *name, NSString *value) {
    FRESetObjectProperty(objAS, (const uint8_t *) [name UTF8String], getFREObject(value), nullptr);
}

void ANEHelper::setProperty(FREObject objAS, NSString *name, double value) {
    FRESetObjectProperty(objAS, (const uint8_t *) [name UTF8String], getFREObject(value), nullptr);
}

void ANEHelper::setProperty(FREObject objAS, NSString *name, bool value) {
    FRESetObjectProperty(objAS, (const uint8_t *) [name UTF8String], getFREObject(value), nullptr);
}

void ANEHelper::setProperty(FREObject objAS, NSString *name, NSInteger value) {
    FRESetObjectProperty(objAS, (const uint8_t *) [name UTF8String], getFREObject(value), nullptr);
}


NSInteger ANEHelper::getNSInteger(FREObject objAS) {
    NSInteger result = 0;
    FREGetObjectAsInt32(objAS, (int32_t *) &result);
    return result;
}

double ANEHelper::getDouble(FREObject arg) {
    auto result = 0.0;
    FREGetObjectAsDouble(arg, &result);
    return result;
}

bool ANEHelper::getBool(FREObject val) {
    uint32_t result = 0;
    auto ret = false;
    FREGetObjectAsBool(val, &result);
    if (result > 0) ret = true;
    return ret;
}

NSString *ANEHelper::getNSString(FREObject arg) {
    uint32_t string1Length;
    const uint8_t *val;
    FREGetObjectAsUTF8(arg, &string1Length, &val);
    NSString *s = [NSString stringWithUTF8String:(const char *) val];
    return s;
}

id ANEHelper::getNSNumber(FREObject arg) {
    double result = 0.0;
    FREGetObjectAsDouble(arg, &result);
    return [NSNumber numberWithDouble:result];
}

uint32_t ANEHelper::getArrayLength(FREObject arrayAS) {
    FREObject arrayLengthAS = getProperty(arrayAS, @"length");
    uint32_t result = 0;
    FREGetObjectAsUint32(arrayLengthAS, &result);
    return result;
}

NSMutableArray *ANEHelper::getArray(FREObject arg) {
    NSInteger arrayLength = getArrayLength(arg);
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:arrayLength];
    for (int i = 0; i < arrayLength; ++i) {
        FREObject objAs = NULL;
        FREGetArrayElementAt(arg, i, &objAs);
        if (objAs != NULL) {
            [array addObject:getIdObject(objAs)];
        }
    }
    return array;
}

FREObject ANEHelper::createFREObject(NSString *className) {
    FREObject ret;
    FRENewObject((const uint8_t *) [className UTF8String], 0, nullptr, &ret, nullptr);
    return ret;
}

void ANEHelper::dispatchEvent(FREContext ctx, NSString *name, NSString *value) {
    FREDispatchStatusEventAsync(ctx, (const uint8_t *) [value UTF8String], (const uint8_t *) [name UTF8String]);
}

id ANEHelper::getIdObject(FREObject arg) {
    FREObjectType objectType = FRE_TYPE_NULL;
    FREGetObjectType(arg, &objectType);

    switch (objectType) {
        case FRE_TYPE_VECTOR:
        case FRE_TYPE_ARRAY:
            getArray(arg);
            break;
        case FRE_TYPE_STRING:
            return getNSString(arg);
        case FRE_TYPE_BOOLEAN: {
            uint32_t value = 0;
            FREGetObjectAsBool(arg, &value);
            return value ? @YES : @NO;
        }
        case FRE_TYPE_OBJECT: {
            FREObject result;
            FREResult status = FRECallObjectMethod(arg, (const uint8_t *) "getPropNames", 0, NULL, &result, NULL);

            if (FRE_OK == status) {
                NSArray *paramNames = getArray(result);
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                for (int i = 0; i < paramNames.count; ++i) {
                    FREObject propVal = NULL;
                    NSString *paramName = [paramNames objectAtIndex:1];
                    propVal = getProperty(arg, paramName);
                    id propval2 = getIdObject(propVal);
                    if (propval2 != nil) {
                        [dict setValue:propval2 forKey:paramName];
                    }
                }
                return dict;
            } else {
                //handle error
            }
            break;
        }
        case FRE_TYPE_NUMBER:
            return getNSNumber(arg);
        case FRE_TYPE_BYTEARRAY: //TODO
            break;
        case FRE_TYPE_BITMAPDATA: //TODO
            break;
        case FRE_TYPE_NULL:
            return nil;
        case FREObjectType_ENUMPADDING:
            break;
    }

    return nil;
}






