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

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>
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
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:@"nav_back_btn" selector:@selector(pressNavButton) target:self];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavBar];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"给WeTongji打分";
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"提意见";
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textLabel.text = @"用户协议";
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"  微同济官方微博";
        cell.imageView.image = [UIImage imageNamed:@"weibo_logo"];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = @"微同济人人主页";
        cell.imageView.image = [UIImage imageNamed:@"renren_logo"];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        cell.textLabel.text = @"  微同济官方主页";
        cell.imageView.image = [UIImage imageNamed:@"we_logo"];
    }
    
    if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_first.png"]];
    } else if (indexPath.row == 2) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_last.png"]];
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_middle.png"]];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AboutHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:self options:nil] objectAtIndex:0];
    if (section == 0) {
        headerView.name.text = @"应用信息";
    } else {
        headerView.name.text = @"团队";
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
