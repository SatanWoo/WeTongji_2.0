//
//  FilterTableViewCell.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
