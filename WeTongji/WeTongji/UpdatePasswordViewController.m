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
