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
- (void)configureScrollView;
@end

@implementation RegisterSecondViewController
#pragma mark - Private 
- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_register" selector:nil target:self];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)configureScrollView
{
    CGRect frame = self.scrollView.frame;
    frame.size.height += 1;
    self.scrollView.contentSize = frame.size;
    
    [self.stuNumber becomeFirstResponder];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
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
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y / 3 * 2) animated:YES];
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
