//
//  MyfavoriteEventCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-12-2.
//
//

#import <UIKit/UIKit.h>

@interface MyFavoriteEventCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avatar;
@property (nonatomic, strong) IBOutlet UILabel *sourceLabel;

@end
