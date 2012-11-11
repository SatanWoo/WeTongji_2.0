//
//  EventInfoViewController.h
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractViewController.h"

@interface EventInfoViewController : MiddleAbstractViewController
{
    BOOL _reloading;
}
@property (weak, nonatomic) IBOutlet UITableView *eventTableView;
@end
