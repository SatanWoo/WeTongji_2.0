//
//  UpdatePasswordViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-22.
//
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *confirm;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *oldPass;

- (IBAction)touchOnTextFiled:(UITextField *)textField;
- (IBAction)textDidEndEdit:(id)sender;
@end
