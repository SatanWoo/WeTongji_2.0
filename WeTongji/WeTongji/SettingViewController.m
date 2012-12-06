//
//  SettingViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-19.
//
//

#import "SettingViewController.h"
#import "SettingNoImageCell.h"
#import "Macro.h"
#import "AboutHeaderView.h"
#import "UIBarButtonItem+CustomButton.h"
#import "User+Addition.h"
#import "Course+Addition.h"
#import "Event+Addition.h"
#import "Information+Addition.h"
#import "Star+Addition.h"
#import "Exam+Addition.h"
#import "Channel+Addition.h"
#import "MBProgressHUD.h"
#import <WeTongjiSDK/WeTongjiSDK.h>


@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>

@property (nonatomic,readonly) BOOL isLogIn;
@property (nonatomic,strong) MBProgressHUD * progress;
@property (nonatomic,strong) NSString * versionUrlString;

- (void)configureTableView;

@end

@implementation SettingViewController

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
    }
    return _progress;
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [self.progress removeFromSuperview];
    self.progress = nil;
}

-(BOOL) isLogIn
{
    if ( [User userinManagedObjectContext:self.managedObjectContext] ) return YES;
    else return NO;
}

- (void)pressNavButton
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_finish_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

-(void)adjust
{
    [self.settingTableView.tableFooterView setHidden:!self.isLogIn];
    [self.settingTableView reloadData];
}

- (void)configureTableView
{    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logout_btn"]];
    [button setImage:imageView.image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height)];
    self.settingTableView.tableFooterView = button;
}

-(void) logout
{
    [User userClearinManagedObjectContext:self.managedObjectContext];
    [Course clearDataInManagedObjectContext:self.managedObjectContext];
    [Exam clearDataInManagedObjectContext:self.managedObjectContext];
    NSArray * list = [Event allEventsInManagedObjectContext:self.managedObjectContext];
    for ( Event * event in list )
    {
        event.canFavorite = [NSNumber numberWithBool:YES];
        event.canLike = [NSNumber numberWithBool:YES];
        event.canSchedule = [NSNumber numberWithBool:YES];
    }
    list = [Information getAllInformationWithCategory:nil inManagedObjectContext:self.managedObjectContext];
    for ( Information * information in list )
    {
        information.canFavorite = [NSNumber numberWithBool:YES];
        information.canLike = [NSNumber numberWithBool:YES];
    }
    list = [Star getAllStarsInManagedObjectContext:self.managedObjectContext];
    for ( Star * star in list )
    {
        star.canLike = [NSNumber numberWithBool:YES];
        star.canFavorite = [NSNumber numberWithBool:YES];
    }
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:nil failureBlock:nil];
    [request logoff];
    [client enqueueRequest:request];
    [NSUserDefaults setCurrentUserID:@"" session:@""];
    [self adjust];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:self];
    self.progress.mode = MBProgressHUDModeText;
    self.progress.labelText = @"您已成功登出";
    [self.progress show:YES];
    [self.progress hide:YES afterDelay:0.5];
#ifdef DEBUG
    NSLog(@"log out clicked!");
#endif
}

-(void) checkNewVerion
{
    self.progress.mode = MBProgressHUDModeIndeterminate;
    self.progress.labelText = @"版本检测中...";
    [self.progress show:YES];
    WTClient * client = [WTClient sharedClient];
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseData)
                          {
                            #ifdef DEBUG
                              NSLog(@"%@",responseData);
                            #endif
                              [self.progress hide:YES];
                              id version = [responseData objectForKey:@"Version"];
                              if ([version isKindOfClass:[NSNull class]])
                              {
                                  UIAlertView *  alert = [[UIAlertView alloc]
                                                          initWithTitle:@"当前已经是最新版" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                                  [alert show];
                              }
                              else
                              {
                                  NSString * current = [version objectForKey:@"Current"];
                                  NSString * latest = [version objectForKey:@"Latest"];
                                  self.versionUrlString = [version objectForKey:@"Url"];
                                  UIAlertView *  alert = [[UIAlertView alloc]
                                                          initWithTitle:@"检测到最新版本" message:[NSString stringWithFormat:@"您当前版本为%@,已检测到最新版：%@，是否前往下载？",current,latest] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                                  [alert show];
                              }
                          }
                            failureBlock:^(NSError * error)
                          {
                              self.progress.mode = MBProgressHUDModeText;
                              self.progress.labelText = @"监测失败";
                              self.progress.detailsLabelText = [[error userInfo] objectForKey:@"errorDesc"] ;
                              [self.progress hide:YES afterDelay:1];
                          }];
    [request getNewVersion];
    [client enqueueRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
    [self configureTableView];
    [self adjust];
#ifdef DEBUG
    NSLog(@"isLogIn:%d",self.isLogIn);
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setSettingTableView:nil];
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
       if (self.isLogIn) return 1;
       else return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingNoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingNoImageCell];
    if (cell == nil) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"SettingNoImageCell" owner:self options:nil] objectAtIndex:0];
        cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        cell.swtich.hidden = YES;
    } else {
        cell.swtich.hidden = YES;
    }
        
    if (indexPath.section == 0) {
        if ( self.isLogIn )
        {
            cell.name.text = @"更改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.name.text = @"登录";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        if (indexPath.row == 3) {
            cell.name.text = @"仅在Wifi下加载图片";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if (indexPath.row == 1) {
            cell.name.text = @"检测新版本";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2){
            cell.name.text = @"清除缓存";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.name.text = @"校园资讯默认界面";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AboutHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:self options:nil] objectAtIndex:0];
    if (section == 0) {
        headerView.name.text = @"账户信息";
    } else {
        headerView.name.text = @"应用相关";
    }
    return headerView;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 20;
    } else {
        return 0;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.isLogIn)
            [self performSegueWithIdentifier:kUpdatePasswordViewControllerSegue sender:self];
        else
        {
            [self dismissModalViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:self];
        }
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:kSchoolPreferenceViewControllerSegue sender:self];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [self checkNewVerion];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        UIAlertView *  alert = [[UIAlertView alloc]
                 initWithTitle:@"确定清除缓存？" message:@"清除后应用将还原到第一次开启的界面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 ) return ;
    if ( [alertView.title isEqualToString:@"确定清除缓存？"])
    {
        [User userClearinManagedObjectContext:self.managedObjectContext];
        [Event clearAllEventInManagedObjectContext:self.managedObjectContext];
        [Information clearDataInManagedObjectContext:self.managedObjectContext];
        [Star clearDataInManagedObjectContext:self.managedObjectContext];
        [Exam clearDataInManagedObjectContext:self.managedObjectContext];
        [Course clearDataInManagedObjectContext:self.managedObjectContext];
        [Channel clearAllChannelsInManagedObjectContext:self.managedObjectContext];
        [self pressNavButton];
        WTClient * client = [WTClient sharedClient];
        WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                               {
                                #ifdef DEBUG
                                   NSLog(@"%@",responseData);
                                #endif
                                   NSArray *list = [responseData objectForKey:@"Channels"];
                                   for ( NSDictionary *dict in list )
                                       [Channel insertChannel:dict inManagedObjectContext:self.managedObjectContext];
                               }failureBlock:nil];
        [request getChannels];
        [client enqueueRequest:request];
        [NSUserDefaults setCurrentSemesterBeginTime:[NSDate dateWithTimeIntervalSinceNow:0] endTime:[NSDate dateWithTimeIntervalSinceNow:0]];
        [NSUserDefaults setCurrentUserID:@"" session:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshCacheNotification object:self];
        [self adjust];
    }
    if ( [alertView.title isEqualToString:@"检测到最新版本"] )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionUrlString]];
    }
}

@end
