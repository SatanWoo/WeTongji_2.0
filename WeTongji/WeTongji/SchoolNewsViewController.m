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
#import "NSDictionary+Addition.h"
#import "UIApplication+nj_SmartStatusBar.h"

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
- (void)renderBorder:(UIView *)view;
@property (weak, nonatomic) IBOutlet UIImageView *buttonBackImageView;
@property (nonatomic, strong) WUTableHeaderView *headerView;
@property (nonatomic, strong) WUPageControlViewController *pageViewController;
@property (nonatomic, assign) BOOL isAnimationFinished;
@property (nonatomic, strong) TextViewTableCell* currentCell;
@property (nonatomic, strong) TransparentTableHeaderView * transparentHeaderView;
@property (nonatomic, strong) NSDictionary * imageDict;
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
}

- (void)configureTableView
{
    [self.newsTableView registerNib:[UINib nibWithNibName:@"TextViewTableCell" bundle:nil] forCellReuseIdentifier:kTextViewTableCell];
    self.newsTableView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.pageViewController.view belowSubview:self.newsTableView];
    self.newsTableView.frame = CGRectMake(0, 0, 320, self.newsTableView.frame.size.height + (self.headerView.bounds.size.height - kContentOffset));
    originNewsTableViewCenter = [self.newsTableView center];
   
}

- (void)renderBorder:(UIView *)view
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor colorWithRed:157 green:157 blue:157 alpha:1.0].CGColor;
}
#pragma mark - Tap

-(void)showScheduleTable
{
    [self.newsTableView scrollRectToVisible:self.view.frame animated:NO];
    [[UIApplication sharedApplication] nj_setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.55f animations:^{
        [self.view setFrame: [self.view bounds]];
        [self.newsTableView setCenter:originNewsTableViewCenter];
        [self.backButton setAlpha:1.0];
        [self.buttonBackImageView setAlpha:1.0];
    } completion:^(BOOL finished) {}];
    
    [UIView animateWithDuration:0.8f animations:^{
        [self.pageViewController.view setCenter:originPageViewCenter];
    } completion:^(BOOL finished) {
        self.isAnimationFinished = false;
        self.pageViewController.view.userInteractionEnabled = NO;
        self.newsTableView.userInteractionEnabled = YES;}];
}

- (void)didTap:(UITapGestureRecognizer *)recognizer
{
    [self showScheduleTable];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [self showScheduleTable];
}

#pragma mark - Setter & Getter
- (WUPageControlViewController *)pageViewController
{
    if (_pageViewController == nil) {
        _pageViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kWUPageControlViewController];
        UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
        [_pageViewController.view addGestureRecognizer:upSwipe];
        float rate = (self.newsTableView.contentOffset.y + kContentOffset) / -kRowHeight;
        [_pageViewController.view setFrame:CGRectMake(0, kStateY + 15 * rate, 320 ,480)];
        _pageViewController.view.userInteractionEnabled = NO;
        for ( NSString * link in [self.imageDict allKeys] )
        {
            UIImageView * view = [[UIImageView alloc] init];
            [view setImageWithURL:[NSURL URLWithString:link] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            [_pageViewController addPicture:view withDescription:self.imageDict[link]];
        }
        if ( [self.imageDict allKeys].count == 0)
        {
            UIImageView * view = [[UIImageView alloc] init];
            [view setImage:[UIImage imageNamed:@"default_pic"]];
            [_pageViewController addPicture:view withDescription:[NSNull null]];
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
    [self.currentCell setFrame:CGRectMake(0, 0,self.currentCell.frame.size.width,MAX(self.currentCell.textView.contentSize.height,self.view.bounds.size.height))];
    self.currentCell.contentView.backgroundColor = self.currentCell.textView.backgroundColor;
    CGRect frame = self.currentCell.textView.frame;
    frame.size.height = self.currentCell.frame.size.height;
    self.currentCell.textView.frame = frame;
}

-(void) setEvent:(Event *)event
{
    self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"WUTableHeaderView" owner:self options:nil] objectAtIndex:0];
    [self renderShadow:self.headerView];
    [self.headerView setEvent:event];
    [self.transparentHeaderView setHideBoard:NO];
    [self.transparentHeaderView setEvent:event];
    self.imageDict = [NSDictionary dictionaryWithObject:[NSNull null] forKey:event.imageLink];
    _event = event;
    
    //[self renderBorder:self.headerView.likeButtonBg];
    //[self renderBorder:self.headerView.favoriteButtonBg];
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
    
    //[self renderBorder:self.headerView.likeButtonBg];
    //[self renderBorder:self.headerView.favoriteButtonBg];

    self.imageDict = [NSDictionary getImageLinkDictInJsonString:information.images];
    _information = information;
}

-(void) setStar:(Star *)star
{
    self.headerView =  [[[NSBundle mainBundle] loadNibNamed:@"StarHeaderView" owner:self options:nil] objectAtIndex:0];
    [self renderShadow:self.headerView];
    [self.headerView setStar:star];
    [self.transparentHeaderView setHideBoard:YES];
    self.imageDict = [NSDictionary getImageLinkDictInJsonString:star.images];
    _star = star;
    
    //[self renderBorder:self.headerView.likeButtonBg];
    //[self renderBorder:self.headerView.favoriteButtonBg];
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftGesture];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    [self setBackButton:nil];
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    
    if ( rate < -3 && !_isBackGroundHide && !self.isAnimationFinished )
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
    if ( rate > -3 && rate < 1 && _isBackGroundHide && !self.isAnimationFinished )
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
        self.newsTableView.userInteractionEnabled = NO;
        [[UIApplication sharedApplication] nj_setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.25f animations:^{
            [self.view setFrame: [[UIScreen mainScreen] bounds]];
            self.newsTableView.frame = CGRectMake(0, self.view.frame.size.height, self.newsTableView.frame.size.width, self.newsTableView.frame.size.height);
            self.pageViewController.view.frame = CGRectMake(0,0, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height);
            [self.backButton setAlpha:0.0];
            [self.buttonBackImageView setAlpha:0.0];
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
        if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround] &&indexPath.row < 2 ) return 40;
        if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround] &&indexPath.row == 2 ) return 50;
        return self.currentCell.frame.size.height;
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
