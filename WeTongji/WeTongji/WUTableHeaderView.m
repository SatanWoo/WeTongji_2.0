//
//  WUTableHeaderView.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-4.
//
//

#import "WUTableHeaderView.h"
#import "NSString+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface WUTableHeaderView()
{
    BOOL _isButtonBoardLeft;
}
@property (weak, nonatomic) IBOutlet UIView *buttonBoard;

@end

@implementation WUTableHeaderView
@synthesize upperHiddenView;
@synthesize titleLabel;
@synthesize sourceLabel;
@synthesize seeNumber;
@synthesize releaseTimeLabel;
@synthesize likeNumber;
@synthesize favoriteNumber;
@synthesize likeButton;
@synthesize favoriteButton;
@synthesize moveFavorView;
@synthesize moveLikeView;
@synthesize buttonBoard;

-(void) changeButtonPositionToLeft
{
    if ( _isButtonBoardLeft ) return;
    CGPoint center = [self.buttonBoard center];
    if ( self.star ) {
        center.x = center.x + 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeClubNews] ) {
        center.x = center.x + 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeSchoolNews] ) {
        center.x = center.x + 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeForStaff] ) {
        center.x = center.x + 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround] ) {
        center.x = center.x + 54;
        [self.recommendImage setAlpha:0];
    } else
    center.x = center.x + 54;
    [self.buttonBoard setCenter:center];
    _isButtonBoardLeft = YES;
}

-(void) resetButtonPosition
{
    if ( !_isButtonBoardLeft ) return;
    CGPoint center = [self.buttonBoard center];
    if ( self.star ) {
        center.x = center.x - 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeClubNews] ) {
        center.x = center.x - 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeSchoolNews] ) {
        center.x = center.x - 180;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeForStaff] ) {
        center.x = center.x - 180;
    } if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround] ) {
        center.x = center.x - 54;
        [self.recommendImage setAlpha:1];
    } else
    center.x = center.x - 54;
    [self.buttonBoard setCenter:center];
    _isButtonBoardLeft = NO;
}

-(void)setEvent:(Event *)event
{
    self.titleLabel.text = event.title;
    self.releaseTimeLabel.text = [NSString stringWithHowLongAgo:event.createAt];
    self.eventTime.text = [NSString timeConvertFromBeginDate:event.beginTime endDate:event.endTime];
    self.location.text = event.location;
    self.likeNumber.text = [event.like stringValue];
    self.favoriteNumber.text = [event.favorite stringValue];
    _event = event;
#ifdef DEBUG
    NSLog(@"Event (%@,%@) has been set in WUTableHeaderView",event.activityId,event.title);
#endif
}

-(void)setInformation:(Information *)information
{
    self.titleLabel.text = information.title;
    self.releaseTimeLabel.text = [NSString stringWithHowLongAgo:information.createdAt];
    self.likeNumber.text = [information.like stringValue];
    self.favoriteNumber.text = [information.favorite stringValue];
    if ( [information.category isEqualToString:GetInformationTypeForStaff] ){
        self.seeNumber.text = [information.read stringValue];
        self.sourceLabel.text = information.source;
    } else if ( [information.category isEqualToString:GetInformationTypeClubNews] ){
        
    } else if ( [information.category isEqualToString:GetInformationTypeSchoolNews] ){
        self.seeNumber.text = [information.read stringValue];
        self.sourceLabel.text = information.source;
    } else if ( [information.category isEqualToString:GetInformationTypeAround] ){
        self.location.text = information.location;
        [self.recommendImage setImageWithURL:[NSURL URLWithString:information.image]];
    }
    self.seeNumber.text = [information.read stringValue];
    _information = information;
#ifdef DEBUG
    NSLog(@"Information (%@,%@) has been set in WUTableHeaderView",information.informationId,information.title);
#endif
}

-(void) setStar:(Star *)star
{
    [self.starImage setImageWithURL:[NSURL URLWithString:star.avatarLink]];
    self.starName.text = star.title;
    self.starTitle.text = star.jobTitle;
    self.starSummary.text = star.words;
    self.likeNumber.text = [star.like stringValue];
    self.favoriteNumber.text = [star.favorite stringValue];
    self.starNumber.text = star.count;
    _star = star;
#ifdef DEBUG
    NSLog(@"Star (%@,%@) has been set in WUTableHeaderView",star.starId,star.title);
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
