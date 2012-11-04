//
//  WUScrollBackgroundView.m
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-2.
//
//

#import "WUScrollBackgroundView.h"

@interface WUScrollBackgroundView()<UIScrollViewDelegate>
- (void)centerScrollViewContents;
@end

@implementation WUScrollBackgroundView
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;

#pragma mark - Private Method
- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - LifeCycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)initImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = image.size;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, image.size.width, 10) animated:NO];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)zoom:(float)scaleFactor
{
    [self.scrollView zoomToRect:CGRectMake(0, 0, self.imageView.bounds.size.width, self.imageView.bounds.size.height * (1 + scaleFactor)) animated:YES];
}

@end
