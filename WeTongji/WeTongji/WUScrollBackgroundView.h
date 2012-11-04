//
//  WUScrollBackgroundView.h
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-2.
//
//

#import <UIKit/UIKit.h>

@interface WUScrollBackgroundView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

- (void)zoom:(float)scaleFactor;
- (void)initImage:(NSString *)imageName;
@end
