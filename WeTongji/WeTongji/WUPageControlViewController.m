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
@property (nonatomic ,strong) NSMutableArray * imageList;
@end

@implementation WUPageControlViewController
@synthesize pagedScrollView;
@synthesize pageControl;

-(NSMutableArray *) imageList
{
    if ( !_imageList )
    {
        _imageList = [[NSMutableArray alloc] init];
    }
    return _imageList;
}

#pragma mark - Public
- (void)addPicture:(UIImageView *)image
{
    CGRect frame = self.view.bounds;
    frame.origin.x = frame.size.width * self.pictureNumber;
    frame.origin.y = 0.0f;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    frame.origin.x = 0;
    image.frame = frame;
    [scrollView addSubview:image];
    [scrollView setDelegate:self];
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2;
    scrollView.zoomScale = 1;
    UITapGestureRecognizer * twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwoFingerDoubleTap:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [scrollView addGestureRecognizer:twoFingerTapRecognizer];
    [self.pagedScrollView addSubview:scrollView];
    self.pictureNumber ++;
    self.pageControl.numberOfPages = self.pictureNumber;
    [self.imageList addObject:scrollView];
    [self configureScrollView];
}

- (void)clearPicture
{
    NSArray * views = [self.pagedScrollView subviews];
    for ( UIView * view in views )
        [view removeFromSuperview];
    self.pictureNumber = 0 ;
    self.imageList = nil;
    [self configureScrollView];
    self.pageControl.numberOfPages = self.pictureNumber;
}

#pragma mark - Private Method
- (void)configureScrollView
{
    self.pagedScrollView.delegate = self;
    
    CGSize pagesScrollViewSize = self.pagedScrollView.frame.size;
    self.pagedScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageControl.numberOfPages , pagesScrollViewSize.height);
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
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 0;
}

- (void)onTwoFingerDoubleTap:(UITapGestureRecognizer*)recognizer
{
    UIScrollView * scrollView = self.imageList[self.pageControl.currentPage];
    CGFloat newZoomScale = scrollView.zoomScale;
    newZoomScale = MAX(newZoomScale, scrollView.minimumZoomScale);
    NSLog(@"%f",newZoomScale);
    [scrollView setZoomScale:newZoomScale animated:YES];
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

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)sender
{
    if ( sender != self.pagedScrollView )
    {
        return [[sender subviews] lastObject];
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages which are now on screen
    [self loadVisiblePages];
}

@end
