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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setStuNumber:nil];
    [self setName:nil];
    [self setPassword:nil];
    [self setConfirmPassword:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (IBAction)showUserProtocol:(id)sender
{
    //[self performSegueWithIdentifier:kSeeUserProtocolSegue sender:self];
}
@end
