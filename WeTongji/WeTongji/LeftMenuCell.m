//
//  LeftMenuCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell
@synthesize title;
@synthesize identifer = _identifer;
#define kTag 1000

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    self.title.textColor = selected ? [UIColor whiteColor] : [UIColor grayColor];
    if (selected) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_sl"]];
        image.frame = CGRectMake(0, 0, image.bounds.size.width, image.bounds.size.height);
        [self insertSubview:image atIndex:0];
        [UIView animateWithDuration:0.35f animations:^{
            [image setAlpha:0.0f];
        } completion:^(BOOL finished) {
            if (finished) {
                [image removeFromSuperview];
            }
        }];
    }
}

@end
