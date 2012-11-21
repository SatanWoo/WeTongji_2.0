//
//  ZoomScrollView.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-22.
//
//

#import <UIKit/UIKit.h>

@interface ZoomScrollView : UIScrollView

@property (nonatomic,strong) UIImageView * image;
- (id)initWithFrame:(CGRect)frame withImage:(UIImageView *) image;

@end
