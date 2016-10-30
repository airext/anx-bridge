//
//  ANXBridgeCall.m
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "ANXBridgeCall.h"

@implementation ANXBridgeCall
{
    FREContext _context;
    NSNumber* _callId;
    
    id _successResult;
    NSError* _failureReason;
}

#pragma mark Constructor

-(id) init: (FREContext) aContext callId: (NSNumber*) aCallId
{
    self = [super init];
    
    _context = aContext;
    _callId = aCallId;
    
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


-(NSError*) getRejectReason
{
    return _failureReason;
}

#pragma mark Methods

-(void) result: (id) value
{
    NSLog(@"ANXBridgeCall.result:");
    
    _successResult = value;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallResult", (const uint8_t *) [[NSString stringWithFormat:@"%li", [self getCallIndex]] UTF8String]);
}

-(void) reject: (NSError*) error
{
    NSLog(@"ANXBridgeCall.error:");
    
    _failureReason = error;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallReject", (const uint8_t *) [[NSString stringWithFormat:@"%li", [self getCallIndex]] UTF8String]);
}

-(FREObject) toFREObject
{
    FREObject result;
    
    FRENewObjectFromUint32((uint32_t) [self getCallIndex], &result);
    
    return result;
}
@end
