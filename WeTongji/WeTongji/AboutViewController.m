//
//  AboutViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-18.
//
//

#import "AboutViewController.h"
#import "UIBarButtonItem+CustomButton.h"

@interface AboutViewController ()
- (void)configureNavBar;
- (void)pressNavButton;
@end

@implementation AboutViewController

- (void)pressNavButton
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
