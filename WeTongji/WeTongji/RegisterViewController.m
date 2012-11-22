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

#define kMailURL @"http://mail.tongji.edu.cn"

@interface RegisterViewController ()

@end

@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillUnload
{
    [super viewWillUnload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)registerMail:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kMailURL]];
}
@end
