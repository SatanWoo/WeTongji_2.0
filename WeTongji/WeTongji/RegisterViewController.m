//
//  RegisterViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "RegisterViewController.h"
#import "RegInfomationCell.h"
#import "Macro.h"
#define kMailURL @"mail.tongji.edu.cn"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)registerMail:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kMailURL]];
}
@end
