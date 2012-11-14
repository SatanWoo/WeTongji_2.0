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
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end
