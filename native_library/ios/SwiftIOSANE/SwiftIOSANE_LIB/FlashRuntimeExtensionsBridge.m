//
// Created by Eoin Landy on 19/02/2017.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//

#import "FlashRuntimeExtensionsBridge.h"
#import <SwiftIOSANE_FW/FlashRuntimeExtensions.h>

@implementation FlashRuntimeExtensionsBridge {
}
- (FREResult)FREDispatchStatusEventAsyncWithCtx:(FREContext)ctx
                                           code:(NSString *_Nonnull)code
                                          level:(NSString *_Nonnull)level {
    return FREDispatchStatusEventAsync(ctx, (const uint8_t *) [code UTF8String], (const uint8_t *) [level UTF8String]);
}

- (FREResult)FRENewObjectFromBoolWithValue:(BOOL)value object:(FREObject _Nullable)object {
    return FRENewObjectFromBool(value ? 1 : 0, object);
}

- (FREResult)FRENewObjectFromInt32WithValue:(int32_t)value object:(FREObject _Nullable)object {
    return FRENewObjectFromInt32(value, object);
}

- (FREResult)FRENewObjectFromUint32WithValue:(uint32_t)value object:(FREObject _Nullable)object {
    return FRENewObjectFromUint32(value, object);
}

- (FREResult)FRENewObjectFromUTF8WithLength:(uint32_t)length value:(NSString *_Nonnull)value
                                     object:(FREObject _Nullable)object {
    return FRENewObjectFromUTF8(length, (const uint8_t *) [value UTF8String], object);
}

- (FREResult)FRENewObjectFromDoubleWithValue:(double)value object:(FREObject _Nullable)object {
    return FRENewObjectFromDouble(value, object);
}


- (FREResult)FRENewObjectWithClassName:(NSString *_Nonnull)className
                                  argc:(uint32_t)argc
                                  argv:(NSPointerArray *_Nullable)argv
                                object:(FREObject _Nonnull)object
                       thrownException:(FREObject _Nullable)thrownException {
    if (argc > 0) {
        FREObject _argv[argc];
        for (int i = 0; i < argc; ++i) {
            _argv[i] = [argv pointerAtIndex:i];
        }
        return FRENewObject((const uint8_t *) [className UTF8String], argc, _argv, object, &thrownException);
    }
    return FRENewObject((const uint8_t *) [className UTF8String], argc, NULL, object, &thrownException);

}

- (FREResult)FRECallObjectMethodWithObject:(FREObject _Nonnull)object
                                methodName:(NSString *_Nonnull)methodName
                                      argc:(uint32_t)argc
                                      argv:(NSPointerArray *_Nullable)argv
                                    result:(FREObject _Nonnull)result
                           thrownException:(FREObject _Nullable)thrownException {

    if (argc > 0) {
        FREObject _argv[argc];
        for (int i = 0; i < argc; ++i) {
            _argv[i] = [argv pointerAtIndex:i];
        }
        return FRECallObjectMethod(object, (const uint8_t *) [methodName UTF8String], argc, _argv, result, thrownException);
    }
    return FRECallObjectMethod(object, (const uint8_t *) [methodName UTF8String], argc, NULL, result, thrownException);

}

- (FREResult)FRESetArrayElementAWithArrayOrVector:(FREObject _Nonnull)arrayOrVector
                                            index:(uint32_t)index
                                            value:(FREObject _Nonnull)value {
    return FRESetArrayElementAt(arrayOrVector, index, value);
}


- (FREResult)FREGetArrayElementAWithArrayOrVector:(FREObject _Nonnull)arrayOrVector
                                            index:(uint32_t)index
                                            value:(FREObject _Nullable)value {
    return FREGetArrayElementAt(arrayOrVector, index, value);
}

- (FREResult)FREGetArrayLengthWithArrayOrVector:(FREObject _Nonnull)arrayOrVector length:(uint32_t *)length {
    return FREGetArrayLength(arrayOrVector, length);
}


- (FREResult)FRESetArrayLengthWithArrayOrVector:(FREObject _Nonnull)arrayOrVector length:(uint32_t)length {
    return FRESetArrayLength(arrayOrVector, length);
}


- (FREResult)FREGetObjectAsBoolWithObject:(FREObject _Nonnull)object value:(uint32_t *)value {
    return FREGetObjectAsBool(object, value);
}

- (FREResult)FREGetObjectAsInt32WithObject:(FREObject _Nonnull)object value:(int32_t *)value {
    return FREGetObjectAsInt32(object, value);
}

- (FREResult)FREGetObjectAsUint32WithObject:(FREObject _Nonnull)object value:(uint32_t *)value {
    return FREGetObjectAsUint32(object, value);
}

- (FREResult)FREGetObjectAsDoubleWithObject:(FREObject _Nonnull)object value:(double *)value {
    return FREGetObjectAsDouble(object, value);
}

- (FREResult)FREGetObjectAsUTF8WithObject:(FREObject _Nonnull)object
                                   length:(uint32_t *_Nullable)length
                                    value:(const uint8_t **_Nullable)value {

    return FREGetObjectAsUTF8(object, length, value);
}

- (FREResult)FREGetObjectPropertyWithObject:(FREObject _Nonnull)object
                               propertyName:(NSString *_Nonnull)propertyName
                              propertyValue:(FREObject _Nonnull)propertyValue
                            thrownException:(FREObject _Nullable)thrownException {

    return FREGetObjectProperty(object, (const uint8_t *) [propertyName UTF8String], propertyValue, &thrownException);
}


- (FREResult)FRESetObjectPropertyWithObject:(FREObject _Nonnull)object
                               propertyName:(NSString *_Nonnull)propertyName
                              propertyValue:(FREObject _Nonnull)propertyValue
                            thrownException:(FREObject _Nullable)thrownException {

    return FRESetObjectProperty(object, (const uint8_t *) [propertyName UTF8String], propertyValue, &thrownException);
}


- (FREResult)FREGetObjectTypeWithObject:(FREObject _Nullable)object objectType:(FREObjectType *_Nullable)objectType {
    return FREGetObjectType(object, objectType);
}


@end

