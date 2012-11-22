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
#define kPageContent 407
#define kLastContent 460
#define kMoveDistance self.bottomBar.frame.size.height

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
    if (page > 3) {
        self.scrollView.frame = self.view.bounds;
    } else {
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
    float startCountPos = (self.pageControl.numberOfPages - 2) * kPageContent;
    float difference = self.scrollView.contentOffset.y - startCountPos;
    float actualMove = difference * kMoveDistance / kPageContent;
    
    CGPoint center = self.moveView.center;
    center.y = actualMove + self.moveView.frame.size.height/2;
    self.moveView.center = center;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollBottomBar];
    [self loadVisiblePages];
}

@end
