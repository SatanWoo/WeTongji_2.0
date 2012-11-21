//
//  ZoomScrollView.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-22.
//
//

#import "ZoomScrollView.h"

@interface ZoomScrollView()<UIScrollViewAccessibilityDelegate>
@end
@implementation ZoomScrollView

- (id)initWithFrame:(CGRect)frame withImage:(UIImageView *) image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [image setContentMode:UIViewContentModeScaleAspectFit];
        self.image = image;
        [self addSubview:image];
        [self setDelegate:self];
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        UITapGestureRecognizer * twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwoFingerDoubleTap:)];
        twoFingerTapRecognizer.numberOfTapsRequired = 1;
        twoFingerTapRecognizer.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:twoFingerTapRecognizer];
    }
    return self;
}

- (void)onTwoFingerDoubleTap:(UITapGestureRecognizer*)recognizer
{
    UIScrollView * scrollView = self;
    CGFloat newZoomScale = scrollView.zoomScale;
    newZoomScale = MAX(newZoomScale, scrollView.minimumZoomScale);
    [scrollView setZoomScale:newZoomScale animated:YES];
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.image;
}


@end
