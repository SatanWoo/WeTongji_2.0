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

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
- (void)configureTableView;
@end

@implementation SettingViewController

- (void)pressNavButton
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)configureNavBar
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)configureTableView
{
    [self.settingTableView registerNib:[UINib nibWithNibName:@"SettingNoImageCell" bundle:nil] forCellReuseIdentifier:kSettingNoImageCell];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
    //[self configureTableView];
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
        return 1;
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.swtich.hidden = NO;
    } else {
        cell.swtich.hidden = YES;
    }
        
    if (indexPath.section == 0) {
        cell.textLabel.text = @"更新密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        if (indexPath.row == 0) {
            cell.name.text = @"仅在Wifi下加载图片";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if (indexPath.row == 1) {
            cell.name.text = @"检测新版本";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.name.text = @"清楚缓存";
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
