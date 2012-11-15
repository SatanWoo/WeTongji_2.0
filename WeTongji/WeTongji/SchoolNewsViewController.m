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
{
    BOOL _isBackGroundHide;
}
- (void)renderShadow:(UIView *)view;
- (void)configureTableView;
- (void)didTap:(UITapGestureRecognizer *)recognizer;
@property (weak, nonatomic) IBOutlet UIImageView *buttonBackImageView;

@property (nonatomic, strong) WUTableHeaderView *headerView;
@property (nonatomic, strong) WUPageControlViewController *pageViewController;
@property (nonatomic, assign) BOOL isAnimationFinished;
@property (nonatomic, strong) TextViewTableCell* currentCell;
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
    //self.newsTableView.contentInset = UIEdgeInsetsMake(kContentOffset, 0, 200, 0);
    self.newsTableView.backgroundColor = [UIColor clearColor];
    //self.newsTableView.tableHeaderView = self.headerView;
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

-(TextViewTableCell *) currentCell
{
    if (_currentCell == nil)
    {
        _currentCell = [self.newsTableView dequeueReusableCellWithIdentifier:kTextViewTableCell];
        if ( _currentCell == nil )
        _currentCell = [[TextViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextViewTableCell];
        [_currentCell setFrame:CGRectMake(0, 0,_currentCell.frame.size.width, _currentCell.textView.contentSize.height)];
        CGRect frame = _currentCell.textView.frame;
        frame.size.height = _currentCell.frame.size.height;
        _currentCell.textView.frame = frame;
        [_currentCell.textView sizeToFit];
    }
    return _currentCell;
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
    [self setButtonBackImageView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction
- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static int velocity = 15;
    
    float rate = (scrollView.contentOffset.y + kContentOffset) / -kRowHeight;
    
    if ( rate < -2 && !_isBackGroundHide )
    {
        _isBackGroundHide = YES;
        [UIView animateWithDuration:0.5f animations:^
        {
            [self.buttonBackImageView setAlpha:0.0f];
            CGPoint center = [self.newsTableView center];
            center.y = center.y - kContentOffset;
            [self.newsTableView setCenter:center];
            [self.headerView changeButtonPositionToLeft];
        }
        completion:^(BOOL isFinished){}];
        
        return ;
    }
    if ( rate > -2 && rate < 1 && _isBackGroundHide )
    {
        _isBackGroundHide = NO;
        [UIView animateWithDuration:0.5f animations:^
        {
            [self.buttonBackImageView setAlpha:1.0f];
            CGPoint center = [self.newsTableView center];
            center.y = center.y + kContentOffset;
            [self.newsTableView setCenter:center];
            [self.headerView resetButtonPosition];
        }
        completion:^(BOOL isFinished){}];
    }
    if (rate > 1) {
        self.isAnimationFinished = true;
        [UIView animateWithDuration:0.25f animations:^{
            self.newsTableView.frame = CGRectMake(0, self.view.frame.size.height, self.newsTableView.frame.size.width, self.newsTableView.frame.size.height);
            self.pageViewController.view.frame = CGRectMake(0,0, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            self.pageViewController.view.userInteractionEnabled = YES;
            self.newsTableView.userInteractionEnabled = NO;
        }];
    }
    else
    if (self.isAnimationFinished == false)
    {
        [UIView animateWithDuration:0.05f animations:^{
            self.pageViewController.view.frame = CGRectMake(0, kStateY + velocity * rate, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}



#pragma mark - UITableViewDataSource

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 1 ) return self.headerView.bounds.size.height;
    if ( section == 0 ) return kContentOffset;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 1 ) return self.headerView;
    if ( section == 0 )
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.newsTableView.bounds.size.width, kContentOffset)];
        [view setAlpha:0];
        return view;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 ) return 1;
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 1 )return self.currentCell.bounds.size.height;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.currentCell;
}

@end
