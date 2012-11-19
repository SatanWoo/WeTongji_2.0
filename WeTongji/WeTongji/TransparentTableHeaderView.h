//
//  TransparentTableHeaderView.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import "Information+Addition.h"
#import "Event+Addition.h"

@interface TransparentTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) Information * information;
@property (weak, nonatomic) Event * event;

-(void) setHideBoard:(BOOL) hide;

@end
