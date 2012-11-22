//
//  RegisterSecondViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-18.
//
//

#import "RegisterSecondViewController.h"
#import "Macro.h"
#import "UIBarButtonItem+CustomButton.h"
#import "MBProgressHUD.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface RegisterSecondViewController ()<MBProgressHUDDelegate>
@property (nonatomic,strong) MBProgressHUD * progress;
- (void)configureScrollView;
@end

@implementation RegisterSecondViewController

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.mode = MBProgressHUDModeIndeterminate;
        _progress.delegate = self;
    }
    return _progress;
}

-(void) passwordConfirmFailed
{
    [self.progress show:YES];
    self.progress.mode = MBProgressHUDModeText;
    self.progress.labelText = @"确认密码不符";
    [self.progress hide:YES afterDelay:1];
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    if ( [hud.labelText isEqualToString:@"注册成功"] )
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.progress removeFromSuperview];
    self.progress = nil;
}

#pragma mark - Private

- (void)configureScrollView
{
    CGRect frame = self.scrollView.frame;
    frame.size.height += 30;
    self.scrollView.contentSize = frame.size;
    
    [self.stuNumber becomeFirstResponder];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setStuNumber:nil];
    [self setName:nil];
    [self setPassword:nil];
    [self setConfirmPassword:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void)resignAllFirstResponder
{
    [self.stuNumber resignFirstResponder];
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.stuNumber) {
        [self.name becomeFirstResponder];
    } else if(textField == self.name) {
        [self.password becomeFirstResponder];
    } else if(textField == self.password) {
        [self.confirmPassword becomeFirstResponder];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self resignAllFirstResponder];
    }
    return NO;
}

- (IBAction)touchOnTextFiled:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y / 3 * 2 - 5) animated:YES];
}

- (IBAction)textDidEndEdit:(id)sender
{
    [self resignAllFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (IBAction)registerClicked:(id)sender
{
    [self resignAllFirstResponder];
    if ( ![self.password.text isEqualToString:self.confirmPassword.text])
    {
        [self passwordConfirmFailed];
        return ;
    }
    [self.progress show:YES];
    self.progress.labelText = @"密码更新中...";
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                            #ifdef DEBUG
                               NSLog(@"%@",responseData);
                            #endif
                               self.progress.mode = MBProgressHUDModeText;
                               self.progress.labelText = @"注册成功";
                               [self.progress hide:YES afterDelay:1];
                           }
                                                failureBlock:^(NSError * error )
                           {
                            #ifdef DEBUG
                               NSLog(@"registerFailed:%@",error);
                            #endif
                               self.progress.labelText = @"注册失败";
                               self.progress.detailsLabelText = [[error userInfo] objectForKey:@"errorDesc"];
                               self.progress.mode = MBProgressHUDModeText;
                               [self.progress hide:YES afterDelay:1];
                           }];
    [request activeUserWithNo:self.stuNumber.text password:self.password.text name:self.name.text];
    [client enqueueRequest:request];
}

- (IBAction)showUserProtocol:(id)sender
{
   
}
@end
