//
//  RecommendCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import "RecommendCell.h"

@implementation RecommendCell
@synthesize infoTitle = _infoTitle;
@synthesize source = _source;
@synthesize icon = _icon;
@synthesize count = _count;
@synthesize preview = _preview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
