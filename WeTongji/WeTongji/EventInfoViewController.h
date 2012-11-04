//
//  EventInfoViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractViewController.h"
#import "WUPopOverView.h"

@interface EventInfoViewController : MiddleAbstractViewController
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@property (weak, nonatomic) IBOutlet WUPopOverView *filterView;
- (IBAction)filterEvent:(UIButton *)sender;
@end
