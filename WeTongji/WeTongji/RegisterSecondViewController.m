//
//  RegisterSecondViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-18.
//
//

#import "RegisterSecondViewController.h"
#import "Macro.h"

@interface RegisterSecondViewController ()

@end

@implementation RegisterSecondViewController
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
