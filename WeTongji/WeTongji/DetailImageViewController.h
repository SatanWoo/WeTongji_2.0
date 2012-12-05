//
//  DetailImageViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-16.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailImageViewControllerDelegate;

@interface DetailImageViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) id<DetailImageViewControllerDelegate> delegate;


+ (DetailImageViewController *)showDetailImageWithURL:(NSString*)url;
+ (DetailImageViewController *)showDetailImageWithImage:(UIImage *)image;

@end

@protocol DetailImageViewControllerDelegate <NSObject>

@optional
- (void)detailImageViewControllerDidFinishShow;

@end

