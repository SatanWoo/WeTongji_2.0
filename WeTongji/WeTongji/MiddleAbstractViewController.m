//
//  MiddleAbstractViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "MiddleAbstractViewController.h"
#import "UIBarButtonItem+CustomButton.h"
#import "WUStatusbarWindow.h"

@interface MiddleAbstractViewController ()
@property (strong, nonatomic) WUStatusbarWindow *window;
@end

@implementation MiddleAbstractViewController
@synthesize window = _window;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar dropShadowWithOffset:CGSizeMake(0, 2)
                                                           radius:1
                                                            color:[UIColor darkGrayColor]
                                                          opacity:0.6];
    
    self.window = [[WUStatusbarWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window refreshWindow];
}

- (void)viewDidUnload
{
     self.window = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
