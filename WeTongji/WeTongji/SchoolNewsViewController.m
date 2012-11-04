//
//  SchoolNewsViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SchoolNewsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SchoolNewsViewController ()
- (void)renderShadow:(UIView *)view;
@end

@implementation SchoolNewsViewController
@synthesize upperHiddenView;
@synthesize contentTextView;
@synthesize titleLabel;
@synthesize sourceLabel;
@synthesize seeNumber;
@synthesize releaseTimeLabel;
@synthesize likeNumber;
@synthesize favoriteNumber;
@synthesize likeButton;
@synthesize favoriteButton;
@synthesize backButton;
@synthesize moveFavorView;
@synthesize moveLikeView;

#pragma mark - Private Method
- (void)renderShadow:(UIView *)view
{
    view.layer.shadowOpacity = 1;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self renderShadow:self.upperHiddenView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUpperHiddenView:nil];
    [self setContentTextView:nil];
    [self setTitleLabel:nil];
    [self setSourceLabel:nil];
    [self setSeeNumber:nil];
    [self setReleaseTimeLabel:nil];
    [self setLikeNumber:nil];
    [self setFavoriteNumber:nil];
    [self setLikeButton:nil];
    [self setFavoriteButton:nil];
    [self setBackButton:nil];
    [self setMoveFavorView:nil];
    [self setMoveLikeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction
- (IBAction)goBack:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
