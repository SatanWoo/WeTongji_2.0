//
//  WTClient.h
//  WeTongjiSDK
//
//  Created by tang zhixiong on 12-11-7.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "NSUserDefaults+Addition.h"

typedef void (^WTCompletionBlock)(id resposeObject);

@interface WTClient : AFHTTPClient
{
    WTCompletionBlock _completionBlock;
}

+(WTClient *)getClient;

- (void)setCompletionBlock:(WTCompletionBlock) completionBlock;

#pragma mark -
#pragma mark user API

- (void)login:(NSString *)num password:(NSString *)password;
- (void)logoff;
- (void)activeUserWithNo:(NSString *) studentNumber
                password:(NSString *) password
                    name:(NSString *) name;

#pragma mark -
#pragma mark course API

- (void)getCourses;

#pragma mark -
#pragma mark calender API

- (void)getCalender;

@end
