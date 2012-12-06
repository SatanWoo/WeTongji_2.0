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
    [super viewDidUnload];
}

- (void)myTask
{
    sleep(3);
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.labelText = @"已发送至您的邮箱";
    sleep(2);
}

- (IBAction)findPassword:(id)sender
{
    [self.password resignFirstResponder];
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:self.HUD];
	
    self.HUD.delegate = self;
    self.HUD.labelText = @"发送至您的邮箱中";
	
    [self.HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}
@end
