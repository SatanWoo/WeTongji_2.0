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
    NSLog(@"This method get called");
    if (selected) {
        self.titleLabel.textColor = [UIColor blueColor];
    } else {
        self.titleLabel.textColor = [UIColor grayColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
