//
//  Bridge.m
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "ANXBridgeConversionRoutines.h"

#import "ANXBridgeImpl.h"

@implementation ANXBridgeImpl

#pragma mark Class variables

static const NSInteger MAX_QUEUE_LENGTH = 1000000;

static NSMutableDictionary* asyncCallQueue = nil;

static NSInteger currentCallIndex = 0;

#pragma mark Class Public Methods

+(BOOL) setup:(uint32_t *)numFunctionsToSet functions:(FRENamedFunction **)functionsToSet
{
    NSLog(@"ANXBridge.setup()");
    
    uint32_t count = *numFunctionsToSet;
    
    *numFunctionsToSet = count + 2;
    
    FRENamedFunction* func = realloc((void *) *functionsToSet, sizeof(FRENamedFunction) * (*numFunctionsToSet));
    
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
    NSLog(@"ANXBridge.call()");
    
    if (asyncCallQueue == nil)
        asyncCallQueue = [[NSMutableDictionary alloc] init];
    
    NSNumber* callId = [NSNumber numberWithInteger: currentCallIndex++];
    
    if (currentCallIndex > MAX_QUEUE_LENGTH)
    {
        currentCallIndex = 0;
    }
    
    ANXBridgeCall* call = [[ANXBridgeCall alloc] init: context callId: callId];
    
    [asyncCallQueue setObject:call forKey: callId];
    
    #if ! __has_feature(objc_arc)
    CFRelease(call);
    #endif
    
    return call;
}

+(void) remove: (ANXBridgeCall*) call
{
    NSLog(@"ANXBridge.remove()");
    
    if (asyncCallQueue == nil)
        return;
    
    [asyncCallQueue removeObjectForKey: [call getCallId]];
}

+(ANXBridgeCall*) obtain: (NSUInteger) anId
{
    NSLog(@"ANXBridge.obtain()");
    
    if (asyncCallQueue == nil)
        return nil;

    @try
    {
        ANXBridgeCall* call = [asyncCallQueue objectForKey: [NSNumber numberWithInteger: anId]];
        
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
            
            result = [ANXBridgeConversionRoutines toFREObject: successResult];
            
            [ANXBridgeImpl remove: call];
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
