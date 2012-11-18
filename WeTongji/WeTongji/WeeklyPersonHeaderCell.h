//
//  WeeklyPersonHeaderCell.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import "WUTapImageView.h"

@interface WeeklyPersonHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet WUTapImageView *image;

@end
