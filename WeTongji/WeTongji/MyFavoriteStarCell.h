//
//  MyFavoriteStarCell.h
//  WeTongji
//
//  Created by Tang Zhixiong on 12-12-2.
//
//

#import <UIKit/UIKit.h>
#import "MyFavoriteCell.h"

@interface MyFavoriteStarCell : MyFavoriteCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *words;

@end
