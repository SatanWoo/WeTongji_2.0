//
//  LoginViewController.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "MiddleAbstractViewController.h"

@interface LoginViewController : MiddleAbstractViewController
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordForgetBtn;
- (IBAction)logInClick:(id)sender;
@end
