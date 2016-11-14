//
//  Bridge.h
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#import "ANXBridgeCall.h"

@interface ANXBridgeImpl : NSObject

+(BOOL) setup: (uint32_t*) numFunctionsToSet functions: (FRENamedFunction**) functionsToSet;

+(ANXBridgeCall*) call: (FREContext) context;

+(void) remove: (ANXBridgeCall*) call;

@end

# pragma mark C API

#pragma mark Initializer/Finalizer

FREObject ANXBridgeCallGetValue(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);
FREObject ANXBridgeCallGetError(FREContext context, void* functionData, uint32_t argc, FREObject argv[]);

void ANXBridgeInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void ANXBridgeFinalizer(void* extData);
