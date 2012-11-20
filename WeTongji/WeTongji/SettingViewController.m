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
#import <WeTongjiSDK/WeTongjiSDK.h>


@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,readonly) BOOL isLogIn;

- (void)configureTableView;

@end

@implementation SettingViewController

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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn" selector:@selector(pressNavButton) target:self];
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
#ifdef DEBUG
    NSLog(@"log out clicked!");
#endif
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
       else return 0;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingNoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingNoImageCell];
    if (cell == nil) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"SettingNoImageCell" owner:self options:nil] objectAtIndex:0];
        cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.swtich.hidden = NO;
    } else {
        cell.swtich.hidden = YES;
    }
        
    if (indexPath.section == 0) {
        cell.textLabel.text = @"更改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        if (indexPath.row == 0) {
            cell.name.text = @"仅在Wifi下加载图片";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if (indexPath.row == 1) {
            cell.name.text = @"检测新版本";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 2){
            cell.name.text = @"清楚缓存";
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
