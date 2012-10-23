//
//  UIImageView+Screenshot.m
//  WeTongji
//
//  Created by Ziqi on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (Screenshot)

+ (UIImageView *)getScreenshotForView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef crf = UIGraphicsGetCurrentContext();
    [view drawLayer:view.layer inContext:crf];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

@end
