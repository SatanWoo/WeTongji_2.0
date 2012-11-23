//
//  MiddleAbstractViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "MiddleAbstractViewController.h"
#import "UIBarButtonItem+CustomButton.h"

@interface MiddleAbstractViewController ()

@end

@implementation MiddleAbstractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 2)
                                                           radius:1
                                                            color:[UIColor darkGrayColor]
                                                          opacity:0.6];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
