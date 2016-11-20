//
//  ANXBridge.m
//  Bridge
//
//  Created by Max Rozdobudko on 12/24/14.
//  Copyright (c) 2014 Max Rozdobudko. All rights reserved.
//

#import "ANXBridge.h"

#include "ANXBridgeImpl.h"

@implementation ANXBridge

+(BOOL) setup: (uint32_t*) numFunctionsToSet functions: (FRENamedFunction**) functionsToSet
{
    return [ANXBridgeImpl setup:numFunctionsToSet functions:functionsToSet];
}

+(ANXBridgeCall*) call: (FREContext) context
{
    return [ANXBridgeImpl call: context];
}

+(ANXBridgeCall*) callWithId: (NSUInteger) anId
{
    return [ANXBridgeImpl obtain: anId];
}

@end
