//
//  SchoolNewsViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SchoolNewsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Macro.h"
#import "TextViewTableCell.h"
#import "WUTapImageView.h"
#import "WUTableHeaderView.h"

#define kContentOffset 50
#define kStateY -150

@interface SchoolNewsViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
- (void)renderShadow:(UIView *)view;
- (void)configureTableView;
- (void)didTap:(UITapGestureRecognizer *)recognizer;

@property (nonatomic, strong) WUTapImageView *wuTapView;
@property (nonatomic, strong) WUTableHeaderView *headerView;
@end

@implementation SchoolNewsViewController
@synthesize newsTableView;
@synthesize backButton;

@synthesize wuTapView = _wuTapView;
@synthesize headerView = _headerView;
#pragma mark - Private Method
- (void)renderShadow:(UIView *)view
{
    view.layer.shadowOpacity = 1;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)configureTableView
{
    [self.newsTableView registerNib:[UINib nibWithNibName:@"TextViewTableCell" bundle:nil] forCellReuseIdentifier:kTextViewTableCell];
    self.newsTableView.contentInset = UIEdgeInsetsMake(kContentOffset, 0, 0, 0);
    self.newsTableView.backgroundColor =[UIColor clearColor];
    self.newsTableView.tableHeaderView = self.headerView;
    [self.view insertSubview:self.wuTapView belowSubview:self.newsTableView];
    self.view.backgroundColor = self.headerView.backgroundColor;
}
#pragma mark - Tap
- (void)didTap:(UITapGestureRecognizer *)recognizer
{
//    [UIView animateWithDuration:0.55f animations:^{
//        self.scheduleTableView.frame = self.view.frame;
//    } completion:^(BOOL finished) {
//        self.scheduleTableView.userInteractionEnabled = YES;
//    }];
//    
//    [UIView animateWithDuration:0.8f animations:^{
//        self.wuTapView.frame = CGRectMake(0, kStateY, self.wuTapView.frame.size.width, self.wuTapView.frame.size.height);
//    } completion:^(BOOL finished) {
//        self.wuTapView.userInteractionEnabled = NO;
//    }];
}

#pragma mark - Setter & Getter
- (WUTapImageView *)wuTapView
{
    if (_wuTapView == nil) {
        _wuTapView = [[WUTapImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]];
        [_wuTapView setFrame:CGRectMake(0, kStateY, 320 ,480)];
        [_wuTapView setGestureSelector:@selector(didTap:) target:self];
        _wuTapView.userInteractionEnabled = NO;
    }
    return _wuTapView;
}

- (WUTableHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView =  [[[NSBundle mainBundle] loadNibNamed:@"WUTableHeaderView" owner:self options:nil] objectAtIndex:0];
        [self renderShadow:_headerView];
    }
    return _headerView;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self configureTableView];
    //[self renderShadow:self.upperHiddenView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setNewsTableView:nil];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"ContentOffset is %g",scrollView.contentOffset.y);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 355;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextViewTableCell];
    if (cell == nil) {
        cell = [[TextViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextViewTableCell];
    }
    return cell;
}

@end
