//
//  CampusViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-20.
//
//

#import "CampusViewController.h"

#define kWidth self.scrollView.frame.size.width
#define kHeight self.scrollView.frame.size.height

@interface CampusViewController ()
@property (nonatomic, strong) UIView *celebrityView;
@property (nonatomic, strong) UIView *eventView;
@property (nonatomic, strong) UIView *newsView;

- (void)configureScrollView;
- (void)pageChange:(int)index;
@end

@implementation CampusViewController
@synthesize scrollView = _scrollView;
@synthesize indicator = _indicator;

@synthesize celebrityView = _celebrityView;
@synthesize eventView = _eventView;
@synthesize newsView = _newsView;

#pragma mark - Private Method
- (void)configureScrollView
{
    self.celebrityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.celebrityView.backgroundColor = [UIColor redColor];
    
    self.eventView = [[UIView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    self.eventView.backgroundColor = [UIColor blueColor];
    
    self.newsView = [[UIView alloc] initWithFrame:CGRectMake(kWidth * 2,0, kWidth, kHeight)];
    self.newsView.backgroundColor = [UIColor orangeColor];
    
    [self.scrollView setContentSize:CGSizeMake(kWidth * 3, kHeight)];
    [self.scrollView setContentOffset:CGPointMake(kWidth * 2, 0)];
    
    [self.scrollView addSubview:self.celebrityView];
    [self.scrollView addSubview:self.eventView];
    [self.scrollView addSubview:self.newsView];
}

- (void)pageChange:(int)index
{
    if (index < 0 || index > 2) {
        return ;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.indicator.frame = CGRectMake(index * 105 + 45, self.indicator.frame.origin.y, self.indicator.frame.size.width, self.indicator.frame.size.height);
        [self.scrollView setContentOffset:CGPointMake(index * kWidth, 0)];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Lifecycle;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    self.scrollView = nil;
    self.indicator = nil;
    self.celebrityView = nil;
    self.eventView = nil;
    self.newsView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    int moveIndex = -1;
    if (sender == self.celebrityButton) {
        moveIndex = 0;
    } else if (sender == self.eventButton) {
        moveIndex = 1;
    } else {
        moveIndex = 2;
    }
    [self pageChange:moveIndex];
}

@end
