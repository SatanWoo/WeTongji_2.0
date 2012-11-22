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
#import "Macro.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UITextField *NOTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (void)configureButton;
- (void)enableButton:(NSNotification *)notification;
@end

@implementation LoginViewController
- (void)configureButton
{
    self.closeBtn.hidden = YES;
}

- (void)enableButton:(NSNotification *)notification
{
    self.view.userInteractionEnabled = YES;
    self.navButton.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureButton];
    [self.navigationItem setHidesBackButton:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableButton:) name:kEnableInteractionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setScrollVIew:nil];
    [self setNOTextField:nil];
    [self setPasswordTextField:nil];
    [self setCloseBtn:nil];
    [self setPasswordForgetBtn:nil];
    [self setNavButton:nil];
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
    self.closeBtn.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(-90, 0, 580, 0);
    [UIView commitAnimations];
}

- (IBAction)textDidEndEdit:(id)sender
{
    [self resignAllFirstResponder];
    [self configureButton];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self];
    }failureBlock:^(NSError * error){}];
    [request login:self.NOTextField.text password:self.passwordTextField.text];
    [client enqueueRequest:request];
}

- (IBAction)slide:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlideNotification object:self];
}
@end
