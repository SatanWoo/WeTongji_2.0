//
//  WUTableHeaderView.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-4.
//
//

#import <UIKit/UIKit.h>

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

@end
