//
//  PersonalWallViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "PersonalWallViewController.h"
#import "Macro.h"
#import "ReminderCell.h"
#import "PersonalInfoCell.h"
#import "ScheduleCell.h"
#import "FavoriteCell.h"

@interface PersonalWallViewController () <UITableViewDataSource, UITableViewDelegate>
- (void)configureTableView;
@end

@implementation PersonalWallViewController
#pragma mark - Private Method
- (void)configureTableView
{
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ReminderCell" bundle:nil] forCellReuseIdentifier:kReminderCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:kFavoriteCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"PersonalInfoCell" bundle:nil] forCellReuseIdentifier:kPersonalInfoCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellReuseIdentifier:kScheduleCell];
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource 
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 86;
    } 
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:kReminderCell];
        if (cell == nil) {
            cell = [[ReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReminderCell];
        }
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (indexPath.section == 1) {
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoriteCell];
        if (cell == nil) {
            cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFavoriteCell];
        }
        return cell;
    } else if (indexPath.section == 2){
        PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalInfoCell];
        if (cell == nil) {
            cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPersonalInfoCell];
        }
        return cell;
    } else {
        ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCell];
        if (cell == nil) {
            cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kScheduleCell];
        }
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
