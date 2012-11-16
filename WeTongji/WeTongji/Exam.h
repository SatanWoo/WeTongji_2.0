//
//  Exam.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractActivity.h"


@interface Exam : AbstractActivity

@property (nonatomic, retain) NSDate * begin;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * hours;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nO;
@property (nonatomic, retain) NSString * point;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSString * teacher;

@end
