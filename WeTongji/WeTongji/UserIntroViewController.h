//
//  UserIntroViewController.h
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@interface UserIntroViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBar;
@property (weak, nonatomic) IBOutlet UIButton *registerloginbtn;
- (void)addPicture:(UIView *)view;
@end
