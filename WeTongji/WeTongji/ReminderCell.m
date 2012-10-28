//
//  ReminderCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-28.
//
//

#import "ReminderCell.h"

@implementation ReminderCell
@synthesize detailContentView = detailContentView;
@synthesize eventNameLabel = _eventNameLabel;
@synthesize timeIcon = _timeIcon;
@synthesize locationIcon = _locationIcon;
@synthesize timeLabel = _timeLabel;
@synthesize locationLabel = _locationLabel;

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
