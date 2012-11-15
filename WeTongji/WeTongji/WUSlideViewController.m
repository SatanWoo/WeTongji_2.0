//
//  WUSlideViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WUSlideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Macro.h"
#import "UIBarButtonItem+CustomButton.h"


@interface WUSlideViewController ()
@property (assign ,nonatomic) int currentStatus;

- (void)renderShadow:(BOOL)rendered;
- (void)revealLeftViewController:(UIGestureRecognizer *)recognizer;
- (void)revealMiddleViewController:(UIGestureRecognizer *)recognizer;
- (void)pressNavButton;
- (void)configureNavButton;
- (UIViewController *)getContentViewController;
@end

@implementation WUSlideViewController
@synthesize middelViewController = _middelViewController;
@synthesize leftViewController = _leftViewController;

@synthesize currentStatus = _currentStatus;

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.middelViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kPersonalViewController];
    self.leftViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kLeftMenuViewController];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    self.middelViewController = nil;
    self.leftViewController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method
- (void)revealMiddleViewController:(UIGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect newFrame = self.middelViewController.view.frame;
        newFrame.origin.x = 0;
        self.middelViewController.view.frame = newFrame;
    } completion:^(BOOL finished) {
        [self getContentViewController].view.userInteractionEnabled = YES;
        self.currentStatus = eMIDDLE;
        [self renderShadow:NO];
    }];
}

- (void)revealLeftViewController:(UIGestureRecognizer *)recognizer
{
    [self getContentViewController].view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f animations:^{
        CGRect newFrame = self.middelViewController.view.frame;
        newFrame.origin.x = CGRectGetMaxX(self.leftViewController.view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
        self.middelViewController.view.frame = newFrame;
    } completion:^(BOOL finished) {
        
        self.currentStatus = eLEFT;
        [self renderShadow:YES];
    }];
}

- (void)pressNavButton
{
    if (self.currentStatus == eMIDDLE) {
        [self revealLeftViewController:nil];
    } else {
        [self revealMiddleViewController:nil];
    }
}

- (void)renderShadow:(BOOL)rendered
{
    if (self.middelViewController) {
        self.middelViewController.view.layer.shadowOpacity = rendered ? 0.8f : 0.0f;
        if (rendered) {
            self.middelViewController.view.layer.cornerRadius = 4.0f;
            self.middelViewController.view.layer.shadowRadius = 4.0f;
            self.middelViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        }
    }
}

- (UIViewController *)getContentViewController
{
    return [self.middelViewController.childViewControllers objectAtIndex:0];
}

- (void)configureNavButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_left.png" selector:@selector(pressNavButton) target:self];
    UIViewController *rootViewController = [self getContentViewController];
    rootViewController.navigationItem.leftBarButtonItem = button;
}

#pragma mark - Setter * Getter
- (void)setMiddelViewController:(UIViewController *)middelViewController
{
    CGRect oldFrame = _middelViewController.view.frame;
    if (middelViewController == nil || middelViewController == _middelViewController)
        return ;
    if (_middelViewController) {
        [_middelViewController.view removeFromSuperview];
        _middelViewController = middelViewController;
        _middelViewController.view.frame = oldFrame;
        [self.view addSubview:_middelViewController.view];
        [UIView animateWithDuration:0.3f animations:^{
            _middelViewController.view.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            self.currentStatus = eMIDDLE;
        }];
    }  else {
        _middelViewController = middelViewController;
        _middelViewController.view.frame = self.view.bounds;
        [self.view addSubview:_middelViewController.view];
    }

    UISwipeGestureRecognizer *rightGesturer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(revealLeftViewController:)];
    rightGesturer.direction = UISwipeGestureRecognizerDirectionRight;
    [_middelViewController.view addGestureRecognizer:rightGesturer];
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(revealMiddleViewController:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_middelViewController.view addGestureRecognizer:leftGesture];
    
    [self configureNavButton];
}

- (void)setLeftViewController:(LeftMenuViewController *)leftViewController
{
    _leftViewController = leftViewController;
    _leftViewController.delegate = self;
    CGRect leftViewFrame = self.view.bounds;
    leftViewFrame.size.width = kMenuFullWidth;
    leftViewController.view.frame = self.view.bounds;
    _leftViewController.view.frame = leftViewFrame;
    [self.view insertSubview:_leftViewController.view atIndex:0];
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark - LeftMenuViewController
- (void)changeMiddleContent:(UIViewController *)controller
{
    self.middelViewController = controller;
}
@end
