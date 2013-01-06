//
//  ClassViewController.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-5.
//
//

#import <UIKit/UIKit.h>
#import "MiddleAbstractSecondViewController.h"
#import "Course+Addition.h"
#import "Exam+Addition.h"

@interface ClassViewController : MiddleAbstractSecondViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classroomLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *examTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *examClassroomLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *teacher;

@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) Exam *exam;

@end
