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
#import "AbstractActivity+Addition.h"
#import "Event+Addition.h"
#import "Exam+Addition.h"
#import "Course+Addition.h"

#define DAY_TIME_INTERVAL (60 * 60 * 24)
#define kXPos 278
#define kYPos 55

@interface ArrangementViewController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _didReachSemesterBegin;
    BOOL _didReachSemeserEnd;
}
@property (weak, nonatomic) IBOutlet UITableView *sectionTableView;
@property (strong, nonatomic) NSMutableArray * arrangeList;
@property (strong, nonatomic) NSMutableArray * sectionList;
@property (strong, nonatomic) NSDate * beginDate;
@property (strong, nonatomic) NSDate * endDate;
@property (strong, nonatomic) NSIndexPath * todayIndexPath;
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
        self.beginDate = nil;
        _arrangeList = [[NSMutableArray alloc] init];
        NSArray * tempList = [self getCellsData];
        if ( ![tempList count] ) return _arrangeList;
        NSInteger index = 0;
        NSDate * now = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
        while ( [self.endDate compare:[NSUserDefaults getCurrentSemesterEndDate]] <= 0 )
        {
            AbstractActivity * thing = tempList[index];
            if ( [self.beginDate compare:thing.begin_time] > 0 )
            {
                if ( index < [tempList count] - 1 )
                    index++;
                else break;
            }
            else
            if ( [self.endDate compare:thing.begin_time] <= 0 )
            {
                if ( [now timeIntervalSinceDate:self.beginDate] >= 0 &&
                    [now timeIntervalSinceDate:self.endDate] < 0 )
                {
                    NSLog(@"%@",now);
                    self.todayIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self.sectionList count]];
                    [_arrangeList addObject:[[NSArray alloc] initWithObjects:[AbstractActivity emptyActivityInManagedObjectContext:self.managedObjectContext], nil]];
                    [self.sectionList addObject:self.beginDate];
                }
                self.beginDate = [self.beginDate dateByAddingTimeInterval:DAY_TIME_INTERVAL];
            }
            else
            {
                NSMutableArray * rowList = [[NSMutableArray alloc] init];
                while ( [thing.begin_time compare:self.endDate] < 0 )
                {
                    [rowList addObject:thing];
                    if ( index < [tempList count] - 1 )
                        index++;
                    else break;
                    thing = tempList[index];
                }
                if ( [rowList count] )
                {
                    [_arrangeList addObject:rowList];
                    [self.sectionList addObject:self.beginDate];
                    if ( [now timeIntervalSinceDate:self.beginDate] >= 0 &&
                        [now timeIntervalSinceDate:self.beginDate] < DAY_TIME_INTERVAL )
                    {
                        self.todayIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self.sectionList count]-1];
                    }
                }
                self.beginDate = [self.beginDate dateByAddingTimeInterval:DAY_TIME_INTERVAL];
            }
        }
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
    _endDate = [NSDate dateWithTimeInterval:DAY_TIME_INTERVAL sinceDate:self.beginDate];
    return _endDate;
}

-(NSDate *) beginDate
{
    if ( !_beginDate )
    {
        _beginDate = [NSUserDefaults getCurrentSemesterBeginDate];
        NSInteger interval = [_beginDate timeIntervalSince1970] / DAY_TIME_INTERVAL;
        _beginDate = [NSDate dateWithTimeIntervalSince1970:(interval * DAY_TIME_INTERVAL)];
        NSLog(@"%@",_beginDate);
    }
    return _beginDate;
}

#pragma mark - Private Method
- (void)configureTableView
{
    [self.arrangementTableView registerNib:[UINib nibWithNibName:@"ArrangementCell" bundle:nil] forCellReuseIdentifier:kArrangementCell];
    [self.arrangementTableView registerNib:[UINib nibWithNibName:@"ArrangementNothingCell" bundle:nil] forCellReuseIdentifier:kArrangementNothingCell];
    self.arrangementTableView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.arrangementTableView scrollToRowAtIndexPath:self.todayIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
        id activity = self.arrangeList[indexPath.section][indexPath.row];
        NSString * identifier;
        if ( [activity isKindOfClass:[Event class]] ||
             [activity isKindOfClass:[Exam class]] ||
            [activity isKindOfClass:[Course class]])
        {
            identifier = kArrangementCell;
        }
        else
            identifier = kArrangementNothingCell;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ArrangementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];}
        if ( [identifier isEqualToString:kArrangementCell] )
        {
            AbstractActivity * activity = self.arrangeList[indexPath.section][indexPath.row];
            ((ArrangementCell *)cell).timeLabel.text = [NSString timeConvertFromBeginDate:activity.begin_time endDate:activity.end_time];
            ((ArrangementCell *)cell).titleLabel.text = activity.what;
            ((ArrangementCell *)cell).locationLabel.text = activity.where;
            
            [((ArrangementCell *)cell).locationLabel sizeToFit];
            CGRect oldFrame = ((ArrangementCell *)cell).locationLabel.frame;
            oldFrame.origin.x = kXPos - oldFrame.size.width;
            oldFrame.origin.y = kYPos;
            ((ArrangementCell *)cell).locationLabel.frame = oldFrame;
            CGRect iconFrame = ((ArrangementCell *)cell).locationIcon.frame;
            iconFrame.origin.x = oldFrame.origin.x - 3 - ((ArrangementCell *)cell).locationIcon.frame.size.width;
            ((ArrangementCell *)cell).locationIcon.frame = iconFrame;
            
            if ( [activity isKindOfClass:[Event class]] )
            {
                [((ArrangementCell *)cell).colorBall setImage:[UIImage imageNamed:@"dot_yellow"]];
            }
            else if ( [activity isKindOfClass:[Course class]] )
            {
                if ( [((Course *)activity).require_type isEqualToString:@"必修"] )
                    [((ArrangementCell *)cell).colorBall setImage:[UIImage imageNamed:@"dot_blue"]];
                else
                    [((ArrangementCell *)cell).colorBall setImage:[UIImage imageNamed:@"dot_green"]];
            }
            else if ( [activity isKindOfClass:[Exam class]] )
            {
                [((ArrangementCell *)cell).colorBall setImage:[UIImage imageNamed:@"dot_red"]];
            }
        }
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
    }
}

- (NSArray *)getCellsData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AbstractActivity" inManagedObjectContext:self.managedObjectContext]];
    NSDate *semesterBegin = [NSUserDefaults getCurrentSemesterBeginDate];
    NSDate *semesterEnd = [NSUserDefaults getCurrentSemesterEndDate];
    NSPredicate *beginPredicate = [NSPredicate predicateWithFormat:@"begin_time >= %@", semesterBegin];
    NSPredicate *endPredicate = [NSPredicate predicateWithFormat:@"begin_time < %@", semesterEnd];
    NSPredicate * schedule = [NSPredicate predicateWithFormat:@"canSchedule == %@",[NSNumber numberWithBool:NO]];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, endPredicate, schedule, nil]]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"begin_time" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:sort, nil];
    [request setSortDescriptors:descriptors];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:NULL];
    
    return result;
}

- (IBAction)todayClicked
{
    [self.arrangementTableView scrollToRowAtIndexPath:self.todayIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
