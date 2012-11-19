//
//  TransparentTableHeaderView.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-15.
//
//

#import "TransparentTableHeaderView.h"
#import <WetongjiSDK/WeTongjiSDK.h>

@interface TransparentTableHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TransparentTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setHideBoard:(BOOL) hide
{
    [self.avatarImageView setHidden:hide];
    [self.publisherLabel setHidden:hide];
    [self.categoryLabel setHidden:hide];
    [self.label setHidden:hide];
}

-(void) setInformation:(Information *)information
{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:information.organizerAvatar]];
    self.publisherLabel.text = information.organizer;
    self.categoryLabel.text = information.source;
    _information = information;
#ifdef DEBUG
    NSLog(@"Information (%@,%@) has been set in TransparentTableHeaderView",information.informationId,information.title);
#endif
}

-(void) setEvent:(Event *)event
{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:event.orgranizerAvatarLink]];
    self.publisherLabel.text = event.organizer;
    self.categoryLabel.text = event.channelId;
    _event = event;
#ifdef DEBUG
    NSLog(@"Event (%@,%@) has been set in TransparentTableHeaderView",event.activityId,event.title);
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
