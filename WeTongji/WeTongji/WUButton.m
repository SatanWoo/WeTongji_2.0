//
//  WUButton.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import "WUButton.h"

@implementation WUButton
@synthesize titleLabel = _titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        CGRect oldFrame = self.frame;
        CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 44);
        self.frame = newFrame;
    } else {
        CGRect oldFrame = self.frame;
        CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 41);
        self.frame = newFrame;
    }
    [super setSelected:selected];
}

@end
