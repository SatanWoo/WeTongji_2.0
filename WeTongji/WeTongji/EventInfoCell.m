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

-(UIColor *) colorForHowLongAgo:(NSDate *) date
{
    NSTimeInterval interval = -[date timeIntervalSinceNow];
    if ( interval < 60 * 60 ) return [UIColor orangeColor];
    return [UIColor grayColor];
}

-(void) setEvent:(Event *)event
{
    self.refreshTime.text = [NSString stringWithHowLongAgo: event.createAt];
    [self.refreshTime setTextColor:[self colorForHowLongAgo:event.createAt]];
    NSLog(@"%@",self.refreshTime.textColor);
#ifdef DEBUG
#endif
    _event = event;
    self.eventName.text = self.event.title;
    self.location.text = self.event.location;
    self.eventTime.text = [NSString timeConvertFromBeginDate:self.event.beginTime endDate:self.event.endTime];
    self.favorLabel.text = [self.event.favorite stringValue];
    self.likeLabel.text = [self.event.like stringValue];
    self.organizationLabel.text = self.event.organizer;
    [self.avatar setImageWithURL:[NSURL URLWithString:self.event.orgranizerAvatarLink]];
    NSLog(@"%@",event);
    if ( [event.canLike boolValue])
        [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    else
        [self.likeButton setImage:[UIImage imageNamed:@"like_hl"] forState:UIControlStateNormal];
    if ( [event.canFavorite boolValue])
        [self.favorButton setImage:[UIImage imageNamed:@"favourite"] forState:UIControlStateNormal];
    else
        [self.favorButton setImage:[UIImage imageNamed:@"favourite_hl"] forState:UIControlStateNormal];
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
