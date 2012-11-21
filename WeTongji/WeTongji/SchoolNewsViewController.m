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
#import "TransparentTableHeaderView.h"
#import "SchoolNewsContactCell.h"
#import "SchoolNewsLocationCell.h"
#import "SchoolNewsTicketCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSArray+Addition.h"

#define kContentOffset 50
#define kStateY -150
#define kRowHeight 44

@interface SchoolNewsViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isBackGroundHide;
    CGPoint originNewsTableViewCenter;
    CGPoint originPageViewCenter;
}
- (void)renderShadow:(UIView *)view;
- (void)configureTableView;
- (void)didTap:(UITapGestureRecognizer *)recognizer;
@property (weak, nonatomic) IBOutlet UIImageView *buttonBackImageView;
@property (nonatomic, strong) WUTableHeaderView *headerView;
@property (nonatomic, strong) WUPageControlViewController *pageViewController;
@property (nonatomic, assign) BOOL isAnimationFinished;
@property (nonatomic, strong) TextViewTableCell* currentCell;
@property (nonatomic, strong) TransparentTableHeaderView * transparentHeaderView;
@property (nonatomic, strong) NSArray * imageList;
@end

@implementation SchoolNewsViewController
@synthesize newsTableView;
@synthesize backButton;

@synthesize pageViewController = _pageViewController;
@synthesize headerView = _headerView;
@synthesize isAnimationFinished = _isAnimationFinished;
@synthesize currentCell = _currentCell;
@synthesize transparentHeaderView = _transparentHeaderView;
#pragma mark - Private Method
- (void)renderShadow:(UIView *)view
{
    view.layer.shadowOpacity = 1;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)configureTableView
{
    [self.newsTableView registerNib:[UINib nibWithNibName:@"TextViewTableCell" bundle:nil] forCellReuseIdentifier:kTextViewTableCell];
    self.newsTableView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.pageViewController.view belowSubview:self.newsTableView];
    self.newsTableView.frame = CGRectMake(0, 0, 320, self.newsTableView.frame.size.height + (self.headerView.bounds.size.height - kContentOffset));
    originNewsTableViewCenter = [self.newsTableView center];
   
}
#pragma mark - Tap
- (void)didTap:(UITapGestureRecognizer *)recognizer
{
    self.isAnimationFinished = false;
    self.pageViewController.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.55f animations:^{
        [self.newsTableView setCenter:originNewsTableViewCenter];
    } completion:^(BOOL finished) {}];
    
    [UIView animateWithDuration:0.8f animations:^{
        [self.pageViewController.view setCenter:originPageViewCenter];
    } completion:^(BOOL finished) {}];
}

#pragma mark - Setter & Getter
- (WUPageControlViewController *)pageViewController
{
    if (_pageViewController == nil) {
        _pageViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kWUPageControlViewController];
        [_pageViewController.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)]];
        [_pageViewController.view setFrame:CGRectMake(0, kStateY, 320 ,480)];
        _pageViewController.view.userInteractionEnabled = NO;
        for ( NSString * link in self.imageList )
        {
            UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]];
            [view setImageWithURL:[NSURL URLWithString:link]];
            [_pageViewController addPicture:view];
        }
        originPageViewCenter = [_pageViewController.view center];
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
    }
    return _currentCell;
}

- (WUTableHeaderView *)headerView
{
    if (_headerView == nil) {
        
    }
    return _headerView;
}

- (TransparentTableHeaderView *) transparentHeaderView
{
    if ( !_transparentHeaderView )
    {
        _transparentHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"TransparentTableHeaderView" owner:self options:nil] objectAtIndex:0];  
    }
    return  _transparentHeaderView;
}

-(void) configureCurrentCell
{
    [self.currentCell setFrame:CGRectMake(0, 0,self.currentCell.frame.size.width,MAX(self.currentCell.textView.contentSize.height,430))];
    CGRect frame = self.currentCell.textView.frame;
    frame.size.height = self.currentCell.frame.size.height;
    self.currentCell.textView.frame = frame;
    //[self.currentCell.textView sizeToFit];
}

-(void) setEvent:(Event *)event
{
    self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"WUTableHeaderView" owner:self options:nil] objectAtIndex:0];
    [self renderShadow:self.headerView];
    [self.headerView setEvent:event];
    [self.transparentHeaderView setHideBoard:NO];
    [self.transparentHeaderView setEvent:event];
    self.imageList = [NSArray arrayWithObject:event.imageLink];
    _event = event;
}

-(void) setInformation:(Information *)information
{
    if ( [information.category isEqualToString:GetInformationTypeForStaff] ){
        self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"SchoolNewsHeaderView" owner:self options:nil] objectAtIndex:0];
        [self renderShadow:self.headerView];
        [self.headerView  setInformation:information];
        [self.transparentHeaderView setHideBoard:YES];
    } else if ( [information.category isEqualToString:GetInformationTypeClubNews] ){
        self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"GroupNewsHeaderView" owner:self options:nil] objectAtIndex:0];
        [self renderShadow:self.headerView];
        [self.headerView  setInformation:information];
        [self.transparentHeaderView setHideBoard:NO];
        [self.transparentHeaderView setInformation:information];
    } else if ( [information.category isEqualToString:GetInformationTypeSchoolNews] ){
        self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"ActionNewsHeaderView" owner:self options:nil] objectAtIndex:0];
        [self renderShadow:self.headerView];
        [self.headerView  setInformation:information];
        [self.transparentHeaderView setHideBoard:YES];
    } else if ( [information.category isEqualToString:GetInformationTypeAround] ){
        self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"RecommendNewsHeaderView" owner:self options:nil] objectAtIndex:0];
        [self renderShadow:self.headerView];
        [self.headerView  setInformation:information];
        [self.transparentHeaderView setHideBoard:YES];
    }
    self.imageList = [NSArray getImageLinkListInJsonString:information.images];
    _information = information;
}

-(void) setStar:(Star *)star
{
    self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"StarHeaderView" owner:self options:nil] objectAtIndex:0];
    [self renderShadow:self.headerView];
    [self.headerView setStar:star];
    [self.transparentHeaderView setHideBoard:YES];
    self.imageList = [NSArray getImageLinkListInJsonString:star.images];
    _star = star;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftGesture];
    if ( self.event ) {
        self.currentCell.textView.text = self.event.detail;
        [self configureCurrentCell];
    } else if ( self.information ) {
        self.currentCell.textView.text = self.information.context;
        [self configureCurrentCell];
    } else if ( self.star ) {
        self.currentCell.textView.text = self.star.detail;
        [self configureCurrentCell];
    }
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setNewsTableView:nil];
    [self setButtonBackImageView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8f animations:^{
        self.pageViewController.view.frame = CGRectMake(0, kStateY, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);} completion:nil];
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
    
    if ( rate < -3 && !_isBackGroundHide )
    {
        _isBackGroundHide = YES;
        [UIView animateWithDuration:0.25f animations:^
        {
            [self.buttonBackImageView setAlpha:0.0f];
            CGPoint center = [self.newsTableView center];
            center.y = center.y - (self.headerView.bounds.size.height - kContentOffset);
            [self.newsTableView setCenter:center];
            [self.headerView changeButtonPositionToLeft];
        }
        completion:^(BOOL isFinished){}];
        
        return ;
    }
    if ( rate > -3 && rate < 1 && _isBackGroundHide )
    {
        _isBackGroundHide = NO;
        [UIView animateWithDuration:0.25f animations:^
        {
            [self.buttonBackImageView setAlpha:1.0f];
            CGPoint center = [self.newsTableView center];
            center.y = center.y + (self.headerView.bounds.size.height - kContentOffset);
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
        }];
    }
    else
    if (self.isAnimationFinished == false)
    {
        self.pageViewController.view.frame = CGRectMake(0, kStateY + velocity * rate, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
    }
}



#pragma mark - UITableViewDataSource

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 1 ) return self.headerView.bounds.size.height;
    if ( section == 0 ) return self.transparentHeaderView.bounds.size.height;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 1 ) return self.headerView;
    if ( section == 0 ) return self.transparentHeaderView;
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 )
    {
        if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround])
            return 4;
        return 1;
    }
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 1 )
    {
        if ( self.information && indexPath.row < 3 ) return 40;
        return self.currentCell.bounds.size.height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround])
        if ( indexPath.section == 1 && indexPath.row < 3 )
        {
            UITableViewCell * cell;
            switch (indexPath.row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolNewsLocationCell"];
                    if ( cell == nil )
                        cell = [[SchoolNewsLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SchoolNewsLocationCell"];
                    ((SchoolNewsLocationCell *)cell).location.text = self.information.location;
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolNewsContactCell"];
                    if ( cell == nil )
                        cell = [[SchoolNewsContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SchoolNewsContactCell"];
                    ((SchoolNewsContactCell *)cell).contact.text = self.information.contact;
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolNewsTicketCell"];
                    if ( cell == nil )
                        cell = [[SchoolNewsTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SchoolNewsTicketCell"];
                    ((SchoolNewsTicketCell *)cell).ticket.text = self.information.ticketService;
                    break;
                    
                default:
                    break;
            }
            return cell;
        }
    return self.currentCell;
}

@end
