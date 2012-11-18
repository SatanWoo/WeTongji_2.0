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
@property (strong, nonatomic) NSArray * arrangeList;
@property (strong, nonatomic) NSArray * sectionList;
- (void)configureTableView;
@end

@implementation ArrangementViewController
@synthesize arrangementTableView;

-(NSArray *) arrangeList
{
    if ( !_arrangeList )
    {
        NSMutableArray * tempList = [[NSMutableArray alloc] init];
        NSMutableArray * tempSectionList = [[NSMutableArray alloc] init];
        NSDate * date = [NSUserDefaults getCurrentSemesterBeginDate];
        NSArray * tempRowList;
        while ( [date timeIntervalSinceDate:[NSUserDefaults getCurrentSemesterEndDate]] < 0)
        {
            tempRowList = [self getRightCellDataArrayAtdate:date];
            if ( [tempRowList count] )
            {
                [tempSectionList addObject:date];
                [tempList addObject:tempRowList];
            }
            date = [NSDate dateWithTimeInterval:DAY_TIME_INTERVAL sinceDate:date];
        }
        self.sectionList = [NSArray arrayWithArray:tempSectionList];
        _arrangeList = [[NSArray alloc] initWithArray:tempList];
    }
    return _arrangeList;
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
        [self.sectionTableView scrollRectToVisible:CGRectMake(self.arrangementTableView.contentOffset.x, self.arrangementTableView.contentOffset.y,self.arrangementTableView.bounds.size.width, self.arrangementTableView.bounds.size.height)  animated:NO];
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
