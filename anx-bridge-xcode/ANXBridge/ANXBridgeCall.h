//
//  ANXBridgeCall.h
//  Bridge
//
//  Created by Max Rozdobudko on 12/22/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

@interface ANXBridgeCall : NSObject

#pragma mark Constructor

-(id) init: (FREContext) aContext callId: (NSNumber*) aCallId;

# pragma mark Getters

-(NSNumber*) getCallId;

-(NSInteger) getCallIndex;

-(id) getResultValue;

-(id) getNotifyValue;

-(NSError*) getRejectReason;

# pragma mark Methods

-(void) result: (id) value;

-(void) reject: (NSError*) error;

-(void) notify: (id) value;

-(FREObject) toFREObject;

-(FREObject) toFREObjectWithPayload: (FREObject) payload;

@end
