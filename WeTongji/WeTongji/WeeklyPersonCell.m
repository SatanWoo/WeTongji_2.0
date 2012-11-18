//
//  WeeklyPersonCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-15.
//
//

#import "WeeklyPersonCell.h"

@implementation WeeklyPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

-(void) setStar:(Star *)star
{
    [self.avatar setImageWithURL:[NSURL URLWithString:star.avatarLink]];
    self.name.text = star.title;
    self.job.text = star.jobTitle;
    self.count.text = star.count;
    _star = star;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
