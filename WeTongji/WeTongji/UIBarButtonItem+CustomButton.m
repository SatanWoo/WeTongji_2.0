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
        NSString *highlightedName = [imageName stringByAppendingString:@"_hl"];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *high = [UIImage imageNamed:highlightedName];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (high) {
            [button setBounds:[[UIImageView alloc] initWithImage:high].bounds];
            [button setImage:high forState:UIControlStateHighlighted];
        } else {
            [button setBounds:[[UIImageView alloc] initWithImage:image].bounds];
        }
        button.frame = CGRectMake(0, 0, button.bounds.size.width + 6, button.bounds.size.height + 6);
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateSelected];
        self = [self initWithCustomView:button];
    }
    return self;
}

@end
