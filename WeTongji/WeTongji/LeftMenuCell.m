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
        image.tag = kTag;
    } else {
        UIView *view = [self viewWithTag:kTag];
        view.tag = 0;
        if (view) {
            [view removeFromSuperview];
        }
    }
}

@end
