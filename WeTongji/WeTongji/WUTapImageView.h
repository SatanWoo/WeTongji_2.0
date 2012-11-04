//
//  WUTapImageView.h
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-2.
//
//

#import <UIKit/UIKit.h>

@interface WUTapImageView : UIImageView
@property (nonatomic ,strong) UITapGestureRecognizer *panGesture;
- (void)setGestureSelector:(SEL)selector target:(id)target;
@end
