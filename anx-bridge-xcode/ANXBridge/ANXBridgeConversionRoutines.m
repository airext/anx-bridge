//
//  ANXBridgeConversionRoutines.m
//  ANXBridge
//
//  Created by Max Rozdobudko on 11/8/16.
//  Copyright © 2016 Max Rozdobudko. All rights reserved.
//

#import "ANXBridgeConversionRoutines.h"

@implementation ANXBridgeConversionRoutines

+(FREObject) convertNSStringToFREObject:(NSString*) string
{
    if (string == nil) return NULL;
    
    const char* utf8String = string.UTF8String;
    
    unsigned long length = strlen( utf8String );
    
    FREObject converted;
    FREResult result = FRENewObjectFromUTF8((uint32_t) length + 1, (const uint8_t*) utf8String, &converted);
    
    if (result != FRE_OK)
        return NULL;
    
    return converted;
}

+(FREObject) toFREObject: (id) value
{
    if (value)
    {
        if ([value isKindOfClass: [NSArray class]])
        {
            NSArray* list = (NSArray*) value;
            
            FREObject result;
            
            if (FRENewObject((const uint8_t*) "Array", 0, NULL, &result, NULL) != FRE_OK)
            {
                return NULL;
            }
            
            if (FRESetArrayLength(result, (uint32_t) list.count) != FRE_OK)
            {
                return NULL;
            }
            
            for (int i = 0; i < list.count; i++)
            {
                id item = [list objectAtIndex: i];
            
                FRESetArrayElementAt(result, (uint32_t) i, [self convert: item]);
            }
            
            return result;
        }
        else
        {
            return [self convert: value];
        }
    }
    
    return NULL;
}

+(FREObject) convert: (id) value
{
    FREObject result;
    
    if (value)
    {
        if ([value isKindOfClass: [NSString class]])
        {
            result = [self convertNSStringToFREObject:(NSString *) value];
        }
        else
        {
            SEL selector = NSSelectorFromString(@"toFREObject");
            IMP imp = [value methodForSelector:selector];
            
            FREObject (*func)(id, SEL) = (void *)imp;
            result = func(value, selector);
        }
    }
    
    return result;

}

@end
