//
//  RecommendCell.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UILabel *infoTitle;
@property (nonatomic ,weak) IBOutlet UILabel *source;
@property (nonatomic ,weak) IBOutlet UIImageView *icon;
@property (nonatomic ,weak) IBOutlet UILabel *count;

@end
