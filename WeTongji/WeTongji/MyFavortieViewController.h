//
//  MyFavortieViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractSecondViewController.h"

enum sectionName {
    eRECOMMEND = 0,
    eSCHOOL = 1,
    ePERSON = 2
};

@interface MyFavortieViewController : MiddleAbstractSecondViewController
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIButton *schoolInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *celebrityButton;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end
