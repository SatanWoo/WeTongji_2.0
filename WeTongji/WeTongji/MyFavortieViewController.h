//
//  MyFavortieViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum eFilterItem {
    eRECOMEND = 0,
    eSCHOOL = 1,
    eCELEBRITY = 2
};

@interface MyFavortieViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIButton *schoolInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *celebrityButton;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

- (IBAction)filterItem:(id)sender;

@end
