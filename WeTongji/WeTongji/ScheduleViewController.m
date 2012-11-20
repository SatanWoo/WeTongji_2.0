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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.scheduleWeekViewController.view];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scheduleWeekViewController didClickTodayButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)todayClicked:(id)sender
{
    [self.scheduleWeekViewController didClickTodayButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
