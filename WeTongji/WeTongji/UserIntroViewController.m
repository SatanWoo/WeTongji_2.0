//
//  UserIntroViewController.m
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-20.
//
//

#import "UserIntroViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kPageContent 407
#define kLastContent 460

@interface UserIntroViewController ()<UIScrollViewDelegate>
- (void)configureScrollView;
- (void)loadVisiblePages;
@property (nonatomic ,assign) int pictureNumber;
@property (nonatomic ,assign) CGRect originRect;
@end

@implementation UserIntroViewController
@synthesize pictureNumber = _pictureNumber;
@synthesize originRect = _originRect;

#pragma mark - Private Method
- (void)configureScrollView
{
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 5;
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width,  (self.pageControl.numberOfPages - 1) * kPageContent + kLastContent);
    self.originRect = self.scrollView.frame;
    
    [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1.png"]]];
    [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2.png"]]];
    [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3.png"]]];
    [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide4.png"]]];
}

- (void)addPicture:(UIView *)image
{
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = 0.0f;
    frame.origin.y = self.pictureNumber * kPageContent;
    image.frame = frame;
    [self.scrollView addSubview:image];
    self.pictureNumber ++;
}

- (void)loadVisiblePages
{
    NSInteger page = self.scrollView.contentOffset.y / kPageContent;
    if (page > 3) {
        self.bottomBar.hidden = YES;
        self.registerloginbtn.hidden = YES;
        self.scrollView.frame = self.view.bounds;
    } else {
        self.bottomBar.hidden = NO;
        self.registerloginbtn.hidden = NO;
        self.scrollView.frame = self.originRect;
    }
    self.pageControl.currentPage = page;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setBottomBar:nil];
    [self setRegisterloginbtn:nil];
    [super viewDidUnload];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisiblePages];
}

@end
