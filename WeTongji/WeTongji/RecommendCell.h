//
//  RecommendCell.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import <UIKit/UIKit.h>
#import "Information+Addition.h"

@interface RecommendCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UILabel *infoTitle;
@property (nonatomic ,weak) IBOutlet UILabel *source;
@property (nonatomic ,weak) IBOutlet UIImageView *icon;
@property (nonatomic ,weak) IBOutlet UILabel *count;
@property (nonatomic ,weak) IBOutlet UIImageView *preview;
@property (nonatomic ,weak) Information * information;
@end
