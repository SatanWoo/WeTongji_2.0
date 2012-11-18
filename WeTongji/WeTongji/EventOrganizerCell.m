//
//  EventOrganizerCell.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import "EventOrganizerCell.h"

@implementation EventOrganizerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setEvent:(Event *)event
{
    [self.avatarImage setImageWithURL:[NSURL URLWithString:event.orgranizerAvatarLink]];
    self.organizer.text = event.organizer;
    _event = event;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
