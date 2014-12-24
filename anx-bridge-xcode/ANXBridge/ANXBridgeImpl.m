//
//  Bridge.m
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "ANXBridgeImpl.h"

@implementation ANXBridgeImpl

#pragma mark Class variables

static NSMutableArray* asyncCallStack = nil;

#pragma mark Class Public Methods

+(BOOL) setup:(uint32_t *)numFunctionsToSet functions:(FRENamedFunction **)functionsToSet
{
    NSLog(@"ANXBridge.setup()");
    
    uint32_t count = *numFunctionsToSet;
    
    *numFunctionsToSet = count + 2;
    
    FRENamedFunction* func = realloc((void *) *functionsToSet, sizeof(FRENamedFunction) * (*numFunctionsToSet));
    
    NSLog(@"blalba: %u, %u", count, count + 1);
    
    func[count].name = (const uint8_t*) "ANXBridgeCallGetValue";
    func[count].functionData = NULL;
    func[count].function = &ANXBridgeCallGetValue;
    
    func[count + 1].name = (const uint8_t*) "ANXBridgeCallGetError";
    func[count + 1].functionData = NULL;
    func[count + 1].function = &ANXBridgeCallGetError;
    
    *functionsToSet = func;
    
    return YES;
}

+(ANXBridgeCall*) call: (FREContext) context
{
    NSLog(@"ANXBridgeCall.created");
    
    if (!asyncCallStack)
        asyncCallStack = [[NSMutableArray alloc] init];
    
    NSLog(@"ANXBridgeCall.created 1");
    
    NSUInteger count = [asyncCallStack count];
    
    ANXBridgeCall* call = [[ANXBridgeCall alloc] init:context callId:count];
    
    NSLog(@"ANXBridgeCall.created 2");
    
    [asyncCallStack addObject: call];
    
    NSLog(@"Call created");
    
    #if ! __has_feature(objc_arc)
        CFRelease(call);
    #endif
    
    return call;
}

+(void) remove: (ANXBridgeCall*) call
{
    if (!asyncCallStack)
        return;
    
    [asyncCallStack removeObject:call];
}

+(ANXBridgeCall*) obtain: (NSUInteger) anId
{
    if (!asyncCallStack)
        return nil;
    
    if ([asyncCallStack count] <= anId)
        return nil;
    
    @try
    {
        ANXBridgeCall *call = [asyncCallStack objectAtIndex:anId];
        
        return call;
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    @finally{}
}

@end

#pragma mark Class Private Methods

FREObject ANXBridgeCallGetValue(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    NSLog(@"ANXBridgeCallGetValue");
    
    FREObject result = NULL;
    
    if (argc > 0)
    {
        uint32_t incomingCallId;
        
        FREGetObjectAsUint32(argv[0], &incomingCallId);
        
        ANXBridgeCall *call = [ANXBridgeImpl obtain:(NSUInteger) incomingCallId];
        
        if (call)
        {
            id successResult = [call getResultValue];
            
            if (successResult)
            {
                SEL selector = NSSelectorFromString(@"toFREObject");
                IMP imp = [successResult methodForSelector:selector];
                
                FREObject (*func)(id, SEL) = (void *)imp;
                result = func(successResult, selector);
            }
            
            [ANXBridgeImpl remove:call];
        }
    }
    
    return result;
}

FREObject ANXBridgeCallGetError(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    NSLog(@"ANXBridgeCallGetError");
    
    FREObject result = NULL;
    
    NSLog(@"ANXBridgeCallGetError argc: %u", argc);
    
    if (argc > 0)
    {
        uint32_t incomingCallId;
        
        FREGetObjectAsUint32(argv[0], &incomingCallId);
        
        ANXBridgeCall *call = [ANXBridgeImpl obtain:(NSUInteger) incomingCallId];
        
        NSLog(@"ANXBridgeCallGetError call: %@", call);
        
        if (call)
        {
            NSError *failureReason = [call getRejectReason];
            
            const char* errorDescriptionAsUTF8;
            
            if (failureReason)
            {
                errorDescriptionAsUTF8 = [[failureReason description] UTF8String];
            }
            else
            {
                errorDescriptionAsUTF8 = (const char*)"Undefined Error";
            }
            
            unsigned long length = strlen(errorDescriptionAsUTF8);
            
            FREObject errorDescription;
            FRENewObjectFromUTF8((uint32_t) length + 1, (const uint8_t*) errorDescriptionAsUTF8, &errorDescription);
            
            result = errorDescription;
            
            [ANXBridgeImpl remove:call];
        }
    }
    
    return result;
}

void ANXBridgeInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    
}

void ANXBridgeFinalizer(void* extData)
{
    
}