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

@interface RegisterSecondViewController ()
- (void)configureNavBar;
@end

@implementation RegisterSecondViewController
#pragma mark - Private 
- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_register" selector:nil target:self];
    self.navigationItem.rightBarButtonItem = button;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
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

- (IBAction)touchOnTextFiled:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollView.contentInset = UIEdgeInsetsMake(-80, 0, 580, 0);
    [UIView commitAnimations];
}

- (IBAction)textDidEndEdit:(id)sender
{
    [self resignAllFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (IBAction)showUserProtocol:(id)sender
{
   
}
@end
