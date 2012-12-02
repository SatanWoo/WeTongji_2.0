//
//  MyFavortieViewController.m
//  WeTongji
//
//  Created by Ziqi on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyFavortieViewController.h"
#import "Macro.h"
#import "EventInfoCell.h"
#import "SchoolNewsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PullRefreshManagement.h"
#import "WUFolderView.h"
#import "SchoolNewsViewController.h"
#import "WeeklyPersonCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "Star+Addition.h"
#import "Information+Addition.h"
#import "Event+Addition.h"
#import "AbstractCollection+Addition.h"
#import "MyFavoriteCell.h"
#import "MyFavoriteInfoCell.h"
#import "MyFavoriteEventCell.h"
#import "MyFavoriteStarCell.h"

@interface MyFavortieViewController () < UITableViewDelegate, UITableViewDataSource ,PullRefreshManagementDelegate>

@property (nonatomic, strong) PullRefreshManagement * pullRefreshManagement;
@property (nonatomic, strong) NSArray *myFavoriteList;
@property (nonatomic) NSInteger nextPage;

@end

@implementation MyFavortieViewController

#pragma mark - Getter & Setter

- (PullRefreshManagement *) pullRefreshManagement
{
    if ( !_pullRefreshManagement )
    {
        _pullRefreshManagement = [[PullRefreshManagement alloc] initWithScrollView:self.contentTableView];
    }
    return _pullRefreshManagement;
}

-(NSArray *) myFavoriteList
{
    if ( !_myFavoriteList )
    {
        _myFavoriteList = [AbstractCollection allCollectionInManagedObjectContext:self.managedObjectContext];
    }
    return _myFavoriteList;
}

#pragma mark - Private Methods

-(void) configTableView
{
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MyFavoriteEventCell" bundle:nil] forCellReuseIdentifier:kMyFavoriteEventCell];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MyFavoriteInfoCell" bundle:nil] forCellReuseIdentifier:kMyFavoriteInfoCell];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"MyFavoriteStarCell" bundle:nil] forCellReuseIdentifier:kMyFavoriteStarCell];
    self.pullRefreshManagement.delegate = self;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configTableView];
    [self.pullRefreshManagement firstTrigger];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

static NSInteger tempRow;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SchoolNewsViewController *viewController = segue.destinationViewController;
    id collection = self.myFavoriteList[tempRow];
    if ( [collection isKindOfClass:[Star class]] )
    {
        [viewController setStar:self.myFavoriteList[tempRow]];
    }
    else if ( [collection isKindOfClass:[Information class]] )
    {
        [viewController setInformation:self.myFavoriteList[tempRow]];
    }
    else if ( [ collection isKindOfClass:[Event class]] )
    {
        [viewController setEvent:self.myFavoriteList[tempRow]];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tempRow = indexPath.row;
    [self performSegueWithIdentifier:kMyFavoriteNewsViewControllerSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myFavoriteList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AbstractCollection * collection = self.myFavoriteList[indexPath.row];
    MyFavoriteCell *cell;
    if ( [collection isKindOfClass:[Event class]] ) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMyFavoriteEventCell];
        if (cell == nil) {
            cell = [[MyFavoriteEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyFavoriteEventCell];
        }
    } else if ( [collection isKindOfClass:[Information class]] ) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMyFavoriteInfoCell];
        if (cell == nil) {
            cell = [[MyFavoriteInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyFavoriteInfoCell];
        }
    } else if ( [collection isKindOfClass:[Star class]] ) {
        cell = [tableView dequeueReusableCellWithIdentifier:kMyFavoriteStarCell];
        if (cell == nil) {
            cell = [[MyFavoriteStarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyFavoriteStarCell];
        }
    }
    [cell setCollection:collection];
    return cell;
}

#pragma -
#pragma - refresh method by tzx

- (void)refresh
{
    self.nextPage = 1;
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
    self.myFavoriteList = nil;
    [self.contentTableView reloadData];
    
}

- (void)loadMoreData
{
    WTClient *client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                               if(self.nextPage == 1)
                                   [self clearData];
                               NSArray *array = [responseData objectForKey:@"Activities"];
                               for(NSDictionary *eventDict in array)
                               {
                                   Event *event = [Event insertActivity:eventDict inManagedObjectContext:self.managedObjectContext];
                                   event.hidden = [NSNumber numberWithBool:NO];
                               }
                               self.nextPage = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"NextPager"]] intValue];
                               if (self.nextPage == 0) [self.pullRefreshManagement setNoMoreData:YES];
                               [self.pullRefreshManagement endLoading];
                           }
                            failureBlock:^(NSError * error)
                           {
                               [self.pullRefreshManagement endLoading];
                           }];
    [request getFavoritesWithNextPage:self.nextPage];
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
