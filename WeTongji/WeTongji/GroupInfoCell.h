//
//  GroupInfoCell.h
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-1.
//
//

#import <UIKit/UIKit.h>
#import "Information+Addition.h"

@interface GroupInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *seeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *organizerAvatar;
@property (weak, nonatomic) Information * information;

@end
