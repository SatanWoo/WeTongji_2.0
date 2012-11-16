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
    WTClient * client = [WTClient getClient];
    [client setCompletionBlock:^(id responseData)
    {
        NSLog(@"%@",responseData);
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
        [self.view addSubview:self.scheduleWeekViewController.view];
    }];
    [client getCourses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
