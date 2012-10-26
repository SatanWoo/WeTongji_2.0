//
//  CampusViewController.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-20.
//
//

#import "MiddleAbstractViewController.h"

@interface CampusViewController : MiddleAbstractViewController
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,weak) IBOutlet UIImageView *indicator;
@property (nonatomic ,weak) IBOutlet UIButton *schoolInfoButton;
@property (nonatomic ,weak) IBOutlet UIButton *groupInfoButton;
@property (nonatomic ,weak) IBOutlet UIButton *actionButton;
@property (nonatomic ,weak) IBOutlet UIButton *recommendButton;

- (IBAction)buttonPressed:(UIButton *)sender;

@end
