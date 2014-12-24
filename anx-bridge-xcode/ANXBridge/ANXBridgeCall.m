//
//  ANXBridgeCall.m
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "ANXBridgeCall.h"

@implementation ANXBridgeCall

#pragma mark Constructor

-(id) init: (FREContext) aContext callId: (NSUInteger) aCallId
{
    self = [super init];
    
    _context = aContext;
    _callId = aCallId;
    
    return self;
}

#pragma mark Properties




//@synthesize context = _context;
//
//@dynamic callId;
//
//@dynamic completionValue;
//
//@dynamic failureReason;

# pragma mark Variables

FREContext _context;

NSUInteger _callId;

# pragma mark Getters

id _successResult;

-(id) getResultValue
{
    return _successResult;
}

NSError* _failureReason;

-(NSError*) getRejectReason
{
    return _failureReason;
}

#pragma mark Methods

-(void) result: (id) value
{
    NSLog(@"ANXBridgeCall.result:");
    
    _successResult = value;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallResult", (const uint8_t *) [[NSString stringWithFormat:@"%lu", (unsigned long)_callId] UTF8String]);
}

-(void) reject: (NSError*) error
{
    NSLog(@"ANXBridgeCall.error:");
    
    _failureReason = error;
    
    FREDispatchStatusEventAsync(_context, (const uint8_t *) "ANXBridgeCallReject", (const uint8_t *) [[NSString stringWithFormat:@"%lu", (unsigned long)_callId] UTF8String]);
}

-(FREObject) toFREObject
{
    FREObject result;
    
    FRENewObjectFromUint32((uint32_t) _callId, &result);
    
    return result;
}
@end
