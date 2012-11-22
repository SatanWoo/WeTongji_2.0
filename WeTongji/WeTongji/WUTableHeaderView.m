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
#import "MBProgressHUD.h"
#import "User+Addition.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface WUTableHeaderView()<MBProgressHUDDelegate>
{
    BOOL _isButtonBoardLeft;
}
@property (weak, nonatomic) IBOutlet UIView *buttonBoard;
@property (strong, nonatomic) MBProgressHUD * progress;
@property (nonatomic,readonly) BOOL isLogIn;
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

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:_progress];
        _progress.delegate = self;
        _progress.margin = 10.f;
        _progress.yOffset = 150.f;
        _progress.mode = MBProgressHUDModeText;
    }
    return _progress;
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [self.progress removeFromSuperview];
    self.progress =  nil;
}

-(BOOL) isLogIn
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ( [User userinManagedObjectContext:appDelegate.managedObjectContext] ) return YES;
    return NO;
}

-(void)pleaseLogIn
{
    self.progress.labelText = @"请先登陆";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) likeSucceed
{
    self.progress.labelText = @"赞成功";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) disLikeSucced
{
    self.progress.labelText = @"取消赞成功";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) favoriteSucceed
{
    self.progress.labelText = @"已添加到收藏";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) unFavoriteSucceed
{
    self.progress.labelText = @"已取消收藏";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) scheduleSucceed
{
    self.progress.labelText = @"已添加到日程";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) unScheduleSucceed
{
    self.progress.labelText = @"已取消该日程";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:1];
}

-(void) changeButtonPositionToLeft
{
    if ( _isButtonBoardLeft ) return;
    CGPoint center = [self.buttonBoard center];
    if ( self.star ) {
        center.x = center.x + 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeClubNews] ) {
        center.x = center.x + 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeSchoolNews] ) {
        center.x = center.x + 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeForStaff] ) {
        center.x = center.x + 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround] ) {
        center.x = center.x -20;
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
        center.x = center.x - 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeClubNews] ) {
        center.x = center.x - 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeSchoolNews] ) {
        center.x = center.x - 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeForStaff] ) {
        center.x = center.x - 100;
    } else if ( self.information && [self.information.category isEqualToString:GetInformationTypeAround] ) {
        center.x = center.x + 20;
        [self.recommendImage setAlpha:1];
    } else
    center.x = center.x - 54;
    [self.buttonBoard setCenter:center];
    _isButtonBoardLeft = NO;
}

-(void) configButton
{
    [self.likeButton setImage:[UIImage imageNamed:@"like_hl"] forState:UIControlStateHighlighted];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_hl"] forState:UIControlStateHighlighted];
    [self.addScheduleButton setImage:[UIImage imageNamed:@"add_to_schedule_hl"] forState:UIControlStateHighlighted];
#ifdef DEBUG
    NSLog(@"event       : %@",self.event);
    NSLog(@"information : %@",self.information);
    NSLog(@"star        : %@",self.star);
#endif
    if ( [self.event.canLike boolValue] || [self.information.canLike boolValue] || [self.star.canLike boolValue] );else [self.likeButton setImage:[UIImage imageNamed:@"like_hl"] forState:UIControlStateNormal];
    if ( [self.event.canFavorite boolValue] || [self.information.canFavorite boolValue] || [self.star.canFavorite boolValue] );else [self.favoriteButton setImage:[UIImage imageNamed:@"favourite_hl"] forState:UIControlStateNormal];
    if ( [self.event.canSchedule boolValue] );else [self.addScheduleButton setImage:[UIImage imageNamed:@"add_to_schedule_hl"] forState:UIControlStateNormal];
}
- (IBAction)likeClicked:(id)sender
{
    if ( !self.isLogIn )
    {
        [self pleaseLogIn];
        return;
    }
    NSString * purposeImage;
    if ( [self.event.canLike boolValue] || [self.information.canLike boolValue] || [self.star.canLike boolValue] )
        purposeImage = @"like_hl";
    else purposeImage = @"like";
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                            #ifdef DEBUG
                               if ( [purposeImage isEqualToString:@"like_hl"] )
                                   NSLog(@"like operation succeed!");
                               else NSLog(@"unlike operation succeed!");
                            #endif
                               NSInteger tempInt;
                               if ( [purposeImage isEqualToString:@"like_hl"] )
                               {
                                   [self likeSucceed];
                                   tempInt = 1;
                               }
                               else
                               {
                                   [self disLikeSucced];
                                   tempInt = -1;
                               }
                               self.event.like = [NSNumber numberWithInt:([self.event.like intValue] + tempInt)];
                               self.information.like = [NSNumber numberWithInt:([self.information.like intValue] + tempInt)];
                               self.star.like = [NSNumber numberWithInt:([self.star.like intValue] + tempInt)];
                               if ( self.event )
                                   self.likeNumber.text = [NSString stringWithFormat:@"%@",self.event.like];
                               if ( self.information )
                                   self.likeNumber.text = [NSString stringWithFormat:@"%@",self.information.like];
                               if ( self.star )
                                   self.likeNumber.text = [NSString stringWithFormat:@"%@",self.star.like];
                               self.event.canLike = [NSNumber numberWithBool:!self.event.canLike.boolValue];
                               self.information.canLike = [NSNumber numberWithBool:!self.information.canLike.boolValue];
                               self.star.canLike = [NSNumber numberWithBool:!self.star.canLike.boolValue];
                               [self.likeButton setImage:[UIImage imageNamed:purposeImage] forState:UIControlStateNormal];
                           }
                            failureBlock:^(NSError * error)
                           {
                            #ifdef DEBUG
                               if ( [purposeImage isEqualToString:@"like_hl"] )
                                   NSLog(@"like operation failed!");
                               else NSLog(@"unlike operation failed!");
                            #endif
                               self.progress.labelText = [[error userInfo] objectForKey:@"errorDesc"];
                               self.progress.mode = MBProgressHUDModeText;
                               [self.progress hide:YES afterDelay:1];
                           }];
    
    if ( self.event )
    {
        if ( [self.event.canLike boolValue] )
        {
            [request setLikeActivitiy:self.event.activityId];
        }
        else
        {
            [request cancelLikeActivity:self.event.activityId];
        }
    }
    if ( self.information )
    {
        if ( [self.information.canLike boolValue] )
        {
            [request setInformationLike:self.information.informationId inType:self.information.category];
        }
        else
        {
            [request setInformationUnLike:self.information.informationId inType:self.information.category];
        }
    }
    if ( self.star )
    {
        if ( [self.star.canLike boolValue] )
        {
            [request likeStar:self.star.starId];
        }
        else
        {
            [request unlikeStar:self.star.starId];
        }
    }
    [client enqueueRequest:request];
}

- (IBAction)favoriteClicked:(id)sender
{
    if ( !self.isLogIn )
    {
        [self pleaseLogIn];
        return;
    }
    NSString * purposeImage;
    if ( [self.event.canFavorite boolValue] || [self.information.canFavorite boolValue] || [self.star.canFavorite boolValue] )
        purposeImage = @"favourite_hl";
    else purposeImage = @"favourite";
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                            #ifdef DEBUG
                               if ( [purposeImage isEqualToString:@"favourite_hl"] )
                                   NSLog(@"favourite operation succeed!");
                               else NSLog(@"unfavourite operation succeed!");
                            #endif
                               NSInteger tempInt;
                               if ( [purposeImage isEqualToString:@"favourite_hl"] )
                               {
                                   [self favoriteSucceed];
                                   tempInt = +1;
                               }
                               else
                               {
                                   [self unFavoriteSucceed];
                                   tempInt = -1;
                               }
                               self.event.favorite = [NSNumber numberWithInt:([self.event.favorite intValue] + tempInt)];
                               self.information.favorite = [NSNumber numberWithInt:([self.information.favorite intValue] + tempInt)];
                               self.star.favorite = [NSNumber numberWithInt:([self.star.favorite intValue] + tempInt)];
                               if ( self.event )
                                   self.favoriteNumber.text = [NSString stringWithFormat:@"%@",self.event.favorite];
                               if ( self.information )
                                   self.favoriteNumber.text = [NSString stringWithFormat:@"%@",self.information.favorite];
                               if ( self.star )
                                   self.favoriteNumber.text = [NSString stringWithFormat:@"%@",self.star.favorite];
                               self.event.canFavorite = [NSNumber numberWithBool:!self.event.canFavorite.boolValue];
                               self.information.canFavorite = [NSNumber numberWithBool:!self.information.canFavorite.boolValue];
                               self.star.canFavorite = [NSNumber numberWithBool:!self.star.canFavorite.boolValue];
                               [self.favoriteButton setImage:[UIImage imageNamed:purposeImage] forState:UIControlStateNormal];
                           }
                            failureBlock:^(NSError * error)
                           {
                            #ifdef DEBUG
                               if ( [purposeImage isEqualToString:@"favourite_hl"] )
                                   NSLog(@"favourite operation failed!");
                               else NSLog(@"unfavourite operation failed!");
                            #endif
                               self.progress.labelText = [[error userInfo] objectForKey:@"errorDesc"];
                               self.progress.mode = MBProgressHUDModeText;
                               [self.progress hide:YES afterDelay:1];
                           }];
    
    if ( self.event )
    {
        if ( [self.event.canFavorite boolValue] )
        {
            [request setActivityFavored:self.event.activityId];
        }
        else
        {
            [request cancelActivityFavored:self.event.activityId];
        }
    }
    if ( self.information )
    {
        if ( [self.information.canFavorite boolValue] )
        {
            [request setInformationFavored:self.information.informationId inType:self.information.category];
        }
        else
        {
            [request setInformationUnFavored:self.information.informationId inType:self.information.category];
        }
    }
    if ( self.star )
    {
        if ( [self.star.canFavorite boolValue] )
        {
            [request setStarFavored:self.star.starId];
        }
        else
        {
            [request cancelStarFaved:self.star.starId];
        }
    }
    [client enqueueRequest:request];
}

- (IBAction)addScheduleClicked:(id)sender
{
    if ( !self.isLogIn )
    {
        [self pleaseLogIn];
        return;
    }
    NSString * purposeImage;
    if ( [self.event.canSchedule boolValue] )
        purposeImage = @"add_to_schedule_hl";
    else purposeImage = @"add_to_schedule";
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                            #ifdef DEBUG
                               if ( [purposeImage isEqualToString:@"add_to_schedule_hl"] )
                                   NSLog(@"schedule operation succeed!");
                               else NSLog(@"unschedule operation succeed!");
                            #endif
                               if ( [purposeImage isEqualToString:@"add_to_schedule_hl"] )
                                   [self scheduleSucceed];
                               else [self unScheduleSucceed];
                               self.event.canSchedule = [NSNumber numberWithBool:!self.event.canSchedule.boolValue];
                               [self.addScheduleButton setImage:[UIImage imageNamed:purposeImage] forState:UIControlStateNormal];
                           }
                            failureBlock:^(NSError * error)
                           {
                            #ifdef DEBUG
                               if ( [purposeImage isEqualToString:@"favourite_hl"] )
                                   NSLog(@"schedule operation failed!");
                               else NSLog(@"unschedule operation failed!");
                            #endif
                               self.progress.labelText = [[error userInfo] objectForKey:@"errorDesc"];
                               self.progress.mode = MBProgressHUDModeText;
                               [self.progress hide:YES afterDelay:1];
                           }];
    
    if ( self.event )
    {
        if ( [self.event.canSchedule boolValue] )
        {
            [request setActivityScheduled:self.event.activityId];
        }
        else
        {
            [request cancelActivityScheduled:self.event.activityId];
        }
    }
    [client enqueueRequest:request];
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
    [self configButton];
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
    [self configButton];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:nil failureBlock:nil];
    [request readInformaion:information.informationId inType:information.category];
    [client enqueueRequest:request];
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
    self.starNumber.text = [NSString stringWithFormat:@"第%@期",star.count];
    _star = star;
    [self configButton];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:nil failureBlock:nil];
    [request readStar:star.starId];
    [client enqueueRequest:request];
#ifdef DEBUG
    NSLog(@"Star (%@,%@) has been set in WUTableHeaderView",star.starId,star.title);
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


@end
