//
//  WeeklyPersonViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-15.
//
//

#import "WeeklyPersonViewController.h"
#import "WeeklyPersonHeaderCell.h"
#import "Macro.h"
#import "WeeklyPersonCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "PullRefreshManagement.h"
#import "Star+Addition.h"

@interface WeeklyPersonViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshManagementDelegate>
@property (nonatomic ,strong) NSArray * starList;
@property (nonatomic ,strong) PullRefreshManagement * pullRefreshManagement;
@property (nonatomic) NSInteger nextPage;
- (void)configureTableView;
@end

@implementation WeeklyPersonViewController
#pragma mark - Getter & Setter

-(NSArray *) starList
{
    if ( !_starList )
    {
        _starList = [Star getAllStarsInManagedObjectContext:self.managedObjectContext];
    }
    return _starList;
}

-(PullRefreshManagement *) pullRefreshManagement
{
    if ( _pullRefreshManagement )
    {
        _pullRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.personTableView];
    }
    return _pullRefreshManagement;
}

#pragma mark - Private
- (void)configureTableView
{
    [self.personTableView registerNib:[UINib nibWithNibName:@"WeeklyPersonCell" bundle:nil] forCellReuseIdentifier:kWeeklyPersonCell];
    [self.personTableView registerNib:[UINib nibWithNibName:@"WeeklyPersonHeaderCell" bundle:nil] forCellReuseIdentifier:kWeeklyPersonHeaderCell];
    self.pullRefreshManagement.delegate = self;
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
    return [self.starList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ( indexPath.row == 0 )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kWeeklyPersonHeaderCell];
        if (cell == nil)
        {
            cell = [[WeeklyPersonHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWeeklyPersonHeaderCell];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kWeeklyPersonCell];
        if (cell == nil)
        {
            cell = [[WeeklyPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWeeklyPersonCell];
        }
    }
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 263;
    return 75;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kWeeklyPersonViewControllerSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -
#pragma - refresh method by tzx

- (void)refresh
{
    self.nextPage = 0;
    [self loadMoreData];
}

- (void)clearData
{
    NSArray * starArray = [Star  getAllStarsInManagedObjectContext:self.managedObjectContext];
    for(Star *star in starArray)
    {
        star.hiden = [NSNumber numberWithBool:YES];
    }
    
}

- (void)endLoading
{
    self.starList = nil;
    [self.personTableView reloadData];
    
}

- (void)loadMoreData
{
    WTClient *client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                               if(self.nextPage == 0)
                                   [self clearData];
                               NSArray *array = [responseData objectForKey:@"People"];
                               for(NSDictionary *dict in array)
                               {
                                   Star *star = [Star insertStarWithDict:dict inManagedObjectContext:self.managedObjectContext];
                                   star.hiden = [NSNumber numberWithBool:NO];
                               }
                               self.nextPage = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"NextPager"]] intValue];
                               if (self.nextPage == 0) [self.pullRefreshManagement setNoMoreData:YES];
                               [self.pullRefreshManagement endLoading];
                           }
                                                failureBlock:^(NSError * error)
                           {
                               [self.pullRefreshManagement endLoading];
                           }];
    [request getAllStarsWithNextPage:self.nextPage];
    [client enqueueRequest:request];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.pullRefreshManagement scrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
    [self.pullRefreshManagement scrollViewDidEndDragging:scrollView willDecelerate:decelerat];
}


@end
