//
//  WUPopOverView.h
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WUPopOverViewDelegate
- (void)selectItemInPopOverViewAtIndex:(UIView *)sender;
@end

@interface WUPopOverView : UIView
@property (nonatomic ,weak) IBOutlet id<WUPopOverViewDelegate> delegate;
- (IBAction)itemTriggered:(UIButton *)sender;
@end
