//
//  SchoolNewsViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


- (IBAction)goBack:(id)sender;
@end
