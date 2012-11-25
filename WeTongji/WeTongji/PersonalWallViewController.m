//
//  PersonalWallViewController.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-19.
//
//

#import "PersonalWallViewController.h"
#import "Macro.h"
#import "ReminderCell.h"
#import "PersonalInfoCell.h"
#import "ScheduleCell.h"
#import "FavoriteCell.h"
#import "WUTapImageView.h"
#import "WUScrollBackgroundView.h"
#import "WUPageControlViewController.h"
#import "NSString+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "Course+Addition.h"
#import "Exam+Addition.h"
#import "Event+Addition.h"
#import "AbstractActivity+Addition.h"
#import "AbstractCollection+Addition.h"
#import "NSString+Addition.h"

#define kContentOffSet 156
#define kRowHeight 44
#define kStateY -150

@interface PersonalWallViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    CGPoint originPageControlViewCenter;
    CGPoint originScheduleTableViewCenter;
}
@property (nonatomic, assign) BOOL isAnimationFinished;
@property (weak, nonatomic) IBOutlet UIView *headerBoard;
@property (nonatomic, strong) WUPageControlViewController *pageViewController;
@property (nonatomic,strong)Event * recommandEvent;
@property (weak, nonatomic) IBOutlet UILabel *recommendTitle;
- (void)configureTableView;
@end

@implementation PersonalWallViewController
@synthesize isAnimationFinished = _isAnimationFinished;
@synthesize pageViewController = _pageViewController;
@synthesize recommandEvent = _recommandEvent;

#pragma mark - Private Method

- (void) configureTodayRecommend
{
    self.recommandEvent = nil;
    self.recommendTitle.text = self.recommandEvent.title;
    [self.pageViewController clearPicture];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scaleview.png"]];
    [imageView setImageWithURL:[NSURL URLWithString:self.recommandEvent.imageLink] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [self.pageViewController addPicture:imageView];
}

- (void)configureTableView
{
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ReminderCell" bundle:nil] forCellReuseIdentifier:kReminderCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ReminderNothingCell" bundle:nil] forCellReuseIdentifier:kReminderNothingCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil] forCellReuseIdentifier:kFavoriteCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"PersonalInfoCell" bundle:nil] forCellReuseIdentifier:kPersonalInfoCell];
    [self.scheduleTableView registerNib:[UINib nibWithNibName:@"ScheduleCell" bundle:nil] forCellReuseIdentifier:kScheduleCell];
    [self.view insertSubview:self.pageViewController.view belowSubview:self.headerBoard];
    self.scheduleTableView.contentInset = UIEdgeInsetsMake(kContentOffSet, 0.0f, 0.0f, 0.0f);
    originScheduleTableViewCenter = self.scheduleTableView.center;
    CGPoint center = CGPointMake(self.headerBoard.center.x, (-self.scheduleTableView.contentOffset.y)/2);
    [self.headerBoard setCenter:center];
}

#pragma mark - Tap

-(void)showScheduleTable
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    self.isAnimationFinished = false;
    [UIView animateWithDuration:0.55f animations:^{
        self.scheduleTableView.center = self.view.center;
    } completion:^(BOOL finished) {
        self.scheduleTableView.userInteractionEnabled = YES;
    }];
    
    [UIView animateWithDuration:0.8f animations:^{
        [self.pageViewController.view setCenter:originPageControlViewCenter];
        CGPoint center = CGPointMake(self.headerBoard.center.x, (-self.scheduleTableView.contentOffset.y)/2);
        [self.headerBoard setCenter:center];
    } completion:^(BOOL finished) {
        self.pageViewController.view.userInteractionEnabled = NO;
    }];
}

- (void)didTap:(UITapGestureRecognizer *)recognizer
{
    [self showScheduleTable];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [self showScheduleTable];
}

#pragma mark - Setter & Getter

-(Event *) recommandEvent
{
    if ( !_recommandEvent )
    {
        _recommandEvent = [Event getTodayRecommendEventInManagedObjectContext:self.managedObjectContext];
    }
    return _recommandEvent;
}

- (WUPageControlViewController *)pageViewController
{
    if (_pageViewController == nil) {
        _pageViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:kWUPageControlViewController];
        UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
        [_pageViewController.view addGestureRecognizer:upSwipe];
        
        [_pageViewController.view setFrame:CGRectMake(0, kStateY, _pageViewController.view.bounds.size.width ,_pageViewController.view.bounds.size.height)];
        _pageViewController.view.userInteractionEnabled = NO;
        originPageControlViewCenter = _pageViewController.view.center;
    }
    
    return _pageViewController;
}

#pragma mark - Pangesture

#pragma mark - Lifecycle

- (void)viewDidUnload
{
    [self setHeaderBoard:nil];
    [self setRecommendTitle:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%f",self.parentViewController.view.frame.size.height);
    [self.navigationController setNavigationBarHidden:YES];
    [self configureTodayRecommend];
    [self configureTableView];
    [self loadCourses];
    [self loadMyFavorites];
    [self loadActivities];
    [self setWantsFullScreenLayout:YES];
    
}

-(void)loadCourses
{
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
                               [self.scheduleTableView reloadData];
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
                               [self.scheduleTableView reloadData];
                           }failureBlock:^(NSError *error){}];
    [request getScheduleWithBeginDate:[NSUserDefaults getCurrentSemesterBeginDate] endDate:[NSUserDefaults getCurrentSemesterEndDate]];
    [client enqueueRequest:request];
}


-(void) loadMyFavorites
{
    WTClient *client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                               NSArray *array = [responseData objectForKey:@"Activities"];
                               for(NSDictionary *eventDict in array)
                               {
                                   Event *event = [Event insertActivity:eventDict inManagedObjectContext:self.managedObjectContext];
                                   event.hidden = [NSNumber numberWithBool:NO];
                               }
                               [self.scheduleTableView reloadData];
                           }
                            failureBlock:^(NSError * error)
                           {
                           }];
    [request getFavoritesWithNextPage:0];
    [client enqueueRequest:request];
}

-(void) loadActivities
{
    WTClient *client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData)
                           {
                               NSArray *array = [responseData objectForKey:@"Activities"];
                               for(NSDictionary *eventDict in array)
                               {
                                   Event *event = [Event insertActivity:eventDict inManagedObjectContext:self.managedObjectContext];
                                   event.hidden = [NSNumber numberWithBool:NO];
                               }
                               [self configureTodayRecommend];
                           }
                            failureBlock:^(NSError * error)
                           {
                           }];
    [request getActivitiesInChannel:nil inSort:GetActivitySortMethodBeginDesc Expired:NO nextPage:0];
    [client enqueueRequest:request];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"%f",self.pageViewController.view.frame.size.height);
    [UIView animateWithDuration:0.8f animations:^{
        self.pageViewController.view.center = originPageControlViewCenter;} completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 86;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString * identifier;
        AbstractActivity * thing = [AbstractActivity getTodayNextScheduleInManagedObjectContext:self.managedObjectContext];
        if ( thing )
            identifier = kReminderCell;
        else
            identifier = kReminderNothingCell;
        ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if ( thing )
        {
            cell.eventNameLabel.text = thing.what;
            cell.locationLabel.text = thing.where;
            cell.timeLabel.text = [NSString timeConvertFromBeginDate:thing.begin_time endDate:thing.end_time];
        }
        return cell;
    } else if (indexPath.section == 1) {
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:kFavoriteCell];
        if (cell == nil) {
            cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFavoriteCell];
        }
        [cell setTableList:[AbstractCollection allCollectionInManagedObjectContext:self.managedObjectContext]];
        [cell rotate];
        return cell;
    } else if (indexPath.section == 2){
        PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalInfoCell];
        if (cell == nil) {
            cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPersonalInfoCell];
        }
        return cell;
    } else {
        ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleCell];
        if (cell == nil) {
            cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kScheduleCell];
        }
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:kArrangementViewControllerSegue sender:self];
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:kMyFavortieViewControllerSegue sender:self];
    } else if (indexPath.section == 2) {
        [self performSegueWithIdentifier:kEditInfoViewController sender:self];
    } else if (indexPath.section == 3) {
        [self performSegueWithIdentifier:kSchedueViewController sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static int velocity = 15;
    
    float rate = (scrollView.contentOffset.y + kContentOffSet) / -kRowHeight;
    
    if (rate > 2)
    {
        self.isAnimationFinished = true;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:0.25f animations:^{
            self.scheduleTableView.frame = CGRectMake(0, self.view.frame.size.height, self.scheduleTableView.frame.size.width, self.scheduleTableView.frame.size.height);
            CGPoint center = self.view.center;
            self.pageViewController.view.center = center;
            center = CGPointMake(self.headerBoard.center.x, (self.pageViewController.view.frame.size.height)/2);
            [self.headerBoard setCenter:center];
        } completion:^(BOOL finished) {
            self.pageViewController.view.userInteractionEnabled = YES;
        }];
    } else
        if (self.isAnimationFinished == false)
        {
            CGPoint center = self.pageViewController.view.center;
            center.y = kStateY + velocity * rate + self.pageViewController.view.frame.size.height/2;
            self.pageViewController.view.center = center;            center = CGPointMake(self.headerBoard.center.x, (-scrollView.contentOffset.y)/2);
            [self.headerBoard setCenter:center];
        }
}

@end
