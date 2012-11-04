//
//  WUPopOverView.m
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WUPopOverView.h"

@implementation WUPopOverView
@synthesize delegate = _delegate;

- (IBAction)itemTriggered:(UIButton *)sender
{
    for (UIView *view in self.subviews) {
        if (view == sender) {
            [self.delegate selectItemInPopOverViewAtIndex:sender];
        }
    }
}
@end
