//
//  WeeklyPersonHeaderCell.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import "WUTapImageView.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "Star+Addition.h"

@interface WeeklyPersonHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *summary;
@property (weak, nonatomic) IBOutlet WUTapImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *personBG;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@property (weak, nonatomic) Star * star;

@end
