//
//  SchoolNewsViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+Addition.h"
#import "Information+Addition.h"
#import "Star+Addition.h"

@interface SchoolNewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) Event * event;
@property (weak, nonatomic) Information * information;


- (IBAction)goBack:(id)sender;
@end
