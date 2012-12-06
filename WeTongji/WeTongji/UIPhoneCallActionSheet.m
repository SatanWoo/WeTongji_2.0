//
//  UIPhoneCallActionSheet.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-12-6.
//
//

#import "UIPhoneCallActionSheet.h"
#import <UIKit/UIKit.h>

@interface UIPhoneCallActionSheet()<UIActionSheetDelegate>

@property (nonatomic,strong) NSString * phone;

@end

@implementation UIPhoneCallActionSheet

-(id) initWithPhoneNumber:(NSString *)phoneNumber;
{
    self = [super initWithTitle:[NSString stringWithFormat:@"打电话给%@?",phoneNumber] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    if (self) {
        self.phone = phoneNumber;
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ( ![buttonTitle isEqualToString:@"确定"] ) return;
    NSString *strMob = [[NSString alloc] initWithFormat:@"tel://%@",self.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMob]];
}

@end
