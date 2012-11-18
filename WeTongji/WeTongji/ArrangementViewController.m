//
//  ArrangementViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-5.
//
//

#import "ArrangementViewController.h"
#import "ArrangementCell.h"
#import "Macro.h"
#import "WUArrangementSectionHeaderView.h"
#import <CoreData/CoreData.h>
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+Addition.h"
#import "AbstractActivity.h"

#define DAY_TIME_INTERVAL (60 * 60 * 24)

@interface ArrangementViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sectionTableView;
@property (strong, nonatomic) NSMutableArray * arrangeList;
@property (strong, nonatomic) NSMutableArray * sectionList;
@property (strong, nonatomic) NSDate * beginDate;
@property (strong, nonatomic) NSDate * endDate;
- (void)configureTableView;
@end

@implementation ArrangementViewController
@synthesize arrangementTableView;
@synthesize endDate=_endDate;
@synthesize beginDate=_beginDate;

-(NSMutableArray *) arrangeList
{
    if ( !_arrangeList )
    {
        _arrangeList = [[NSMutableArray alloc] init];
    }
    return _arrangeList;
}

-(NSMutableArray *) sectionList
{
    
    if ( !_sectionList )
    {
        _sectionList = [[NSMutableArray alloc] init];
    }
    return _sectionList;
}

-(NSDate *) endDate
{
    if ( !_endDate )
    {
        _endDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger interval = [_endDate timeIntervalSince1970] / DAY_TIME_INTERVAL;
        interval = interval * DAY_TIME_INTERVAL;
        _endDate = [NSDate dateWithTimeIntervalSince1970:interval];
    }
    return _endDate;
}

-(NSDate *) beginDate
{
    if ( !_beginDate )
    {
        _beginDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger interval = [_beginDate timeIntervalSince1970] / DAY_TIME_INTERVAL;
        interval = interval * DAY_TIME_INTERVAL;
        _beginDate = [NSDate dateWithTimeIntervalSince1970:interval];
    }
    return _beginDate;
}

-(void) loadMoreFutureData
{
    NSArray * tempRowList;
    NSInteger tempCount = 0;
    while ( [self.endDate timeIntervalSinceDate:[NSUserDefaults getCurrentSemesterEndDate]] < 0)
    {
        tempRowList = [self getRightCellDataArrayAtdate:self.endDate];
        tempCount += tempRowList.count;
        if ( [tempRowList count] )
        {
            [self.sectionList addObject:self.endDate];
            [self.arrangeList addObject:tempRowList];
        }
        self.endDate = [NSDate dateWithTimeInterval:DAY_TIME_INTERVAL sinceDate:self.endDate];
        if ( tempCount > 10 )
            break;
    }
    [self.sectionTableView reloadData];
    [self.arrangementTableView reloadData];
}

-(void) loadMorePastData
{
    NSArray * tempRowList;
    NSInteger tempCount = 0;
    CGPoint tempOffset = self.arrangementTableView.contentOffset;
    CGSize tempSize = self.arrangementTableView.contentSize;
    while ( [self.beginDate timeIntervalSinceDate:[NSUserDefaults getCurrentSemesterBeginDate]] > 0)
    {
        tempRowList = [self getRightCellDataArrayAtdate:self.beginDate];
        tempCount += tempRowList.count;
        if ( [tempRowList count] )
        {
            [self.sectionList insertObject:self.beginDate atIndex:0];
            [self.arrangeList insertObject:tempRowList atIndex:0];
        }
        self.beginDate = [NSDate dateWithTimeInterval:-DAY_TIME_INTERVAL sinceDate:self.beginDate];
        if ( tempCount > 10 )
            break;
    }
    [self.sectionTableView reloadData];
    [self.arrangementTableView reloadData];
    tempOffset.y += self.arrangementTableView.contentSize.height - tempSize.height;
    [self.sectionTableView setContentOffset:tempOffset];
    [self.arrangementTableView setContentOffset:tempOffset];
}

-(void) setBeginDate:(NSDate *)beginDate
{
    if ( [beginDate timeIntervalSinceDate:[NSUserDefaults getCurrentSemesterBeginDate]] < 0 )
    {
        _beginDate = [NSUserDefaults getCurrentSemesterBeginDate];
        return;
    }
    _beginDate = beginDate;
}

-(void) setEndDate:(NSDate *)endDate
{
    if ( [endDate timeIntervalSinceDate:[NSUserDefaults getCurrentSemesterEndDate]] > 0 )
    {
        _endDate = [NSUserDefaults getCurrentSemesterEndDate];
        return;
    }
    _endDate = endDate;
}

#pragma mark - Private Method
- (void)configureTableView
{
    [self.arrangementTableView registerNib:[UINib nibWithNibName:@"ArrangementCell" bundle:nil] forCellReuseIdentifier:kArrangementCell];
    self.arrangementTableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self loadMoreFutureData];
    [self loadMorePastData];
}

- (void)viewDidUnload
{
    [self setArrangementTableView:nil];
    [self setSectionTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrangeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.sectionTableView ) return [self.arrangeList[section] count]-1;
    return [self.arrangeList[section] count];
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( tableView == self.sectionTableView ) return 80;
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WUArrangementSectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"WUArrangementSectionHeaderView" owner:self options:nil] objectAtIndex:0];
    [headerView setDate:self.sectionList[section]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ( tableView == self.sectionTableView )
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"transparentTableCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transparentTableCell"];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kArrangementCell];
        if (cell == nil) {
            cell = [[ArrangementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kArrangementCell];}
        AbstractActivity * activity = self.arrangeList[indexPath.section][indexPath.row];
        ((ArrangementCell *)cell).timeLabel.text = [NSString timeConvertFromBeginDate:activity.begin_time endDate:activity.end_time];
        ((ArrangementCell *)cell).titleLabel.text = activity.what;
        ((ArrangementCell *)cell).locationLabel.text = activity.where;
    }
    return cell;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( scrollView == self.arrangementTableView )
    {
        self.sectionTableView.contentOffset = self.arrangementTableView.contentOffset;
        NSLog(@"%f : %f",self.arrangementTableView.contentOffset.y,self.arrangementTableView.contentSize.height);
        if ( self.arrangementTableView.contentOffset.y < 0 )
        {
            [self loadMorePastData];
        }
        else if (self.arrangementTableView.contentOffset.y + 600 > self.arrangementTableView.contentSize.height)
        {
            [self loadMoreFutureData];
        }
    }
}

- (NSArray *)getRightCellDataArrayAtdate:(NSDate *) date{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext]];
    NSDate *semesterBegin = [NSUserDefaults getCurrentSemesterBeginDate];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:semesterBegin];
    NSPredicate *beginPredicate = [NSPredicate predicateWithFormat:@"begin_time >= %@", [semesterBegin dateByAddingTimeInterval:timeInterval]];
    NSPredicate *endPredicate = [NSPredicate predicateWithFormat:@"begin_time < %@", [semesterBegin dateByAddingTimeInterval:timeInterval + DAY_TIME_INTERVAL]];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, endPredicate, nil]]];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
    NSFetchRequest *requestEvent = [[NSFetchRequest alloc] init];
    [requestEvent setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate * schedule = [NSPredicate predicateWithFormat:@"canSchedule == %@",[NSNumber numberWithBool:NO]];
    [requestEvent setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, endPredicate,schedule,nil]]];
    NSArray *resultEvent = [self.managedObjectContext executeFetchRequest:requestEvent error:NULL];
    
    NSFetchRequest *requestExam = [[NSFetchRequest alloc] init];
    [requestExam setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:self.managedObjectContext]];
    [requestExam setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, endPredicate,nil]]];
    NSArray *resultExam = [self.managedObjectContext executeFetchRequest:requestExam error:NULL];
    
    return [[result arrayByAddingObjectsFromArray:resultEvent] arrayByAddingObjectsFromArray:resultExam];
}

@end
