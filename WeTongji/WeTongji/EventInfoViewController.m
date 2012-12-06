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
#import "FilterViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "SchoolNewsViewController.h"

@interface EventInfoViewController () <UITableViewDataSource, UITableViewDelegate,PullRefreshManagementDelegate,FilterViewControllerDelegate>

@property (nonatomic,strong) NSArray * eventList;
@property (nonatomic,strong) PullRefreshManagement * pullRefreshManagement;
@property (assign) int nextPage;
@property (strong,nonatomic) FilterViewController * filterViewController;
@property (nonatomic,strong) NSDictionary * filterDict;
@property (nonatomic,strong) NSString * filterString;
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;

- (void)configureTableView;
- (void)configureNotification;
@end

@implementation EventInfoViewController

@synthesize nextPage;
@synthesize eventList = _eventList;
@synthesize pullRefreshManagement = _pullRefreshManagement;
@synthesize filterViewController = _filterViewController;
@synthesize filterDict = _filterDict;
@synthesize filterString = _filterString;

-(void) setFilterString:(NSString *)filterString
{
    if ( ![_filterString isEqualToString: filterString] )
        {
            _filterString = filterString;
            [self.pullRefreshManagement firstTrigger];
        }
}

-(NSString *)filterString
{
    if ( !_filterString )
    {
        
    }
    return _filterString;
}


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
        NSArray *sortedNames = [__eventList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Event *str1 = (Event *)obj1;
            Event *str2 = (Event *)obj2;
            if ( [self.filterString isEqualToString:@""] )
                return [str1.beginTime compare:str2.beginTime];
            if ( [self.filterString isEqualToString:GetActivitySortMethodLikeDesc] )
                return [str2.like compare:str1.like];
            if ( [self.filterString isEqualToString:GetActivitySortMethodCreateDesc] )
                return [str2.createAt compare: str1.createAt];
            return YES;
        }];
        _eventList = [NSArray arrayWithArray: sortedNames];
    }
    return _eventList;
}

-(NSDictionary *) filterDict
{
    if ( !_filterDict )
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:GetActivitySortMethodCreateDesc forKey:@"最新活动"];
        [dict setObject:GetActivitySortMethodLikeDesc forKey:@"最火活动"];
        [dict setObject:@"" forKey:@"最近活动"];
        _filterDict = [[NSDictionary alloc] initWithDictionary:dict];
    }
    return _filterDict;
}

-(FilterViewController *) filterViewController
{
    if ( !_filterViewController )
    {
        _filterViewController = [[FilterViewController alloc] initWithFilterList:[self.filterDict allKeys] forContentView:self.navigationController.view];
        [[self.navigationController.view superview] insertSubview:_filterViewController.view belowSubview:self.navigationController.view];
        _filterViewController.delegate = self;
        [_filterViewController.view setHidden:YES];
    }
    return _filterViewController;
}

-(void) setfilterViewController:(FilterViewController *)filterViewController
{
    if ( filterViewController == nil )
    {
        [filterViewController.view removeFromSuperview];
    }
    _filterViewController = filterViewController;
}

#pragma mark - Private
- (void)configureTableView
{
    [self.eventTableView registerNib:[UINib nibWithNibName:@"EventInfoCell" bundle:nil] forCellReuseIdentifier:kEventInfoCell];
   // self.eventTableView.backgroundColor = [UIColor lightGrayColor];
    self.pullRefreshManagement.delegate = self;
}

- (void)scrollToTop:(NSNotification *)notification
{
    NSLog(@"Did scroll");
    [self.eventTableView setContentOffset:CGPointZero animated:YES];
}

- (void)configureNotification
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTop:) name:kScrollToTopNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kScrollToTopNotification];
}

#pragma mark - LifeCycle
@synthesize eventTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureNotification];
    [self.filterViewController selectRow:1];
}

- (void)viewDidUnload
{
    [self removeNotification];
    [self setEventTableView:nil];
    [self setTitleLabel:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.eventTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction 
- (IBAction)filterEvent
{
    [self.filterViewController showFilterView];
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
    for (UIView *sub in cell.disableView.subviews) {
        sub.userInteractionEnabled = NO;
    }
    cell.favorButton.userInteractionEnabled = YES;
    cell.likeButton.userInteractionEnabled = YES;
    [cell setEvent:[self.eventList objectAtIndex:indexPath.row]];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

#pragma mark - UITableViewDelegate

static NSInteger tempRow;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SchoolNewsViewController *viewController = segue.destinationViewController;
    [viewController setEvent:self.eventList[tempRow]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tempRow = indexPath.row;
    [self performSegueWithIdentifier:kEventInfoViewControllerSegue sender:self];
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
    self.eventList = nil;
    [self.eventTableView reloadData];

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
            [self.filterViewController reloadTableView];
        }
        failureBlock:^(NSError * error)
        {
            [self.pullRefreshManagement endLoading];
        }];
    if ( [self.filterString isEqualToString:@""] ) {
        [request getActivitiesInChannel:nil inSort:nil Expired:NO nextPage:self.nextPage];
    } else if ( [self.filterString isEqualToString:GetActivitySortMethodCreateDesc] ){
        [request getActivitiesInChannel:nil inSort:self.filterString Expired:YES nextPage:self.nextPage];
    } else if ( [self.filterString isEqualToString:GetActivitySortMethodLikeDesc] ){
        [request getActivitiesInChannel:nil inSort:self.filterString Expired:NO nextPage:self.nextPage];
    }
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

#pragma mark -
#pragma mark FilterViewControllerDelegate Methods

-(void) filterViewSelectedRow:(NSInteger)row
{
    self.titleLabel.titleLabel.text = [[self.filterDict allKeys] objectAtIndex:row];
    [self setFilterString:[self.filterDict objectForKey:[[self.filterDict allKeys] objectAtIndex:row]]];
    self.title = [[self.filterDict allKeys] objectAtIndex:row];
    [self.filterViewController hideFilterView];
}


@end
