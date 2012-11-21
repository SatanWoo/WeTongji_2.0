//
//  WUPageControlViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-11.
//
//

#import <UIKit/UIKit.h>

@interface WUPageControlViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *pagedScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (void)addPicture:(UIImageView *)image;
- (void)clearPicture;
@end
