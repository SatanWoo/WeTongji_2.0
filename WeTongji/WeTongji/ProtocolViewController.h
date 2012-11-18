//
//  ProtocolViewController.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractSecondViewController.h"
@interface ProtocolViewController : MiddleAbstractSecondViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end
