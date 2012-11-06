//
//  NSDictionary+DefaultDescription.m
//  WeTongjiSDK
//
//  Created by tang zhixiong on 12-11-6.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import "NSDictionary+DefaultDescription.h"

@implementation NSDictionary (DefaultDescription)

-(NSString *) description
{
    NSArray *keys = [self allKeys];
    NSString * result = @"\n{\n";
    for ( NSString *tempString in keys )
    {
        result = [result stringByAppendingString:tempString];
        result = [result stringByAppendingString:@" = "];
        result = [result stringByAppendingString:[[self objectForKey:tempString] description]];
        result = [result stringByAppendingString:@"\n"];
    }
    result = [result stringByAppendingString:@"}"];
    return result;
}

@end
