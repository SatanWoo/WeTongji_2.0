//
//  RegisterSecondViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractSecondViewController.h"

@interface RegisterSecondViewController : MiddleAbstractSecondViewController
@property (weak, nonatomic) IBOutlet UITextField *stuNumber;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)touchOnTextFiled:(UITextField *)textField;
- (IBAction)showUserProtocol:(id)sender;
@end
