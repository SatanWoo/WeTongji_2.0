//
//  ScheduleViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-16.
//
//

#import "ScheduleViewController.h"
#import "ScheduleWeekViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+Addition.h"
#import "Course+Addition.h"
#import "Event+Addition.h"
#import "Exam+Addition.h"

@interface ScheduleViewController ()

@property (nonatomic ,strong) ScheduleWeekViewController * scheduleWeekViewController;

@end

@implementation ScheduleViewController
@synthesize scheduleWeekViewController=_scheduleWeekViewController;

-(ScheduleWeekViewController *)scheduleWeekViewController
{
    if ( !_scheduleWeekViewController )
    {
        _scheduleWeekViewController = [[ScheduleWeekViewController alloc] initWithNibName:nil bundle:nil];
        [self addChildViewController:_scheduleWeekViewController];
    }
    return _scheduleWeekViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Course clearDataInManagedObjectContext:self.managedObjectContext];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest  requestWithSuccessBlock:^(id responseData)
    {
        [Course clearDataInManagedObjectContext:self.managedObjectContext];
        NSString *semesterBeginString = [NSString stringWithFormat:@"%@", [responseData objectForKey:@"SchoolYearStartAt"]];
        NSDate *semesterBeginDate = [semesterBeginString convertToDate];
        NSInteger semesterWeekCount = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"SchoolYearWeekCount"]] integerValue];
        NSArray *courses = [responseData objectForKey:@"Courses"];
        NSInteger semesterCourseWeekCount = [[NSString stringWithFormat:@"%@", [responseData objectForKey:@"SchoolYearCourseWeekCount"]] integerValue];
        for(NSDictionary *dict in courses)
        {
            [Course insertCourse:dict withSemesterBeginTime:semesterBeginDate semesterWeekCount:semesterCourseWeekCount inManagedObjectContext:self.managedObjectContext];
        }
        NSDate *semesterEndDate = [semesterBeginDate dateByAddingTimeInterval:60 * 60 * 24 * 7 * semesterWeekCount];
        [NSUserDefaults setCurrentSemesterBeginTime:semesterBeginDate endTime:semesterEndDate];
        [self loadScheduleActivity];
    }failureBlock:^(NSError *error){}];
    [request getCourses];
    [client enqueueRequest:request];
}

- (void)loadScheduleActivity
{
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest  requestWithSuccessBlock:^(id responseData)
    {
        [Event clearAllScheduledEventInManagedObjectContext:self.managedObjectContext];
        [Exam clearDataInManagedObjectContext:self.managedObjectContext];
        NSArray * events = [responseData objectForKey:@"Activities"];
        for ( NSDictionary * dict in events )
        {
            [Event insertActivity:dict inManagedObjectContext:self.managedObjectContext];
        }
        NSArray * exams = [responseData objectForKey:@"Exams"];
        for ( NSDictionary * dict in exams )
        {
            [Exam insertAnExam:dict inManagedObjectContext:self.managedObjectContext];
        }
        [self.view addSubview:self.scheduleWeekViewController.view];
    }failureBlock:^(NSError *error){}];
    [request getScheduleWithBeginDate:[NSUserDefaults getCurrentSemesterBeginDate] endDate:[NSUserDefaults getCurrentSemesterEndDate]];
    [client enqueueRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
