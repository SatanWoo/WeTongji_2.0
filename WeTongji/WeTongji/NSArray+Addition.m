//
//  NSArray+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-19.
//
//

#import "NSArray+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation NSArray (Addition)

+(NSArray *) getImageLinkListInJsonString:(NSString *) jSonString
{
    NSArray* result;
    id dict = [jSonString JSONFragmentValue];
    if ( [dict respondsToSelector:@selector(allKeys)] )
    {
        result = [dict allKeys];
    }
    else if ( [dict isKindOfClass:[NSArray class]] )
    {
        result = dict;
    }
    else
    {
#ifdef DEBUG
        NSLog(@"ImageLinkList is Empty :%@",jSonString);
#endif
        result = nil;
    }
    return result;
}

@end
