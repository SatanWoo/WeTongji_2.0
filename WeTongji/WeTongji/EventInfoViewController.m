//
//  EventInfoViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EventInfoViewController.h"
#import "Macro.h"
#import "EventInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WUPopOverView.h"
#import "Event+Addition.h"
#import "EGORefreshTableHeaderView.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface EventInfoViewController () <UITableViewDataSource, UITableViewDelegate, WUPopOverViewDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,strong) NSMutableArray * eventList;
@property (nonatomic,strong) EGORefreshTableHeaderView * pullRefreshHeaderView;
@property (assign) int nextPage;

- (void)configureTableView;
@end

@implementation EventInfoViewController

@synthesize nextPage;
@synthesize eventList = _eventList;
@synthesize pullRefreshHeaderView = _pullRefreshHeaderView;

-(EGORefreshTableHeaderView *) pullRefreshHeaderView
{
    if ( !_pullRefreshHeaderView )
    {
        _pullRefreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
        [_pullRefreshHeaderView refreshLastUpdatedDate];
        _pullRefreshHeaderView.delegate = self;
    }
    return _pullRefreshHeaderView;
}

-(NSMutableArray *) eventList
{
    if ( !_eventList )
        _eventList = [[Event allEventsInManagedObjectContext:self.managedObjectContext] mutableCopy];
    return _eventList;
}

#pragma mark - Private 
- (void)configureTableView
{
    [self.eventTableView registerNib:[UINib nibWithNibName:@"EventInfoCell" bundle:nil] forCellReuseIdentifier:kEventInfoCell];
    //[self.eventTableView setTableHeaderView:self.pullRefreshHeaderView];
    [self.eventTableView addSubview:self.pullRefreshHeaderView];
}

#pragma mark - LifeCycle
@synthesize filterButton;
@synthesize eventTableView;
@synthesize filterView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    self.filterView.layer.opacity = 0;
}

- (void)viewDidUnload
{
    [self setFilterButton:nil];
    [self setEventTableView:nil];
    [self setFilterView:nil];
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction 
- (IBAction)filterEvent:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.filterView.layer.opacity = 1 - self.filterView.layer.opacity;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventInfoCell];
    if (cell == nil)
    {
        cell = [[EventInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventInfoCell];

    }
    [cell setEvent:[self.eventList objectAtIndex:indexPath.row]];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - WUPopOverViewDelegate
- (void)selectItemInPopOverViewAtIndex:(UIButton *)index
{
    
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
    NSArray *eventArray = [Event allEventsInManagedObjectContext:self.managedObjectContext];
    for(Event *event in eventArray)
    {
        event.hidden = [NSNumber numberWithBool:YES];
    }
    
}

- (void)loadMoreData
{
    WTClient *client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData)
    {
        NSString * hasError = [responseData objectForKey:@"isFailed"];
        if( [hasError characterAtIndex:0] == 'N' )
        {
            if(self.nextPage == 0)
                [self clearData];
            NSArray *array = [responseData objectForKey:@"Activities"];
            for(NSDictionary *eventDict in array)
            {
                Event *event = [Event insertActivity:eventDict inManagedObjectContext:self.managedObjectContext]; 
                event.hidden = [NSNumber numberWithBool:NO];
            }
            self.eventList = nil;
            [self.eventTableView reloadData];
            self.nextPage = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"NextPager"]] intValue];
        }
        [self doneLoadingTableViewData];
    }];
    [client getActivitiesInChannel:nil inSort:SortTypeScheduleDesc Expired:NO nextPage:self.nextPage];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData
{
	_reloading = NO;
    [self.pullRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.eventTableView];	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_pullRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
	[_pullRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma -
#pragma - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadMoreData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

@end
