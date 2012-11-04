//
//  WUTapImageView.m
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-2.
//
//

#import "WUTapImageView.h"

@implementation WUTapImageView
@synthesize panGesture = _panGesture;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setGestureSelector:(SEL)selector target:(id)target
{
    self.panGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    self.panGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.panGesture];
}

@end
