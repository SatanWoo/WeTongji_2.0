//
//  LeftMenuViewController.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"
@class WUSlideViewController;

@protocol LeftMenuViewControllerDelegate <NSObject>
- (void)changeMiddleContent:(UIViewController *)controller;
@end

@interface LeftMenuViewController : CoreDataViewController
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) IBOutlet id<LeftMenuViewControllerDelegate>delegate;
@property (nonatomic, weak) WUSlideViewController *slideViewController;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (nonatomic ,strong) NSArray *identifierArray;
- (IBAction)triggerSetting:(UIButton *)sender;
- (IBAction)triggerInfo:(UIButton *)sender;

@end
