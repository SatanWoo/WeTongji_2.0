//
//  WeeklyPersonCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "Star+Addition.h"

@interface WeeklyPersonCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UIImageView *avatar;
@property (nonatomic ,weak) IBOutlet UILabel *name;
@property (nonatomic ,weak) IBOutlet UILabel *count;
@property (nonatomic ,weak) IBOutlet UILabel *job;
@property (nonatomic ,weak) Star * star;

@end
