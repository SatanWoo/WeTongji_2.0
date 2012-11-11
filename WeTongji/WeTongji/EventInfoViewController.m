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
#import "Event+Addition.h"
#import "PullRefreshManagement.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface EventInfoViewController () <UITableViewDataSource, UITableViewDelegate,PullRefreshManagementDelegate>

@property (nonatomic,strong) NSArray * eventList;
@property (nonatomic,strong) PullRefreshManagement * pullRefreshManagement;
@property (assign) int nextPage;

- (void)configureTableView;
@end

@implementation EventInfoViewController

@synthesize nextPage;
@synthesize eventList = _eventList;
@synthesize pullRefreshManagement = _pullRefreshManagement;

-(PullRefreshManagement *) pullRefreshManagement
{
    if ( !_pullRefreshManagement )
    {
        _pullRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.eventTableView];
    }
    return _pullRefreshManagement;
}

-(NSArray *) eventList
{
    if ( !_eventList )
    {
        NSArray * tempList = [[Event allEventsInManagedObjectContext:self.managedObjectContext] mutableCopy];
        NSMutableArray * __eventList = [[NSMutableArray alloc] init];
        for ( Event * event in tempList )
            if ( ![event.hidden boolValue] )
                [__eventList addObject:event];
        _eventList = [NSArray arrayWithArray: __eventList];
    }
    return _eventList;
}

#pragma mark - Private 
- (void)configureTableView
{
    [self.eventTableView registerNib:[UINib nibWithNibName:@"EventInfoCell" bundle:nil] forCellReuseIdentifier:kEventInfoCell];
    self.pullRefreshManagement.delegate = self;
}

#pragma mark - LifeCycle
@synthesize eventTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [Event clearAllEventInManagedObjectContext:self.managedObjectContext];
}

- (void)viewDidUnload
{

    [self setEventTableView:nil];
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
- (IBAction)filterEvent
{
    [UIView animateWithDuration:0.3f animations:^{
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

- (void)endLoading
{
    self.eventList = nil;
    [self.eventTableView reloadData];

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
            self.nextPage = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"NextPager"]] intValue];
            NSLog(@"%d",self.nextPage);
            if (self.nextPage == 0) [self.pullRefreshManagement setNoMoreData:YES];
        }
        [self.pullRefreshManagement endLoading];
    }];
    [client getActivitiesInChannel:nil inSort:SortTypeFavoriteDesc Expired:YES nextPage:self.nextPage];
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
