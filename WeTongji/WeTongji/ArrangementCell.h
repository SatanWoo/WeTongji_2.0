//
//  ArrangementCell.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-5.
//
//

#import <UIKit/UIKit.h>

@interface ArrangementCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic ,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic ,weak) IBOutlet UILabel *locationLabel;
@property (nonatomic ,weak) IBOutlet UIImageView *colorBall;
@property (nonatomic ,weak) IBOutlet UIImageView *line;
@property (nonatomic ,weak) IBOutlet UIImageView *locationIcon;
@end
