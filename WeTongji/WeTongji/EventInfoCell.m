//
//  EventInfoCell.m
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EventInfoCell.h"

@implementation EventInfoCell
// Upper
@synthesize eventName = _eventName;
@synthesize location = _location;
@synthesize eventTime = _eventTime;
@synthesize refreshTime = _refreshTime;

// Down
@synthesize avatar = _avatar;
@synthesize disableView = _disableView;
@synthesize favorButton = _favorButton;
@synthesize favorLabel = _favorLabel;
@synthesize likeButton = _likeButton;
@synthesize likeLabel = _likeLabel;
@synthesize lookButton = _lookButton;
@synthesize lookLabel = _lookLabel;
@synthesize organizationLabel = _organizationLabel;

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
