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
#import "UserIntroViewController.h"
#import "LeftMenuCellModel.h"

#define kFirstUseKey @"kFirstUsessssssKey"

@interface WUSlideViewController ()
@property (assign ,nonatomic) int currentStatus;
@property (nonatomic ,strong) UserIntroViewController *introViewController;

- (void)renderShadow:(BOOL)rendered;
- (void)revealLeftViewController:(UIGestureRecognizer *)recognizer;
- (void)revealMiddleViewController:(UIGestureRecognizer *)recognizer;
- (void)pressNavButton;
- (void)configureNavButton;
- (void)navBack;
- (void)configureNotification;
- (void)login:(NSNotification *)notification;
- (void)removeNotification;
- (void)configureView;
- (UIViewController *)getContentViewController;
@end

@implementation WUSlideViewController
@synthesize middelViewController = _middelViewController;
@synthesize leftViewController = _leftViewController;

@synthesize currentStatus = _currentStatus;
@synthesize introViewController = _introViewController;
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNotification];
}

- (void)viewDidUnload
{
    self.middelViewController = nil;
    self.leftViewController = nil;
    [self removeNotification];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method
- (void)login:(NSNotification *)notification
{
    self.leftViewController.identifierArray = nil;
    [self.leftViewController.menuTableView reloadData];
    [self.leftViewController.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationNone];
    CGRect frame = self.middelViewController.view.frame;
    frame.origin.x = frame.size.width;
    [UIView animateWithDuration:0.3f animations:^{
        self.middelViewController.view.frame = frame;
    } completion:^(BOOL finished)
    {
        self.middelViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kPersonalViewController];
        CGRect frame = self.middelViewController.view.frame;
        frame.origin.x += frame.size.width;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect newFrame = self.middelViewController.view.frame;
            newFrame.origin.x = 0;
            self.middelViewController.view.frame = newFrame;} completion:nil];
    }];
}

- (void)update:(NSNotification *)notification
{
    [self.view addSubview:self.middelViewController.view];
//    self.middelViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kLoginViewController];
}

- (void)configureView
{
    self.leftViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kLeftMenuViewController];
    
    LeftMenuCellModel * model = self.leftViewController.identifierArray[0];
    NSString * identifier = model.identifier;
    self.middelViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    [self.leftViewController.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewRowAnimationNone];
}

- (void)configureNotification
{
    [self configureView];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:kFirstUseKey]];
    
    int isFirstUse = [[NSUserDefaults standardUserDefaults] integerForKey:kFirstUseKey];
    if (isFirstUse == 0) {
        [self.view addSubview:self.introViewController.view];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kFirstUseKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reveal:) name:kSlideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMiddleContent object:nil];}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kLoginNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kSlideNotification];
}

- (void)reveal:(NSNotification *)notification
{
    [self pressNavButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEnableInteractionNotification object:self];
}

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
    if (self.currentStatus == eMIDDLE ) {
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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"navbar_list_btn" selector:@selector(pressNavButton) target:self];
    UIViewController *rootViewController = [self getContentViewController];
    rootViewController.navigationItem.leftBarButtonItem = button;
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
    self.currentStatus = eMIDDLE;
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
    _leftViewController.slideViewController = self;
    [self.view insertSubview:_leftViewController.view atIndex:0];
}

- (UserIntroViewController *)introViewController
{
    if (_introViewController == nil) {
        _introViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kUserIntroViewController];
        _introViewController.view.frame = self.view.bounds;
        
        [self.middelViewController.view removeFromSuperview];
        [_introViewController addPicture:self.middelViewController.view];
    }
    return _introViewController;
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark - LeftMenuViewController
- (void)changeMiddleContent:(UIViewController *)controller
{
    self.middelViewController = controller;
}
@end
