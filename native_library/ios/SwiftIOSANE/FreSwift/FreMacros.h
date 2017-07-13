//
//  FreMacros.h
//  SwiftIOSANE
//
//  Created by Eoin Landy on 13/07/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

#ifndef FreMacros_h
#define FreMacros_h

#if __APPLE__
#include "TargetConditionals.h"
#if (TARGET_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE)
#define IOS
#elif TARGET_OS_MAC
#define OSX
#else
#   error "Unknown Apple platform"
#endif
#endif

#import <Foundation/Foundation.h>
#import <FreSwift/FlashRuntimeExtensions.h>
#import <FreSwift/FreSwift-Swift.h>

#define NSStringize_helper(x) #x
#define NSStringize(x) @NSStringize_helper(x)
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(prefix, fn) { (const uint8_t*)(#fn), (__bridge void *)(NSStringize(fn)), &prefix##_callSwiftFunction }

#define CONTEXT_INIT(prefix) void (prefix##_contextInitializer)(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet)

#define CONTEXT_FIN(prefix) void (prefix##_contextFinalizer) (FREContext ctx)

#define EXTENSION_INIT_DECL(prefix) void (prefix##ExtInizer) (void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer)


#define EXTENSION_INIT(prefix) void (prefix##ExtInizer) (void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) { \
*ctxInitializer = &prefix##_contextInitializer; \
*ctxFinalizer = &prefix##_contextFinalizer; \
}

#define EXTENSION_FIN_DECL(prefix) void (prefix##ExtFinizer) (void *extData)
#define EXTENSION_FIN(prefix) void (prefix##ExtFinizer) (void *extData) { \
}


#define SWIFT_DECL(prefix) prefix##_FlashRuntimeExtensionsBridge *freBridge; \
SwiftController *swft;  \
FreSwiftBridge *swftBridge;  \
NSArray * funcArray; \
FREObject (prefix##_callSwiftFunction) (FREContext context, void* functionData, uint32_t argc, FREObject argv[]) {\
NSString* name = (__bridge NSString *)(functionData); \
NSString* fName = [NSString stringWithFormat:@"%@%@", NSStringize(prefix)"_", name]; \
return [swft callSwiftFunctionWithName:fName ctx:context argc:argc argv:argv]; \
}

#ifdef IOS
#define SWIFT_INITS(prefix) swft = [[SwiftController alloc] init]; \
[swft setFREContextWithCtx:ctx]; \
freBridge = [[prefix##_FlashRuntimeExtensionsBridge alloc] init]; \
swftBridge = [[FreSwiftBridge alloc] init]; \
[swftBridge setDelegateWithBridge:freBridge]; \
funcArray = [swft getFunctionsWithPrefix:NSStringize(prefix)"_"];
#else
#define SWIFT_INITS(prefix) swft = [[SwiftController alloc] init]; \
[swft setFREContextWithCtx:ctx]; \
funcArray = [swft getFunctionsWithPrefix:NSStringize(prefix)"_"];
#endif


#ifdef IOS
#define FRE_OBJC_BRIDGE_FUNCS \
- (FREResult)FREDispatchStatusEventAsyncWithCtx:(FREContext)ctx \
code:(NSString *_Nonnull)code \
level:(NSString *_Nonnull)level { \
return FREDispatchStatusEventAsync(ctx, (const uint8_t *) [code UTF8String], (const uint8_t *) [level UTF8String]); \
} \
- (FREResult)FRENewObjectFromBoolWithValue:(BOOL)value object:(FREObject _Nullable)object { \
return FRENewObjectFromBool(value ? 1 : 0, object); \
} \
- (FREResult)FRENewObjectFromInt32WithValue:(int32_t)value object:(FREObject _Nullable)object { \
return FRENewObjectFromInt32(value, object); \
} \
- (FREResult)FRENewObjectFromUint32WithValue:(uint32_t)value object:(FREObject _Nullable)object { \
return FRENewObjectFromUint32(value, object); \
} \
- (FREResult)FRENewObjectFromUTF8WithLength:(uint32_t)length value:(NSString *_Nonnull)value \
object:(FREObject _Nullable)object { \
return FRENewObjectFromUTF8(length, (const uint8_t *) [value UTF8String], object); \
} \
- (FREResult)FRENewObjectFromDoubleWithValue:(double)value object:(FREObject _Nullable)object { \
return FRENewObjectFromDouble(value, object); \
} \
- (FREResult)FRENewObjectWithClassName:(NSString *_Nonnull)className \
argc:(uint32_t)argc \
argv:(NSPointerArray *_Nullable)argv \
object:(FREObject _Nonnull)object \
thrownException:(FREObject _Nullable)thrownException { \
if (argc > 0) { \
FREObject _argv[argc]; \
for (int i = 0; i < argc; ++i) { \
_argv[i] = [argv pointerAtIndex:i]; \
} \
return FRENewObject((const uint8_t *) [className UTF8String], argc, _argv, object, &thrownException); \
} \
return FRENewObject((const uint8_t *) [className UTF8String], argc, NULL, object, &thrownException); \
\
} \
\
- (FREResult)FRECallObjectMethodWithObject:(FREObject _Nonnull)object \
methodName:(NSString *_Nonnull)methodName \
argc:(uint32_t)argc \
argv:(NSPointerArray *_Nullable)argv \
result:(FREObject _Nonnull)result \
thrownException:(FREObject _Nullable)thrownException { \
\
if (argc > 0) { \
FREObject _argv[argc]; \
for (int i = 0; i < argc; ++i) { \
_argv[i] = [argv pointerAtIndex:i]; \
} \
return FRECallObjectMethod(object, (const uint8_t *) [methodName UTF8String], argc, _argv, result, thrownException); \
} \
return FRECallObjectMethod(object, (const uint8_t *) [methodName UTF8String], argc, NULL, result, thrownException); \
\
} \
\
- (FREResult)FRESetArrayElementAWithArrayOrVector:(FREObject _Nonnull)arrayOrVector \
index:(uint32_t)index \
value:(FREObject _Nonnull)value { \
return FRESetArrayElementAt(arrayOrVector, index, value); \
} \
\
\
- (FREResult)FREGetArrayElementAWithArrayOrVector:(FREObject _Nonnull)arrayOrVector \
index:(uint32_t)index \
value:(FREObject _Nullable)value { \
return FREGetArrayElementAt(arrayOrVector, index, value); \
} \
\
- (FREResult)FREGetArrayLengthWithArrayOrVector:(FREObject _Nonnull)arrayOrVector length:(uint32_t *)length { \
return FREGetArrayLength(arrayOrVector, length); \
} \
\
\
- (FREResult)FRESetArrayLengthWithArrayOrVector:(FREObject _Nonnull)arrayOrVector length:(uint32_t)length { \
return FRESetArrayLength(arrayOrVector, length); \
} \
\
\
- (FREResult)FREGetObjectAsBoolWithObject:(FREObject _Nonnull)object value:(uint32_t *)value { \
return FREGetObjectAsBool(object, value); \
} \
\
- (FREResult)FREGetObjectAsInt32WithObject:(FREObject _Nonnull)object value:(int32_t *)value { \
return FREGetObjectAsInt32(object, value); \
} \
\
- (FREResult)FREGetObjectAsUint32WithObject:(FREObject _Nonnull)object value:(uint32_t *)value { \
return FREGetObjectAsUint32(object, value); \
} \
\
- (FREResult)FREGetObjectAsDoubleWithObject:(FREObject _Nonnull)object value:(double *)value { \
return FREGetObjectAsDouble(object, value); \
} \
\
- (FREResult)FREGetObjectAsUTF8WithObject:(FREObject _Nonnull)object \
length:(uint32_t *_Nullable)length \
value:(const uint8_t **_Nullable)value { \
\
return FREGetObjectAsUTF8(object, length, value); \
} \
\
- (FREResult)FREGetObjectPropertyWithObject:(FREObject _Nonnull)object \
propertyName:(NSString *_Nonnull)propertyName \
propertyValue:(FREObject _Nonnull)propertyValue \
thrownException:(FREObject _Nullable)thrownException { \
\
return FREGetObjectProperty(object, (const uint8_t *) [propertyName UTF8String], propertyValue, &thrownException); \
} \
\
\
- (FREResult)FRESetObjectPropertyWithObject:(FREObject _Nonnull)object \
propertyName:(NSString *_Nonnull)propertyName \
propertyValue:(FREObject _Nonnull)propertyValue \
thrownException:(FREObject _Nullable)thrownException { \
\
return FRESetObjectProperty(object, (const uint8_t *) [propertyName UTF8String], propertyValue, &thrownException); \
} \
\
\
- (FREResult)FREGetObjectTypeWithObject:(FREObject _Nullable)object objectType:(FREObjectType *_Nullable)objectType { \
return FREGetObjectType(object, objectType); \
} \
\
- (FREResult)FREAcquireBitmapData2WithObject:(FREObject _Nonnull)object \
descriptorToSet:(FREBitmapData2 *_Nullable)descriptorToSet { \
return FREAcquireBitmapData2(object, descriptorToSet); \
} \
\
- (FREResult)FREReleaseBitmapDataWithObject:(FREObject _Nonnull)object { \
return FREReleaseBitmapData(object); \
} \
\
- (FREResult)FREAcquireByteArrayWithObject:(FREObject _Nonnull)object \
byteArrayToSet:(FREByteArray *_Nullable)byteArrayToSet { \
return FREAcquireByteArray(object, byteArrayToSet); \
} \
\
- (FREResult)FREReleaseByteArrayWithObject:(FREObject _Nonnull)object { \
return FREReleaseByteArray(object); \
} \
\
\
- (FREResult)FRESetContextActionScriptDataWithCtx:(FREContext _Nonnull)ctx \
actionScriptData:(FREObject _Nullable)actionScriptData { \
return FRESetContextActionScriptData(ctx, actionScriptData); \
} \
\
- (FREResult)FREGetContextActionScriptDataWithCtx:(FREContext _Nonnull)ctx \
actionScriptData:(FREObject _Nullable)actionScriptData { \
return FREGetContextActionScriptData(ctx, actionScriptData); \
} \
\
- (FREResult)FREInvalidateBitmapDataRectWithObject:(FREObject _Nonnull)object \
x:(uint32_t)x \
y:(uint32_t)y \
width:(uint32_t)width \
height:(uint32_t)height { \
return FREInvalidateBitmapDataRect(object, x, y, width, height); \
} \
\
- (FREResult)FRESetContextNativeDataWithCtx:(FREContext _Nonnull)ctx \
nativeData:(void *_Nullable)nativeData { \
return FRESetContextNativeData(ctx, nativeData); \
\
} \
\
- (FREResult)FREGetContextNativeDataWithCtx:(FREContext _Nonnull)ctx \
nativeData:(void **_Nullable)nativeData { \
return FREGetContextNativeData(ctx, nativeData); \
};
#endif
#endif /* FreMacros_h */
