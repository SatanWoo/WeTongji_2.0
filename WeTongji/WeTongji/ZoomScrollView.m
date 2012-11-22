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
        UITapGestureRecognizer * doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapRecognizer];

        UITapGestureRecognizer * twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwoFingerDoubleTap:)];
        twoFingerTapRecognizer.numberOfTapsRequired = 1;
        twoFingerTapRecognizer.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:twoFingerTapRecognizer];
    }
    return self;
}

- (void)onDoubleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.image];
    float scale;
    if ( self.zoomScale > 1.5 ) scale = 0.5;
    else scale = 2.0;
    CGFloat newZoomScale = self.zoomScale * scale;
    newZoomScale = MIN(newZoomScale, self.maximumZoomScale);
    CGSize scrollViewSize = self.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / scale);
    CGFloat y = pointInView.y - (h / scale);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [self zoomToRect:rectToZoomTo animated:YES];
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
