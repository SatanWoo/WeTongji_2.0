//
//  RegisterViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "RegisterViewController.h"
#import "RegInfomationCell.h"
#import "Macro.h"

#define kMailURL @"http://mail.tongji.edu.cn"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation RegisterViewController

- (BOOL) isIphone5
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if ((screenWidth==568)||(screenHeight==568)) {
        return YES;
    }
    return NO;
}

- (void) autolayout
{
    CGRect frame = self.nextButton.frame;
    frame.origin.y = self.view.frame.size.height - 102;
    [self.nextButton setFrame:frame];
    if ( [self isIphone5] )
    {
        [self.backImageView setImage:[UIImage imageNamed:@"bg_reg-568h@2x.png"]];
    }
    else
    {
        [self.backImageView setImage:[UIImage imageNamed:@"bg_reg"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self autolayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillUnload
{
    [super viewWillUnload];
}

- (void)viewDidUnload
{
    [self setBackImageView:nil];
    [self setNextButton:nil];
    [super viewDidUnload];
}

- (IBAction)registerMail:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kMailURL]];
}
@end
