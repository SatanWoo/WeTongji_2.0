//
//  LoginViewController.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "CoreDataViewController.h"

@interface LoginViewController : CoreDataViewController

@property (weak, nonatomic) IBOutlet UIButton *navButton;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordForgetBtn;
- (IBAction)logInClick:(id)sender;
- (IBAction)slide:(id)sender;
@end
