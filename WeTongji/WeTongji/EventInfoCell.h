//
//  EventInfoCell.h
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInfoCell : UITableViewCell

// Upper
@property (nonatomic ,weak) IBOutlet UILabel *eventName;
@property (nonatomic ,weak) IBOutlet UILabel *location;
@property (nonatomic ,weak) IBOutlet UILabel *eventTime;
@property (nonatomic ,weak) IBOutlet UILabel *refreshTime;

// Down
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UIView *disableView;
@property (nonatomic, weak) IBOutlet UIButton *favorButton;
@property (nonatomic, weak) IBOutlet UILabel *favorLabel;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UILabel *likeLabel;
@property (nonatomic, weak) IBOutlet UIButton *lookButton;
@property (nonatomic, weak) IBOutlet UILabel *lookLabel;
@property (nonatomic, weak) IBOutlet UILabel *organizationLabel;

@end
