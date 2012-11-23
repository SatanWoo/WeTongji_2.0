//
//  SchoolPreferenceViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-23.
//
//

#import "SchoolPreferenceViewController.h"
#import "AboutHeaderView.h"
#define kUserDefaultSelection @"kUserDefaultSelection"

@interface SchoolPreferenceViewController () <UITableViewDataSource, UITableViewDelegate>
- (void)registerUserDefault;
@end

@implementation SchoolPreferenceViewController
- (void)registerUserDefault
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:kUserDefaultSelection]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerUserDefault];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultSelection]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"校务通知";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"社团通告";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"同济动态";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"周边推荐";
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AboutHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AboutHeaderView" owner:self options:nil] objectAtIndex:0];
    headerView.name.text = @"校园资讯偏好";

    return headerView;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UITableViewCell *cell in [tableView visibleCells]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:kUserDefaultSelection];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload {
    [self setPreferenceTableView:nil];
    [super viewDidUnload];
}
@end
