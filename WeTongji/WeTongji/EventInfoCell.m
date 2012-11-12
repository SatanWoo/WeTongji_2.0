//
//  EventInfoCell.m
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EventInfoCell.h"
#import "NSString+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation EventInfoCell

@synthesize event=_event;
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
@synthesize organizationLabel = _organizationLabel;

-(void) setEvent:(Event *)event
{
    self.refreshTime.text = [NSString stringWithHowLongAgo: event.createAt];
    //NSLog(@"createAt : %@",self.event.createAt);
    //NSLog(@"begintime: %@",self.event.beginTime);
    if ( _event == event ) return;
    _event = event;
    self.eventName.text = self.event.title;
    self.location.text = self.event.location;
    self.eventTime.text = [NSString timeConvertFromBeginDate:self.event.beginTime endDate:self.event.endTime];
    self.favorLabel.text = [self.event.favorite stringValue];
    self.likeLabel.text = [self.event.like stringValue];
    self.organizationLabel.text = self.event.organizer;
    [self.avatar setImageWithURL:[NSURL URLWithString:self.event.orgranizerAvatarLink]];
}

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
