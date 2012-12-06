//
//  PasswordViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-20.
//
//

#import "PasswordViewController.h"
#import "MBProgressHUD.h"
#import "UIBarButtonItem+CustomButton.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface PasswordViewController () <MBProgressHUDDelegate>
@property (nonatomic ,strong) MBProgressHUD *HUD;
@end

@implementation PasswordViewController
@synthesize HUD = _HUD;
- (void)configureScrollView {
    CGRect frame = self.scrollView.frame;
    frame.size.height += 1;
    self.scrollView.contentSize = frame.size;
}

-(MBProgressHUD *) HUD
{
    if ( !_HUD )
    {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.delegate = self;
    }
    return _HUD;
}

- (void)pressNavButton
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)configureNavBar
{
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
    [self configureScrollView];
    [self.password becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPassword:nil];
    [self setName:nil];
    [super viewDidUnload];
}

-(void) resetSuccessful
{
    self.HUD.mode = MBProgressHUDModeText;
    self.HUD.labelText = @"已发送至您的邮箱";
    [self.HUD hide:YES afterDelay:2];
}

- (IBAction)findPassword:(id)sender
{
    [self.password resignFirstResponder];
    [self.name resignFirstResponder];
    self.HUD.labelText = @"发送至您的邮箱中";
    [self.HUD show:YES];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                               [self resetSuccessful];
                           }failureBlock:^(NSError * error)
                            {
                                self.HUD.mode = MBProgressHUDModeText;
                                self.HUD.labelText = @"发送失败";
                                self.HUD.detailsLabelText = [[error userInfo] objectForKey:@"errorDesc"];
                                self.HUD.mode = MBProgressHUDModeText;
                                [self.HUD hide:YES afterDelay:1];
                            }];
    [request resetPasswordWithNO:self.password.text Name:self.name.text];
    [client enqueueRequest:request];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if ( [hud.labelText isEqualToString:@"已发送至您的邮箱"] )
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}
@end
