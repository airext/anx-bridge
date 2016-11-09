//
//  ANXBridgeConversionRoutines.h
//  ANXBridge
//
//  Created by Max Rozdobudko on 11/8/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface ANXBridgeConversionRoutines : NSObject

+(FREObject) convertNSStringToFREObject: (NSString*) string;

+(FREObject) toFREObject: (id) value;

@end
