//
//  EditInfoViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-12.
//
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractViewController.h"

@interface EditInfoViewController : MiddleAbstractViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileAvatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@end
