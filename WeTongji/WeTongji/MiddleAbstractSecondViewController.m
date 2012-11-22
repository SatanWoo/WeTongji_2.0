//
//  MiddleAbstractSecondViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-14.
//
//

#import "MiddleAbstractSecondViewController.h"
#import "UIBarButtonItem+CustomButton.h"

@interface MiddleAbstractSecondViewController ()
@end

@implementation MiddleAbstractSecondViewController

- (void)pressNavButton
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn.png" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pressNavButton)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
