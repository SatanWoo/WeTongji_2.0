//
//  PasswordViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-20.
//
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

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

- (IBAction)findPassword:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
