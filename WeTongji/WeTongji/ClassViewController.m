//
//  ClassViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-5.
//
//

#import "ClassViewController.h"
#import "NSString+Addition.h"

@interface ClassViewController ()

@end

@implementation ClassViewController
@synthesize course = _course;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScrollView];
    //[self configureContent];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTimeLabel:nil];
    [self setClassroomLabel:nil];
    [self setCourseNumberLabel:nil];
    [self setCreditLabel:nil];
    [self setCourseDurationLabel:nil];
    [self setExamTimeLabel:nil];
    [self setExamClassroomLabel:nil];
    [self setCourseName:nil];
    [self setTeacher:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resetAllContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureContent];
}

- (void)resetAllContent
{
    self.timeLabel.text = nil;
    [self.timeLabel sizeToFit];
    self.classroomLabel.text = nil;
    self.courseNumberLabel.text = nil;
    self.creditLabel.text = nil;
    self.courseDurationLabel.text = nil;
    
    self.courseName.text = nil;
    self.teacher.text = nil;
    
    self.examClassroomLabel.text = nil;
    self.examTimeLabel.text = nil;
}

- (void)configureContent
{
    self.timeLabel.text = [NSString timeConvertFromBeginDate:self.course.begin_time endDate:self.course.end_time];
    [self.timeLabel sizeToFit];
    self.classroomLabel.text = self.course.where;
    self.courseNumberLabel.text = self.course.course_id;
    self.creditLabel.text = [self.course.credit_point stringValue];
    self.courseDurationLabel.text = [self.course.credit_hours stringValue];
    
    self.courseName.text = self.course.what;
    self.teacher.text = self.course.teacher_name;
    
    if (self.exam == nil) {
        self.examClassroomLabel.text = @"无考试";
        self.examTimeLabel.text = @"无考试";
    } else {
        self.examClassroomLabel.text = self.exam.where;
        self.examTimeLabel.text = [NSString timeConvertFromBeginDate:self.exam.begin_time endDate:self.exam.end_time];
    }
}

- (void)configureScrollView
{
    CGRect frame = self.scrollView.frame;
    frame.size.height += 10;
    self.scrollView.contentSize = frame.size;
}

@end
