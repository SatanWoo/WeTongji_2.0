//
//  proportion.m
//  WeTongji
//
//  Created by Tang Zhixiong on 13-2-24.
//
//

#import "proportion.h"

#define iphone5Proportion 504/416
#define iphone4Proportion 1.0

@implementation proportion

+(float) proportion
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if ((screenWidth==568)||(screenHeight==568))
    {
        return iphone5Proportion;
    }
    return iphone4Proportion;
}

@end
