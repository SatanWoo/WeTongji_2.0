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
@property (weak, nonatomic) IBOutlet UIButton *directUser;
@property (weak, nonatomic) IBOutlet UIView *moveView;
- (void)addPicture:(UIView *)view;
- (IBAction)directUser:(id)sender;
@end
