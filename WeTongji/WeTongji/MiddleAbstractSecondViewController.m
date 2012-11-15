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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"back_btn.png" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
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
