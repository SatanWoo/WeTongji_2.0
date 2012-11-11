//
//  Course.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * begin_section;
@property (nonatomic, retain) NSString * course_id;
@property (nonatomic, retain) NSNumber * credit_hours;
@property (nonatomic, retain) NSNumber * credit_point;
@property (nonatomic, retain) NSNumber * end_section;
@property (nonatomic, retain) NSString * require_type;
@property (nonatomic, retain) NSString * teacher_name;
@property (nonatomic, retain) NSNumber * week_day;
@property (nonatomic, retain) NSString * week_type;
@property (nonatomic, retain) NSString * begin_day;
@property (nonatomic, retain) NSDate * begin_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * what;
@property (nonatomic, retain) NSString * where;

@end
