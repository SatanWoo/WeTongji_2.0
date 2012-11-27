//
//  WUTableHeaderView.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-4.
//
//

#import <UIKit/UIKit.h>
#import "Information+Addition.h"
#import "Event+Addition.h"
#import "Star+Addition.h"

@interface WUTableHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *upperHiddenView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *seeNumber;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *favoriteNumber;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIView *moveFavorView;
@property (weak, nonatomic) IBOutlet UIView *moveLikeView;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UIImageView *recommendImage;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *starNumber;
@property (weak, nonatomic) IBOutlet UILabel *starName;
@property (weak, nonatomic) IBOutlet UILabel *starTitle;
@property (weak, nonatomic) IBOutlet UILabel *starSummary;
@property (weak, nonatomic) Event * event;
@property (weak, nonatomic) Information * information;
@property (weak, nonatomic) Star * star;
@property (weak, nonatomic) IBOutlet UIButton *addScheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonBg;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButtonBg;
@property (weak, nonatomic) IBOutlet UIButton *addToScheduleBg;

-(void) changeButtonPositionToLeft;
-(void) resetButtonPosition;

@end
