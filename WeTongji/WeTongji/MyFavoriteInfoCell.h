//
//  MyFavoriteInfoCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-12-2.
//
//

#import <UIKit/UIKit.h>
#import "MyFavoriteCell.h"

@interface MyFavoriteInfoCell : MyFavoriteCell
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *sourceLabel;
@end
