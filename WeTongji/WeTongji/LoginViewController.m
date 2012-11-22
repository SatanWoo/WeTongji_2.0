//
//  LoginViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "LoginViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "User+Addition.h"
#import "Macro.h"
#import "MBProgressHUD.h"
#import "NSArray+Addition.h"

@interface LoginViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UITextField *NOTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong,nonatomic) MBProgressHUD * progress;
- (void)configureButton;
- (void)enableButton:(NSNotification *)notification;
@end

@implementation LoginViewController

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
        _progress.labelText = @"登录中...";
    }
    return _progress;
}

- (void)configureButton
{
    self.closeBtn.hidden = YES;
}

- (void)enableButton:(NSNotification *)notification
{
    self.view.userInteractionEnabled = YES;
    self.navButton.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureButton];
    [self.navigationItem setHidesBackButton:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableButton:) name:kEnableInteractionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setScrollVIew:nil];
    [self setNOTextField:nil];
    [self setPasswordTextField:nil];
    [self setCloseBtn:nil];
    [self setPasswordForgetBtn:nil];
    [self setNavButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignAllFirstResponder
{
    [self.NOTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (IBAction)textEditDidBegin:(id)sender
{
    self.closeBtn.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(-90, 0, 580, 0);
    [UIView commitAnimations];
}

- (IBAction)textDidEndEdit:(id)sender
{
    [self resignAllFirstResponder];
    [self configureButton];
}

- (IBAction)logInClick:(id)sender
{
    
    [self.progress show:YES];
    [self resignAllFirstResponder];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock: ^(id responseData)
    {
        [NSUserDefaults setCurrentUserID:[[responseData objectForKey:@"User"] objectForKey:@"UID"] session:[responseData objectForKey:@"Session"]];
        [User updateUser:[responseData objectForKey:@"User"] inManagedObjectContext:self.managedObjectContext];
        NSLog(@"%@",responseData);
        self.progress.labelText = @"登陆成功";
        [self.progress hide:YES afterDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self];
    }failureBlock:^(NSError * error)
    {
        self.progress.labelText = [[error userInfo] objectForKey:@"errorDesc"];
        self.progress.mode = MBProgressHUDModeCustomView;
        [self.progress hide:YES afterDelay:1];
    }];
    [request login:self.NOTextField.text password:self.passwordTextField.text];
    [client enqueueRequest:request];
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    self.progress = nil;
}

- (IBAction)slide:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlideNotification object:self];
}
@end
