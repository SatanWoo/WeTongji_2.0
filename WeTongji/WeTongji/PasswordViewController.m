//
//  PasswordViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-20.
//
//

#import "PasswordViewController.h"
#import "MBProgressHUD.h"

@interface PasswordViewController () <MBProgressHUDDelegate>

@end

@implementation PasswordViewController
- (void)configureScrollView {
    CGRect frame = self.scrollView.frame;
    frame.size.height += 1;
    self.scrollView.contentSize = frame.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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


- (void)myTask {
    sleep(3);
}

- (IBAction)findPassword:(id)sender
{
    [self.password resignFirstResponder];
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"发送至您的邮箱中";
	
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
}
@end
