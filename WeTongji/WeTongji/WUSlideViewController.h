//
//  WUSlideViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"

enum eStatus {
    eMIDDLE = 0,
    eLEFT = 1,
    
};

enum eMoveDirection {
    eMOVETOLEFT = 0,
    eMOVETORIGHT = 1
};

@interface WUSlideViewController : UIViewController<UIGestureRecognizerDelegate,LeftMenuViewControllerDelegate>

@property (nonatomic ,strong) UIViewController *middelViewController;
@property (nonatomic ,strong) LeftMenuViewController *leftViewController;

//- (void)showMiddleViewController;
//- (void)showLeftViewController;
//- (void)updateMiddleViewController:(UIViewController *)viewController animated:(BOOL)animate;

@end
