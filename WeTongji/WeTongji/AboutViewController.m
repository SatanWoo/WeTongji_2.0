//
//  AboutViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-18.
//
//

#import "AboutViewController.h"
#import "UIBarButtonItem+CustomButton.h"
#import "AboutHeaderView.h"
#import "Macro.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#define WE_TONGJI_EMAIL             @"wetongji2012@gmail.com"
#define WE_TONGJI_SINA_WEIBO_URL    @"http://www.weibo.com/wetongji"
#define WE_TONGJI_APP_STORE_URL     @"http://itunes.apple.com/cn/app/id526260090?mt=8"
#define WE_TONGJ_OFFICAL_WEBSITE    @"http://we.tongji.edu.cn"
#define WE_TONGJI_RERREN            @"http://page.renren.com/601362138"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
- (void)configureNavBar;
- (void)pressNavButton;
@end

@implementation AboutViewController

- (void)pressNavButton
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_finish_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
    self.aboutTableView.tableFooterView = [[[NSBundle mainBundle] loadNibNamed:@"InfoFooterView" owner:self options:nil] objectAtIndex:0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)viewDidUnload {
    [self setAboutTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"给WeTongji打分";
        cell.imageView.image = nil;
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textLabel.text = @"提意见";
        cell.imageView.image = nil;
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        cell.textLabel.text = @"用户协议";
        cell.imageView.image = nil;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"微同济官方微博";
        cell.imageView.image = [UIImage imageNamed:@"weibo_logo"];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = @"微同济人人主页";
        cell.imageView.image = [UIImage imageNamed:@"renren_logo"];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        cell.textLabel.text = @"微同济官方主页";
        cell.imageView.image = [UIImage imageNamed:@"we_logo"];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"分享给好友";
        cell.imageView.image = nil;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AboutHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:self options:nil] objectAtIndex:0];
    if (section == 0) {
        headerView.name.text = @"应用信息";
    } else {
        headerView.name.text = @"关注我们";
    }
    return headerView;
}


- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WE_TONGJI_APP_STORE_URL]];  
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        [self triggerMail];
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        [self performSegueWithIdentifier:kProtocolViewControllerSegue sender:self];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WE_TONGJI_SINA_WEIBO_URL]];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WE_TONGJI_RERREN]];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WE_TONGJ_OFFICAL_WEBSITE]];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        [self triggerMessage];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)triggerMessage
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    if (!picker) {
        return ;
    }
    picker.messageComposeDelegate = self;
    picker.body = @"我正在使用微同济-同济大学专属校园移动应用，帮助管理我的大学日程，推送校内校外的大小活动，不再错过任何一个精彩的活动，快点和我一起去下载(we.tongji.edu.cn)";
    picker.recipients = [NSArray arrayWithObject:@"13"];
    [self presentModalViewController:picker animated:YES];
}

- (void)triggerMail
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if (!picker) {
        return;
    }
    picker.mailComposeDelegate = self;
    [picker setSubject:@"微同济 2.0 用户反馈"];
    [picker.navigationBar setBarStyle:UIBarStyleBlack];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:WE_TONGJI_EMAIL, nil];
    NSString *emailBody = @"您的宝贵建议会直接送达微同济开发团队。";
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:picker animated:YES];
}

#pragma mark - MFMailComposeViewController delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if(result == MFMailComposeResultSent) {
        
    }
    else if(result == MFMailComposeResultFailed) {
            
    }
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    if(result == MessageComposeResultSent) {
        
    }
    else if(result == MessageComposeResultFailed) {
        
    }
	[self dismissModalViewControllerAnimated:YES];
}

@end
