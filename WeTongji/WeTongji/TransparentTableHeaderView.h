//
//  TransparentTableHeaderView.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-15.
//
//

#import <UIKit/UIKit.h>
#import "Information+Addition.h"

@interface TransparentTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) Information * information;

-(void) setHideBoard:(BOOL) hide;

@end
