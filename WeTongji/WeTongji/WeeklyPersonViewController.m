//
//  WeeklyPersonViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-15.
//
//

#import "WeeklyPersonViewController.h"
#import "WeeklyPersonHeaderView.h"
#import "Macro.h"
#import "WeeklyPersonCell.h"

@interface WeeklyPersonViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic ,strong) WeeklyPersonHeaderView *headerView;
- (void)configureTableView;
@end

@implementation WeeklyPersonViewController
#pragma mark - Getter & Setter
- (WeeklyPersonHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"WeeklyPersonHeaderView" owner:self options:nil] objectAtIndex:0];
    }
    return _headerView;
}
#pragma mark - Private 
- (void)configureTableView
{
    [self.personTableView registerNib:[UINib nibWithNibName:@"WeeklyPersonCell" bundle:nil] forCellReuseIdentifier:kWeeklyPersonCell];
    self.personTableView.tableHeaderView = self.headerView;
}

#pragma mark - Life Cycle
@synthesize personTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
}

- (void)viewDidUnload
{
    [self setPersonTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeeklyPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeeklyPersonCell];
    if (cell == nil) {
        cell = [[WeeklyPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWeeklyPersonCell];
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kWeeklyPersonViewControllerSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
