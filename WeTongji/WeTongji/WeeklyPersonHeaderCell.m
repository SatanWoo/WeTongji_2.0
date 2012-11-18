//
//  WeeklyPersonHeaderCell.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import "WeeklyPersonHeaderCell.h"

@implementation WeeklyPersonHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setStar:(Star *)star
{
    [self.avatar setImageWithURL:[NSURL URLWithString:star.avatarLink]];
    self.name.text = star.title;
    self.title.text = star.jobTitle;
    self.summary.text = star.words;
    _star = star;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
