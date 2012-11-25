//
//  SchoolPreferenceViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-23.
//
//

#import "SchoolPreferenceViewController.h"
#import "AboutHeaderView.h"
#import "NSUserDefaults+Settings.h"

#define kUserDefaultSelection @"kUserDefaultSelection"

@interface SchoolPreferenceViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation SchoolPreferenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    if (indexPath.row == [NSUserDefaults getInformationDefaultType]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    switch (indexPath.row) {
        case 0:
            [NSUserDefaults setInformationDefaultType:InformationDefaultTypeSchool];
            break;
        case 1:
            [NSUserDefaults setInformationDefaultType:InformationDefaultTypeClub];
            break;
        case 2:
            [NSUserDefaults setInformationDefaultType:InformationDefaultTypeTongji];
            break;
        case 3:
            [NSUserDefaults setInformationDefaultType:InformationDefaultTypeRecommend];
            break;
        default:
            break;
    }
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload {
    [self setPreferenceTableView:nil];
    [super viewDidUnload];
}
@end
