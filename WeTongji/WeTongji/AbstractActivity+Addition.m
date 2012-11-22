//
//  AbstractActivity+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-20.
//
//

#import "AbstractActivity+Addition.h"

#define DAY_TIME_INTERVAL (60*60*24)

@implementation AbstractActivity (Addition)

+(AbstractActivity *) getTodayNextScheduleInManagedObjectContext:(NSManagedObjectContext *)context
{
    AbstractActivity *result;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSDate * now = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
    NSInteger interval = [now timeIntervalSince1970] / DAY_TIME_INTERVAL;
    NSDate * today = [NSDate dateWithTimeIntervalSince1970:(interval * DAY_TIME_INTERVAL)];
    [request setEntity:[NSEntityDescription entityForName:@"AbstractActivity" inManagedObjectContext:context]];
    NSPredicate *beginPredicate = [NSPredicate predicateWithFormat:@"begin_time < %@", [today dateByAddingTimeInterval:DAY_TIME_INTERVAL]];
    NSPredicate *endPredicate = [NSPredicate predicateWithFormat:@"end_time > %@", now];
    NSPredicate * schedule = [NSPredicate predicateWithFormat:@"canSchedule == %@",[NSNumber numberWithBool:NO]];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, endPredicate, schedule, nil]]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"begin_time" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:sort, nil];
    [request setSortDescriptors:descriptors];
    NSArray * list = [context executeFetchRequest:request error:NULL];
    if ( [list count] )
        result = list[0];
    else result = nil;
    return result;
}

+(AbstractActivity *) emptyActivityInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"AbstractActivity" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"what == nil"]];
    
    AbstractActivity * activity = [[context executeFetchRequest:request error:NULL] lastObject];
    if ( !activity )
    {
        activity = [NSEntityDescription insertNewObjectForEntityForName:@"AbstractActivity" inManagedObjectContext:context];
        activity.what = nil;
    }
    return activity;
}

@end
