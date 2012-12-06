//
//  MyFavoriteInfoCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-12-2.
//
//

#import "MyFavoriteInfoCell.h"
#import "Information+Addition.h"
#import "NSString+Addition.h"

@implementation MyFavoriteInfoCell

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
    if ( ![collection isKindOfClass:[Information class]] ) return;
    Information * info = (Information *) collection;
    self.titleLabel.text = info.collectionTitle;
    self.sourceLabel.text = info.collectionSummary ;
    self.timeLabel.text = [NSString yearMonthDayConvertFromDate:info.createdAt];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
