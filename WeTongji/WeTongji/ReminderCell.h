//
//  ReminderCell.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-28.
//
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UIView *detailContentView;
@property (nonatomic ,weak) IBOutlet UILabel *eventNameLabel;
@property (nonatomic ,weak) IBOutlet UIImageView *timeIcon;
@property (nonatomic ,weak) IBOutlet UIImageView *locationIcon;
@property (nonatomic ,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic ,weak) IBOutlet UILabel *locationLabel;
@end
