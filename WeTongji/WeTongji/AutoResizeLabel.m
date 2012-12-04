//
//  AutoResizeLabel.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-12-4.
//
//

#import "AutoResizeLabel.h"

@implementation AutoResizeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setText:(NSString *)text
{
    [super setText:text];
    CGRect frame = self.frame;
    CGSize size = [text sizeWithFont:self.font forWidth:self.frame.size.width lineBreakMode:self.lineBreakMode];
    frame.size = size;
    self.frame = frame;
}

@end
