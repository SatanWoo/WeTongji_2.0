//
//  FilterTableViewCell.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation FilterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.checkImageView setAlpha:0.0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [UIView animateWithDuration:0.3f animations:^
        {
            [self.checkImageView setAlpha:1.0];
        }
        completion:^(BOOL isFinished)
        {
            if (isFinished)
            {
                
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^
        {
            [self.checkImageView setAlpha:0.0];
        }
        completion:^(BOOL isFinished)
        {
            if (isFinished)
            {
                
            }
        }];
    }
}

@end
