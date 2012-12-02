//
//  MyFavoriteStarCell.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-12-2.
//
//

#import "MyFavoriteStarCell.h"
#import "Star+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation MyFavoriteStarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setCollection:(AbstractCollection *)collection
{
    [super setCollection:collection];
    if ( ![collection isKindOfClass:[Star class]] ) return;
    Star * star = (Star *) collection;
    self.countLabel.text = [NSString stringWithFormat:@"第%@期",star.count];
    [self.avatar setImageWithURL:[NSURL URLWithString:star.avatarLink]];
    self.title.text = star.starId;
    self.words.text = star.words;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
