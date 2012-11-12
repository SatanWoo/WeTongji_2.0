//
//  WUButton.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import "WUButton.h"
#import <QuartzCore/QuartzCore.h>
@interface WUButton ()
- (void)refreshShadow;
@end

@implementation WUButton
@synthesize titleLabel = _titleLabel;

- (void)refreshShadow
{
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        UIImage *image = [self backgroundImageForState:UIControlStateSelected];
        if (image != nil) {
            CGRect oldFrame = self.frame;
            CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, image.size.height);
            self.frame = newFrame;
            
        }
    } else {
        UIImage *image = [self backgroundImageForState:UIControlStateNormal];
        if (image != nil) {
            CGRect oldFrame = self.frame;
            CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, image.size.height);
            self.frame = newFrame;
        }
    }
    [super setSelected:selected];
}

@end
