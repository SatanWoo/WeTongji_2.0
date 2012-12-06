//
//  TransparentTableHeaderView.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-15.
//
//

#import "TransparentTableHeaderView.h"
#import "AppDelegate.h"
#import <WetongjiSDK/WeTongjiSDK.h>
#import "Channel+Addition.h"

@interface TransparentTableHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarShadow;

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
    [self.backImage setHidden:hide];
    [self.avatarShadow setHidden:hide];
}

-(void) setInformation:(Information *)information
{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:information.organizerAvatar]];
    self.publisherLabel.text = information.organizer;
    self.categoryLabel.text = information.source;
    _information = information;
    [self.categoryLabel setHidden:YES];
    [self.label setHidden:YES];
    CGRect frame = self.publisherLabel.frame;
    frame.origin.y = 60;
    self.publisherLabel.frame = frame;
#ifdef DEBUG
    NSLog(@"Information (%@,%@) has been set in TransparentTableHeaderView",information.informationId,information.title);
#endif
}

-(void) setEvent:(Event *)event
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:event.orgranizerAvatarLink]];
    self.publisherLabel.text = event.organizer;
    self.categoryLabel.text = [Channel channelWithId:event.channelId inManagedObjectContext:appDelegate.managedObjectContext].title;
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
