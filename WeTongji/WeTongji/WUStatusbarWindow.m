//
//  WUStatusbarWindow.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-23.
//
//

#import "WUStatusbarWindow.h"
#import "Macro.h"

@implementation WUStatusbarWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setFrame:[UIApplication sharedApplication].statusBarFrame];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)refreshWindow
{
    self.alpha = 1.0f;
    self.hidden = NO;
}

- (void)scrollToTop
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kScrollToTopNotification object:self];
}

@end
