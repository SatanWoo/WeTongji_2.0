//
//  PasswordViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractSecondViewController.h"

@interface PasswordViewController : MiddleAbstractSecondViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *name;

- (IBAction)findPassword:(id)sender;
@end
