//
//  AbstractActivity.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractCollection.h"


@interface AbstractActivity : AbstractCollection

@property (nonatomic, retain) NSDate * begin_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * what;
@property (nonatomic, retain) NSString * where;

@end
