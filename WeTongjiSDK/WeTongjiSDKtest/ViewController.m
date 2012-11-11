//
//  ViewController.m
//  WeTongjiSDKtest
//
//  Created by tang zhixiong on 12-11-5.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import "ViewController.h"
#import "WeTongjiSDK.h"
#import "NSDictionary+DefaultDescription.h"
#import "JSON.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self login];
    //[self course];
    //[self update];
    //[self channel];
    //[self favorite];
    //[self information];
    //[self star];
    //[self activity];
    //[self uploadavatar];
}

#pragma - 
#pragma - method for test

-(void) uploadavatar
{
    WTClient *client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData){
        [self.textView setText:[responseData description]];
    }];
    [client updateUserAvatar:[[UIImage alloc] initWithContentsOfFile:@"/Users/tangzhixiong/Desktop/wetongji2_ios_rain/WeTongjiSDK/WeTongjiSDKtest/blackArrow.png"]];
}

-(void) login
{
    WTClient *client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData)
    {
        NSString * hasError = [responseData objectForKey:@"isFailed"];
        if( [hasError characterAtIndex:0] == 'N' )
            NSLog(@"%@",responseData);
    }];
    [client login:@"092983" password:@"123456"];
}

-(void) course
{
    WTClient *client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData){
        [self.textView setText:[responseData description]];
    }];
    [client getCourses];
}

-(void)update
{
    WTClient * client = [ WTClient getClient];
    [client setCompletionBlock:^(id responseData) { NSLog(@"%@",responseData);}];
    [client updateUserDisplayName:nil email:nil weiboName:@"dre" phoneNum:nil qqAccount:nil];
}

-(void) channel
{
    WTClient * client = [ WTClient getClient];
    [client setCompletionBlock:^(id responseData) { NSLog(@"%@",responseData);}];
    [client getChannels];
}

- (void) activity
{
    WTClient * client = [ WTClient getClient];
    [client setCompletionBlock:^(id responseData) { NSLog(@"%@",[responseData description]);}];
    [client getActivitiesInChannel:nil inSort:@"1" Expired:YES nextPage:0];
    [client getActivitiesInChannel:nil inSort:@"1" Expired:YES nextPage:1];
    [client getActivitiesInChannel:nil inSort:@"1" Expired:YES nextPage:2];
}

- (void) favorite
{
    WTClient * client = [ WTClient getClient];
    [client setCompletionBlock:^(id responseData) { NSLog(@"%@",[responseData description]);}];
    [client getFavoritesWithNextPage:0];
}

- (void) information
{
    WTClient * client = [ WTClient getClient];
    [client setCompletionBlock:^(id responseData) { NSLog(@"%@",[responseData description]);}];
    [client getAllInformationInSort:nil nextPage:0];
}

- (void) star
{
    WTClient * client = [ WTClient getClient];
    [client setCompletionBlock:^(id responseData) { NSLog(@"%@",[responseData description]);}];
    [client getAllStarsWithNextPage:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
