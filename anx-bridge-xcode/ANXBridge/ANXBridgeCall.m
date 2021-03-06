//
//  ANXBridgeCall.m
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "ANXBridgeImpl.h"

#import "ANXBridgeCall.h"

@class ANXBridgeImpl;

@implementation ANXBridgeCall
{
    FREContext _context;
    NSNumber* _callId;
    
    BOOL _isCancelled;
    id _successResult;
    id _mediateResult;
    NSError* _failureReason;
}

#pragma mark Constructor

-(id) init: (FREContext) aContext callId: (NSNumber*) aCallId
{
    self = [super init];
    
    _context = aContext;
    _callId = aCallId;
    _isCancelled = NO;
    
    return self;
}

# pragma mark Getters

-(NSNumber*) getCallId
{
    return _callId;
}

-(NSInteger) getCallIndex
{
    return [_callId integerValue];
}

-(id) getResultValue
{
    return _successResult;
}

-(id) getNotifyValue
{
    return _mediateResult;
}

-(NSError*) getRejectReason
{
    return _failureReason;
}

-(BOOL) isCancelled
{
    return _isCancelled;
}

#pragma mark Methods

-(void) result: (id) value
{
    if (_isCancelled) { return; }
    
    NSLog(@"ANXBridgeCall.result:");
    
    _successResult = value;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallResult", (const uint8_t *) [[NSString stringWithFormat:@"%li", (long)[self getCallIndex]] UTF8String]);
}

-(void) reject: (NSError*) error
{
    if (_isCancelled) { return; }
    
    NSLog(@"ANXBridgeCall.error:");
    
    _failureReason = error;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallReject", (const uint8_t *) [[NSString stringWithFormat:@"%li", (long)[self getCallIndex]] UTF8String]);
}

-(void) notify: (id) value
{
    if (_isCancelled) { return; }
    
    NSLog(@"ANXBridgeCall.notify:");
    
    _mediateResult = value;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallNotify", (const uint8_t *) [[NSString stringWithFormat:@"%li", (long)[self getCallIndex]] UTF8String]);
}

-(void) cancel
{
    NSLog(@"ANXBridgeCall.cancel:");
    
    _isCancelled = YES;
    _mediateResult = nil;
    _successResult = nil;
    
    [ANXBridgeImpl remove: self];
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallCancel", (const uint8_t *) [[NSString stringWithFormat:@"%li", (long)[self getCallIndex]] UTF8String]);
}

-(FREObject) toFREObject
{
    return [self toFREObjectWithPayload: NULL];
}

-(FREObject) toFREObjectWithPayload: (FREObject) payload
{
    FREObject result;
    if (FRENewObject((const uint8_t*) "Object", 0, NULL, &result, NULL) != FRE_OK)
        return NULL;
    
    FREObject idValue;
    if (FRENewObjectFromUint32((uint32_t) [self getCallIndex], &idValue) != FRE_OK)
        return NULL;
    
    if (FRESetObjectProperty(result, (const uint8_t *) "id", idValue, NULL) != FRE_OK)
        return NULL;
    
    if (payload && FRESetObjectProperty(result, (const uint8_t *) "payload", payload, NULL) != FRE_OK)
        return NULL;
    
    return result;
}

@end
