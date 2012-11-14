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
#import "WUPageControlViewController.h"

#define kContentOffset 50
#define kStateY -150
#define kRowHeight 44

@interface SchoolNewsViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
- (void)renderShadow:(UIView *)view;
- (void)configureTableView;
- (void)didTap:(UITapGestureRecognizer *)recognizer;

@property (nonatomic, strong) WUTableHeaderView *headerView;
@property (nonatomic, strong) WUPageControlViewController *pageViewController;
@property (nonatomic, assign) BOOL isAnimationFinished;
@property (nonatomic, weak) TextViewTableCell* currentCell;
@end

@implementation SchoolNewsViewController
@synthesize newsTableView;
@synthesize backButton;

@synthesize pageViewController = _pageViewController;
@synthesize headerView = _headerView;
@synthesize isAnimationFinished = _isAnimationFinished;
@synthesize currentCell = _currentCell;
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
    self.newsTableView.backgroundColor = [UIColor clearColor];
    self.newsTableView.tableHeaderView = self.headerView;
    [self.view insertSubview:self.pageViewController.view belowSubview:self.newsTableView];
   
}
#pragma mark - Tap
- (void)didTap:(UITapGestureRecognizer *)recognizer
{
    self.isAnimationFinished = false;
    [UIView animateWithDuration:0.55f animations:^{
        self.newsTableView.frame = self.view.frame;
    } completion:^(BOOL finished) {
        self.newsTableView.userInteractionEnabled = YES;
    }];
    
    [UIView animateWithDuration:0.8f animations:^{
        self.pageViewController.view.frame = CGRectMake(0, kStateY, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.pageViewController.view.userInteractionEnabled = NO;
    }];
}

#pragma mark - Setter & Getter
- (WUPageControlViewController *)pageViewController
{
    if (_pageViewController == nil) {
        _pageViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kWUPageControlViewController];
        
        [_pageViewController.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
//        UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
//        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
//        [_pageViewController.view addGestureRecognizer:upSwipe];
        
        [_pageViewController.view setFrame:CGRectMake(0, kStateY, 320 ,480)];
        _pageViewController.view.userInteractionEnabled = NO;
        [_pageViewController addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]]];
        [_pageViewController addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]]];
        [_pageViewController addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]]];
    }
    
    return _pageViewController;
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
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setNewsTableView:nil];
    [super viewDidUnload];
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
    static int velocity = 15;
    
    float rate = (scrollView.contentOffset.y + kContentOffset) / -kRowHeight;
    
    if (scrollView.contentOffset.y >= 150) {
        self.currentCell.textView.scrollEnabled = YES;
    }
    
    if (rate <-2)
    {
        
        return;
    }
    
    if (rate > 2) {
        self.isAnimationFinished = true;
        [UIView animateWithDuration:0.25f animations:^{
            self.newsTableView.frame = CGRectMake(0, self.view.frame.size.height, self.newsTableView.frame.size.width, self.newsTableView.frame.size.height);
            self.pageViewController.view.frame = CGRectMake(0,0, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            self.pageViewController.view.userInteractionEnabled = YES;
            self.newsTableView.userInteractionEnabled = NO;
        }];
    } else if (self.isAnimationFinished == false) {
        [UIView animateWithDuration:0.05f animations:^{
            self.pageViewController.view.frame = CGRectMake(0, kStateY + velocity * rate, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
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
    self.currentCell = cell;
    return cell;
}

@end
