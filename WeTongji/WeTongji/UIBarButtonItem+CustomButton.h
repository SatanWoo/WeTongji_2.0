//
//  UIBarButtonItem+CustomButton.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomButton)

- (id)initWithImage:(NSString *)imageName selector:(SEL)selector target:(id)target;
@end
