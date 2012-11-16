//
//  LoginViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "LoginViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "User+Addition.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UITextField *NOTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
}


- (void)viewDidUnload {
    [self setScrollVIew:nil];
    [self setNOTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignAllFirstResponder
{
    [self.NOTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (IBAction)textEditDidBegin:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(-60, 0, 580, 0);
    [UIView commitAnimations];
}

- (IBAction)textDidEndEdit:(id)sender
{
    [self resignAllFirstResponder];
}

- (IBAction)logInClick:(id)sender
{
    [self resignAllFirstResponder];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock: ^(id responseData)
    {
        [NSUserDefaults setCurrentUserID:[[responseData objectForKey:@"User"] objectForKey:@"UID"] session:[responseData objectForKey:@"Session"]];
        [User updateUser:[responseData objectForKey:@"User"] inManagedObjectContext:self.managedObjectContext];
        NSLog(@"%@",responseData);
    }failureBlock:^(NSError * error){}];
    [request login:self.NOTextField.text password:self.passwordTextField.text];
    [client enqueueRequest:request];
}


@end
