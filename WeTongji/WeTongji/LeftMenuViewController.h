//
//  LeftMenuViewController.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewControllerDelegate <NSObject>
- (void)changeMiddleContent:(UIViewController *)controller;
@end

@interface LeftMenuViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) IBOutlet id<LeftMenuViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
- (IBAction)triggerSetting:(UIButton *)sender;
- (IBAction)triggerInfo:(UIButton *)sender;

@end
