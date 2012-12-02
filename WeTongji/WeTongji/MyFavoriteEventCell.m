//
//  MyFavoriteEventCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-12-2.
//
//

#import "MyFavoriteEventCell.h"
#import "Event+Addition.h"
#import "NSString+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation MyFavoriteEventCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void) setCollection:(AbstractCollection *)collection
{
    [super setCollection:collection];
    if ( ![collection isKindOfClass:[Event class]] ) return;
    Event * event = (Event *)collection;
    [self.avatar setImageWithURL:[NSURL URLWithString:event.orgranizerAvatarLink]];
    self.titleLabel.text = event.title;
    self.timeLabel.text = [NSString yearMonthDayConvertFromDate:event.createAt];
    self.sourceLabel.text = event.organizer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
