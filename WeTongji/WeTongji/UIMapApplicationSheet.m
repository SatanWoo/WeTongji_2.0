//
//  UIMapApplicationSheet.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-12-6.
//
//

#import "UIMapApplicationSheet.h"

@interface UIMapApplicationSheet()<UIActionSheetDelegate>
@property (nonatomic,strong) NSString * location;
@end

@implementation UIMapApplicationSheet

-(id) initWithLocation:(NSString *)location
{
    self = [super initWithTitle:[NSString stringWithFormat:@"用地图搜索\"%@\"?",location] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    if (self) {
        self.location = location;
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ( ![buttonTitle isEqualToString:@"确定"] ) return;
    NSString *strHospitalAddress = self.location;
    NSString *strHospitalMap;
    NSInteger version = [[[UIDevice currentDevice] systemVersion] intValue];
    switch (version) {
        case 5:
            strHospitalMap = @"http://maps.google.com/maps?q=";
            break;
        case 6:
            strHospitalMap = @"http://maps.apple.com/maps?q=";
            break;
        default:
            break;
    }
    NSURL *searchMap = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", strHospitalMap,
                                             [strHospitalAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[UIApplication sharedApplication] openURL:searchMap];
}

@end
