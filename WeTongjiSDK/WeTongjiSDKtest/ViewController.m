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
    [self course];
}

#pragma - 
#pragma - method for test

-(void) login
{
    WTClient *client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData){
        NSLog(@"%@",[responseData description]);
        [self.textView setText:[responseData description]];
        NSDictionary * userInfo = [responseData objectForKey:@"User"];
        [NSUserDefaults setCurrentUserID:[userInfo objectForKey:@"UID"] session:[responseData objectForKey:@"Session"]];
    }];
    [client login:@"092814" password:@"123456"];
}

-(void) course
{
    WTClient *client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData){
        [self.textView setText:[responseData description]];
    }];
    [client getCourses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
