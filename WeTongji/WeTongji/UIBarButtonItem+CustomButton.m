//
//  UIBarButtonItem+CustomButton.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "UIBarButtonItem+CustomButton.h"

@implementation UIBarButtonItem (CustomButton)

- (id)initWithImage:(NSString *)imageName selector:(SEL)selector target:(id)target
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateSelected];
        [button setBounds:[[UIImageView alloc] initWithImage:image].bounds];
        self = [self initWithCustomView:button];
    }
    return self;
}

@end
