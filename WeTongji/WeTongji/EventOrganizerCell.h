//
//  EventOrganizerCell.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import "Event+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface EventOrganizerCell : UITableViewCell

@property (nonatomic,weak) Event * event;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *organizer;
@property (weak, nonatomic) IBOutlet UILabel *category;

@end
