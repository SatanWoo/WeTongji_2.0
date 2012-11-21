//
//  WUPageControlViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-11.
//
//

#import "WUPageControlViewController.h"

@interface WUPageControlViewController () <UIScrollViewDelegate>
- (void)configureScrollView;
- (void)loadVisiblePages;
@property (nonatomic ,assign) int pictureNumber;
@end

@implementation WUPageControlViewController
@synthesize pagedScrollView;
@synthesize pageControl;

#pragma mark - Public
- (void)addPicture:(UIImageView *)image
{
    CGRect frame = self.pagedScrollView.bounds;
    frame.origin.x = frame.size.width * self.pictureNumber;
    frame.origin.y = 0.0f;
    
    image.frame = frame;
    [self.pagedScrollView addSubview:image];
    self.pictureNumber ++;
}

- (void)clearPicture
{
    NSArray * views = [self.pagedScrollView subviews];
    for ( UIView * view in views )
        [view removeFromSuperview];
    self.pictureNumber = 0 ;
}

#pragma mark - Private Method
- (void)configureScrollView
{
    self.pagedScrollView.delegate = self;
    
    CGSize pagesScrollViewSize = self.pagedScrollView.frame.size;
    self.pagedScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageControl.numberOfPages , pagesScrollViewSize.height);
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 3;
}

- (void)loadVisiblePages {
    CGFloat pageWidth = self.pagedScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.pagedScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    self.pageControl.currentPage = page;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureScrollView];
}

- (void)viewDidUnload
{
    [self setPagedScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

@end
