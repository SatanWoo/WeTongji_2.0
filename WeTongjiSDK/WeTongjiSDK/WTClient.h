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

+(WTClient *)getClient;

- (void)setCompletionBlock:(WTCompletionBlock) completionBlock;

#pragma mark -
#pragma mark user API

- (void)login:(NSString *)num password:(NSString *)password;
- (void)logoff;
- (void)activeUserWithNo:(NSString *) studentNumber
                password:(NSString *) password
                    name:(NSString *) name;
- (void)updateUserDisplayName:(NSString *)display_name
                        email:(NSString *)email
                    weiboName:(NSString *)weibo
                     phoneNum:(NSString *)phone
                    qqAccount:(NSString *)qq;
- (void)updatePassword:(NSString *)new withOldPassword:(NSString *)old;
- (void)updateUserAvatar:(UIImage *)image;

#pragma mark -
#pragma mark course API

- (void)getCourses;

#pragma mark -
#pragma mark calender API

- (void)getScheduleWithBeginDate:(NSDate *)begin endDate:(NSDate *)end;

#pragma mark -
#pragma mark channel API

- (void) setChannelFavored:(NSString *) channelId;
- (void) cancelChannelFavored:(NSString *) channelId;
- (void) getChannels;

#pragma mark -
#pragma mark activity API

- (void) getActivitiesInChannel:(NSString *) channelId
                         inSort:(NSString *) sort
                        Expired:(Boolean) isExpired;
- (void) setLikeActivitiy:(NSString *) activityId;
- (void) cancelLikeActivity:(NSString *) activityId;
- (void) setActivityFavored:(NSString *) activityId;
- (void) cancelActivityFavored:(NSString *) activityId;

#pragma -
#pragma - favorite API

- (void) getFavorites;

#pragma -
#pragma - Information API

- (void) getAllInformationInSort:(NSString *) sort;
- (void) getDetailOfInformaion:(NSString *) informationId;
- (void) readInformaion:(NSString *) informationId;

#pragma -
#pragma - Vision API

- (void) getNewVersion;

#pragma -
#pragma - Star API

- (void) getLatestStar;
- (void) getAllStars;


@end
