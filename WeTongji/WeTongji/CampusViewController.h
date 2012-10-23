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
@property (nonatomic ,weak) IBOutlet UIButton *celebrityButton;
@property (nonatomic ,weak) IBOutlet UIButton *eventButton;
@property (nonatomic ,weak) IBOutlet UIButton *newsButton;

- (IBAction)buttonPressed:(UIButton *)sender;

@end
