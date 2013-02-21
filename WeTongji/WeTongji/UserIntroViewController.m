//
//  UserIntroViewController.m
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-20.
//
//

#import "UserIntroViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Macro.h"
#import <math.h>
#define kPageContent self.view.frame.size.height
#define kLastContent self.view.frame.size.height
#define kMoveDistance self.moveView.frame.size.height

@interface UserIntroViewController ()<UIScrollViewDelegate>
{
    CGPoint originRect;
    CGPoint bottomRect;
}
- (void)configureScrollView;
- (void)loadVisiblePages;
@property (nonatomic ,assign) int pictureNumber;
@property (nonatomic ,assign) CGRect originRect;
@property (nonatomic) BOOL iphone5;
@end

@implementation UserIntroViewController
@synthesize pictureNumber = _pictureNumber;
@synthesize originRect = _originRect;
@synthesize moveView;

#pragma mark - Private Method

- (BOOL) isIphone5
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if ((screenWidth==568)||(screenHeight==568)) {
        return YES;
    }
    return NO;
}

- (void) autolayout
{
    CGRect frame = self.moveView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    [self.moveView setFrame:frame];
}

- (void)configureScrollView
{
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 5;
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width,  (self.pageControl.numberOfPages - 1) * kPageContent + kLastContent);
    self.originRect = self.scrollView.frame;
    if ( ![self isIphone5] )
    {
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_bg"]];
        CGRect frame = image.bounds;
        frame.origin.x = 0.0f;
        frame.origin.y = -1 * kPageContent;
        image.frame = frame;
        [self.scrollView addSubview:image];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]]];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2"]]];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3"]]];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide4"]]];
    }
    else{
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_bg-568h"]];
        CGRect frame = image.bounds;
        frame.origin.x = 0.0f;
        frame.origin.y = -1 * kPageContent;
        image.frame = frame;
        [self.scrollView addSubview:image];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1-568h"]]];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2-568h"]]];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide3-568h"]]];
        [self addPicture:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide4-568h"]]];
    }
}

- (void)addPicture:(UIView *)image
{
    CGRect frame = image.bounds;
    frame.origin.x = 0.0f;
    frame.origin.y = self.pictureNumber * kPageContent;
    image.frame = frame;
    [self.scrollView addSubview:image];
    self.pictureNumber ++;
}

- (void)loadVisiblePages
{
    NSInteger page = self.scrollView.contentOffset.y / kPageContent;
    self.pageControl.currentPage = page;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self autolayout];
    [self configureScrollView];
    originRect = self.moveView.center;
    bottomRect = self.moveView.center;
    bottomRect.y -= kMoveDistance;
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
    [self setDirectUser:nil];
    [self setMoveView:nil];
    [super viewDidUnload];
}

- (IBAction)directLogin:(id)sender
{
    [UIView animateWithDuration:0.2f animations:^{
        self.view.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMiddleContent object:self];
}

- (IBAction)directUser:(id)sender
{
    [self directLogin:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlideNotification object:self];
}

- (void)scrollBottomBar
{
    float startCountPos = (self.pageControl.numberOfPages - 1) * kPageContent;
    float difference = self.scrollView.contentOffset.y - startCountPos;
    if (difference > kPageContent || difference < -kPageContent) {
        return ;
    }
    float actualMove = (fabs(difference) - kPageContent) * kMoveDistance / kPageContent;
    
    actualMove = fabsf(actualMove);
    
    if (difference > 0) {
        CGPoint center = self.moveView.center;
        center.y = bottomRect.y - actualMove;
        self.moveView.center = center;
    } else {
        CGPoint center = self.moveView.center;
        center.y = originRect.y + actualMove;
        self.moveView.center = center;
    }
    if ( self.moveView.center.y > [[UIScreen mainScreen] bounds].size.height + 6 )
    {
        self.view.layer.opacity = 0.0f;
        [self.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMiddleContent object:self];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadVisiblePages];
    [self scrollBottomBar];
}

@end
