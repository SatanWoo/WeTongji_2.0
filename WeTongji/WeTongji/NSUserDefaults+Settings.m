//
//  NSUserDefaults+Settings.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-11-25.
//
//

#import "NSUserDefaults+Settings.h"

#define kInformationDefaultType @"kInformationDefaultType"

@implementation NSUserDefaults (Settings)

+(void) setInformationDefaultType:(InformationDefaultType)type
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt: type] forKey:kInformationDefaultType];
    [userDefaults synchronize];
}

+ (InformationDefaultType)getInformationDefaultType
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:kInformationDefaultType] intValue];
}

@end
