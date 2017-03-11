// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"

#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__SwiftController((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)

@import ObjectiveC;

#endif

#import <SwiftIOSANE_FW/FlashRuntimeExtensions.h>

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

/*
 * 14 means 14 characters in Framework name
 * 20 means 20 characters in Swift Protocol name
 */
SWIFT_PROTOCOL("_TtC14SwiftIOSANE_FW22FRESwiftBridgeProtocol")
@protocol FRESwiftBridgeProtocol
- (FREResult)FRENewObjectFromBoolWithValue:(BOOL)value
                                    object:(FREObject _Nullable)object;

- (FREResult)FRENewObjectFromInt32WithValue:(int32_t)value
                                     object:(FREObject _Nullable)object;

- (FREResult)FRENewObjectFromUint32WithValue:(uint32_t)value
                                      object:(FREObject _Nullable)object;

- (FREResult)FRENewObjectFromDoubleWithValue:(double)value
                                      object:(FREObject _Nullable)object;

- (FREResult)FRENewObjectFromUTF8WithLength:(uint32_t)length
                                      value:(NSString *_Nonnull)value
                                     object:(FREObject _Nullable)object;

- (FREResult)FREGetObjectAsBoolWithObject:(FREObject _Nonnull)object
                                    value:(uint32_t *_Nullable)value;

- (FREResult)FREGetObjectAsInt32WithObject:(FREObject _Nonnull)object
                                     value:(int32_t *_Nullable)value;

- (FREResult)FREGetObjectAsUint32WithObject:(FREObject _Nonnull)object
                                      value:(uint32_t *_Nullable)value;

- (FREResult)FREGetObjectAsDoubleWithObject:(FREObject _Nonnull)object
                                      value:(double *_Nullable)value;


- (FREResult)FREGetObjectAsUTF8WithObject:(FREObject _Nonnull)object
                                   length:(uint32_t *_Nullable)length
                                    value:(const uint8_t *_Nullable *_Nullable)value;


- (FREResult)FRENewObjectWithClassName:(NSString *_Nonnull)className
                                  argc:(uint32_t)argc
                                  argv:(NSPointerArray *_Nullable)argv
                                object:(FREObject _Nonnull)object
                       thrownException:(FREObject _Nullable)thrownException;

- (FREResult)FRECallObjectMethodWithObject:(FREObject _Nonnull)object
                                methodName:(NSString *_Nonnull)className
                                      argc:(uint32_t)argc
                                      argv:(NSPointerArray *_Nullable)argv
                                    result:(FREObject _Nonnull)result
                           thrownException:(FREObject _Nullable)thrownException;


- (FREResult)FREGetObjectPropertyWithObject:(FREObject _Nonnull)object
                               propertyName:(NSString *_Nonnull)propertyName
                              propertyValue:(FREObject _Nonnull)propertyValue
                            thrownException:(FREObject _Nullable)thrownException;

- (FREResult)FRESetObjectPropertyWithObject:(FREObject _Nonnull)object
                               propertyName:(NSString *_Nonnull)propertyName
                              propertyValue:(FREObject _Nonnull)propertyValue
                            thrownException:(FREObject _Nullable)thrownException;

- (FREResult)FREDispatchStatusEventAsyncWithCtx:(FREContext _Nonnull)ctx
                                           code:(NSString *_Nonnull)code
                                          level:(NSString *_Nonnull)level;

- (FREResult)FREGetObjectTypeWithObject:(FREObject _Nullable)object
                             objectType:(FREObjectType *_Nullable)objectType;//pointer

- (FREResult)FRESetArrayElementAWithArrayOrVector:(FREObject _Nonnull)arrayOrVector
                                            index:(uint32_t)index
                                            value:(FREObject _Nonnull)value;

- (FREResult)FREGetArrayElementAWithArrayOrVector:(FREObject _Nonnull)arrayOrVector
                                            index:(uint32_t)index
                                            value:(FREObject _Nullable)value;

- (FREResult)FREGetArrayLengthWithArrayOrVector:(FREObject _Nonnull)arrayOrVector
                                         length:(uint32_t *_Nullable)length;

- (FREResult)FRESetArrayLengthWithArrayOrVector:(FREObject _Nonnull)arrayOrVector
                                         length:(uint32_t)length;

- (FREResult)FREAcquireBitmapData2WithObject:(FREObject _Nonnull)object
                             descriptorToSet:(FREBitmapData2 *_Nullable)descriptorToSet;

- (FREResult)FREReleaseBitmapDataWithObject:(FREObject _Nonnull)object;

- (FREResult)FREAcquireByteArrayWithObject:(FREObject _Nonnull)object
                            byteArrayToSet:(FREByteArray *_Nullable)byteArrayToSet;

- (FREResult)FREReleaseByteArrayWithObject:(FREObject _Nonnull)object;

- (FREResult)FRESetContextActionScriptDataWithCtx:(FREContext _Nonnull)ctx
                               actionScriptData:(FREObject _Nullable)actionScriptData;

- (FREResult)FREGetContextActionScriptDataWithCtx:(FREContext _Nonnull)ctx
                                 actionScriptData:(FREObject _Nullable)actionScriptData;

- (FREResult)FREInvalidateBitmapDataRectWithObject:(FREObject _Nonnull)object
                                         x:(uint32_t)x
                                                 y:(uint32_t)y
                                             width:(uint32_t)width
                                            height:(uint32_t)height;

- (FREResult) FRESetContextNativeDataWithCtx:(FREContext _Nonnull)ctx
                                  nativeData:(void *_Nullable)nativeData;

- (FREResult) FREGetContextNativeDataWithCtx:(FREContext _Nonnull)ctx
                                  nativeData:(void *_Nullable *_Nullable)nativeData;
@end


SWIFT_CLASS("_TtC14SwiftIOSANE_FW14FRESwiftBridge")
@interface FRESwiftBridge : NSObject
- (void)setDelegateWithBridge:(id _Nonnull)bridge;
@end
/*
 * 14 means 14 characters in Framework name
 * 15 means 15 characters in Swift Class name
 */
SWIFT_CLASS("_TtC14SwiftIOSANE_FW15SwiftController")
@interface SwiftController : NSObject

- (FREObject _Nullable)runStringTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runNumberTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runIntTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runArrayTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runObjectTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runBitmapTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runByteArrayTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runDataTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (FREObject _Nullable)runErrorTestsWithArgv:(NSPointerArray *_Nullable)argv;

- (void)setFREContextWithCtx:(FREContext _Nonnull)ctx;

- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;


@end

#pragma clang diagnostic pop
