//
//  Course+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import "Course.h"

@interface Course (Addition)
+ (NSSet *)insertCourse:(NSDictionary *)dict withSemesterBeginTime:(NSDate *)semesterBeginTime semesterWeekCount:(NSInteger)semesterWeekCount inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Course *)insertExam:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *) getAllCourseInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) clearDataInManagedObjectContext:(NSManagedObjectContext *)context;

@end
