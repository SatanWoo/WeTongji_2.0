//
//  UpdatePasswordViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-22.
//
//

#import "UpdatePasswordViewController.h"
#import "UIBarButtonItem+CustomButton.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

- (void)pressNavButton
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_finish_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
    
    self.title = @"更改密码";
}

- (void)configureScrollView
{
    CGRect frame = self.scrollView.frame;
    frame.size.height += 1;
    self.scrollView.contentSize = frame.size;
    
    //[self.oldPass becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
    [self configureNavBar];
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

@end
