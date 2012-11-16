//
//  AbstractActivity.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AbstractActivity : NSManagedObject

@property (nonatomic, retain) NSDate * begin_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * where;
@property (nonatomic, retain) NSString * what;

@end
