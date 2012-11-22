//
//  UpdatePasswordViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-22.
//
//

#import "UpdatePasswordViewController.h"
#import "UIBarButtonItem+CustomButton.h"
#import "MBProgressHUD.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface UpdatePasswordViewController ()<MBProgressHUDDelegate>

@property (nonatomic,strong) MBProgressHUD * progress;

@end

@implementation UpdatePasswordViewController

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.mode = MBProgressHUDModeIndeterminate;
        _progress.delegate = self;
    }
    return _progress;
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    if ([self.progress.labelText isEqualToString:@"更新成功"])
        [self.navigationController popViewControllerAnimated:YES];
    [self.progress removeFromSuperview];
    self.progress = nil;
}

- (void)configureScrollView
{
    CGRect frame = self.scrollView.frame;
    frame.size.height += 20;
    self.scrollView.contentSize = frame.size;
    
    [self.oldPass becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setConfirm:nil];
    [self setPassword:nil];
    [self setOldPass:nil];
    [super viewDidUnload];
}

- (void)resignAllFirstResponder
{
    [self.confirm resignFirstResponder];
    [self.password resignFirstResponder];
    [self.oldPass resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.oldPass) {
        [self.password becomeFirstResponder];
    } else if(textField == self.password) {
        [self.confirm becomeFirstResponder];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self resignAllFirstResponder];
    }
    return NO;
}

-(void) passwordNotMatch
{
    [self.progress show:YES];
    self.progress.mode = MBProgressHUDModeText;
    self.progress.labelText = @"确认密码不匹配";
    [self.progress hide:YES afterDelay:1];
}

-(IBAction)confirm:(id)sender
{
    [self resignAllFirstResponder];
    if ( ![self.password.text isEqualToString:self.confirm.text] )
    {
        [self passwordNotMatch];
        return;
    }
    [self.progress show:YES];
    self.progress.labelText = @"密码更新中...";
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                            #ifdef DEBUG
                               NSLog(@"%@",responseData);
                            #endif
                               NSString * session;
                               session = [responseData objectForKey:@"Session"];
                               [NSUserDefaults setCurrentUserID:[NSUserDefaults getCurrentUserID] session:session];
                               self.progress.mode = MBProgressHUDModeText;
                               self.progress.labelText = @"更新成功";
                               [self.progress hide:YES afterDelay:1];
                           }
                            failureBlock:^(NSError * error )
                           {
                            #ifdef DEBUG
                               NSLog(@"updatePasswordFailed:%@",error);
                            #endif
                               self.progress.labelText = @"更新失败";
                               self.progress.detailsLabelText = [[error userInfo] objectForKey:@"errorDesc"];
                               self.progress.mode = MBProgressHUDModeText;
                               [self.progress hide:YES afterDelay:1];
                           }];
    [request updatePassword:self.password.text oldPassword:self.oldPass.text];
    [client enqueueRequest:request];
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

@end
