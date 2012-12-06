//
//  DetailImageViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "DetailImageViewController.h"
#import  <QuartzCore/QuartzCore.h>
#import "UIImage+Addition.h"
#import "UIApplication+Addition.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"
#import "NSString+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

#define IMAGE_MAX_WIDTH     320
#define IMAGE_MAX_HEIGHT    480

@interface DetailImageViewController()

@end

@implementation DetailImageViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize delegate = _delegate;

- (void)viewDidUnload {
    [super viewDidUnload];
    self.imageView = nil;
    self.scrollView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* gesture;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.scrollView addGestureRecognizer:gesture];
}

- (id)init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    
    self.imageView.image = image;
    
    CGRect frame = self.imageView.frame;
    CGSize size = self.imageView.image.size;
    
    if(size.width > IMAGE_MAX_WIDTH) {
        size.height *= IMAGE_MAX_WIDTH / size.width;
        size.width = IMAGE_MAX_WIDTH;
    }
    
    frame.size = size;
    self.imageView.frame = frame;
    
    if (size.height <= 480) 
        frame.origin.y = 480/2 - size.height/2;
    else 
        frame.origin.y = 0;
    
    if (size.width <= 320) 
        frame.origin.x = 320/2 - size.width/2;
    else
        frame.origin.x = 0;
    
    self.imageView.frame = frame;
    self.scrollView.contentSize = size;
    
    [self.imageView fadeIn];
}

#pragma mark -
#pragma mark Dismiss view methods

- (void)dismissView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(detailImageViewControllerDidFinishShow)]) {
            [self.delegate detailImageViewControllerDidFinishShow];
        }
        [UIApplication dismissModalViewController];
    }];
}

#pragma mark -
#pragma mark UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGSize size = _imageView.frame.size;
    CGRect frame = self.imageView.frame;
    
    if (size.height <= 480) 
        frame.origin.y = 480/2 - size.height/2;
    else 
        frame.origin.y = 0;
    
    if (size.width <= 320) 
        frame.origin.x = 320/2 - size.width/2;
    else 
        frame.origin.x = 0;

    self.imageView.frame = frame;
    self.scrollView.contentSize = size;
}

- (void)loadImageWithURL:(NSString *)url {
    [self.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_pic_loading"]];
}

- (void)show {
    self.view.alpha = 0;
    [UIApplication presentModalViewController:self animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.7f animations:^{
        self.view.alpha = 1;
    }];
}

+ (DetailImageViewController *)showDetailImageWithURL:(NSString*)url{
    if(!url)
        return nil;
    DetailImageViewController *vc = [[DetailImageViewController alloc] init];
    [vc show];
    [vc loadImageWithURL:url];
    return vc;
}

+ (DetailImageViewController *)showDetailImageWithImage:(UIImage *)image {
    if(!image)
        return nil;
    DetailImageViewController *vc = [[DetailImageViewController alloc] init];
    [vc show];
    [vc setImage:image];
    return vc;
}

@end
