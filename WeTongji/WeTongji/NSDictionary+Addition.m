//
//  NSDictionary+Addition.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-11-26.
//
//

#import "NSDictionary+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>


@implementation NSDictionary (Addition)

+(NSDictionary *) getImageLinkDictInJsonString:(NSString *) jSonString
{
    NSDictionary* result;
    id dict = [jSonString JSONFragmentValue];
    if ( [dict isKindOfClass:[NSDictionary class]] )
    {
        result = dict;
    }
    else if ( [dict isKindOfClass:[NSArray class]] )
    {
        NSMutableDictionary * temp = [[NSMutableDictionary alloc] init];
        for ( NSString * string in dict )
            temp[string] = [NSNull null];
        result = [[NSDictionary alloc] initWithDictionary:temp];
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
