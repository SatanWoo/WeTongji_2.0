//
//  Event+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-8.
//
//

#import "Event+Addition.h"
#import "NSString+Addition.h"

#define DAY_TIME_INTERVAL ( 60 * 60 * 24 )

#define MISSING_PIC_LINK @"http://we.tongji.edu.cn/images/original/missing.png"

@implementation Event (Addition)

+ (Event *)insertActivity:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *activityID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Id"]];
    
    if (!activityID || [activityID isEqualToString:@""]) {
        return nil;
    }
    
    Event *result = [Event EventWithID:activityID inManagedObjectContext:context];
    if (!result)
    {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        result.canSchedule = nil;
    }
    
    result.activityId = activityID;
    result.title = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Title"]];
    result.detail = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Description"]];
    result.location = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Location"]];
    result.orgranizerAvatarLink = [NSString stringWithFormat:@"%@", [dict objectForKey:@"OrganizerAvatar"]];
    result.createAt = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"CreatedAt"]] convertToDate];
    result.imageLink = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]];
    NSLog(@"%@",[dict objectForKey:@"Image"]);
    result.organizer = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Organizer"]];
    result.beginTime = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"Begin"]] convertToDate];
    result.endTime = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"End"]] convertToDate];
    result.channelId = [[NSNumber numberWithInt:[[dict objectForKey:@"Channel_Id"] intValue]] stringValue];
    result.like = [NSNumber numberWithInt:[[dict objectForKey:@"Like"] intValue]];
    result.favorite = [NSNumber numberWithInt:[[dict objectForKey:@"Favorite"] intValue]];
    result.schedule = [NSNumber numberWithInt:[[dict objectForKey:@"Schedule"] intValue]];
    if ( [result.canFavorite boolValue] || !result.canFavorite )
        result.canFavorite = [NSNumber numberWithInt:[[dict objectForKey:@"CanFavorite"] intValue]];
    if ( [result.canLike boolValue] || !result.canLike  )
        result.canLike = [NSNumber numberWithInt:[[dict objectForKey:@"CanLike"] intValue]];
    if ( [result.canSchedule boolValue] || !result.canSchedule  )
        result.canSchedule = [NSNumber numberWithInt:[[dict objectForKey:@"CanSchedule"] intValue]];
    NSLog(@"%@ : %@",result.canSchedule,result.beginTime);
    result.begin_time = result.beginTime;
    result.end_time = result.endTime;
    result.what = result.title;
    result.where =result.location;
    result.collectionSummary = result.detail;
    result.collectionTitle = result.title;
    result.collectionSource = @"推荐活动";
    return result;
}

-(NSNumber *) can_favorite
{
    return self.canFavorite;
}

+ (Event *)EventWithID:(NSString *)activityId inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"activityId == %@", activityId]];
    
    Event *result = [[context executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (NSArray *)allEventsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    NSArray *result = [context executeFetchRequest:request error:NULL];
    return result;
}

+(Event *) getNearestEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    Event * result = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSDate * now = [NSDate dateWithTimeIntervalSinceNow:0];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    NSPredicate *beginPredicate = [NSPredicate predicateWithFormat:@"endTime >= %@", now];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, nil]]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"beginTime" ascending:YES];
    [request setSortDescriptors:[[NSArray alloc] initWithObjects:sort , nil]];
        NSArray *list = [context executeFetchRequest:request error:NULL];
    if ( list.count )
    result = list[0];
    return result;
}

+(Event *) getLatestEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    Event * result = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createAt" ascending:NO];
    [request setSortDescriptors:[[NSArray alloc] initWithObjects:sort , nil]];
    NSArray *list = [context executeFetchRequest:request error:NULL];
    if ( list.count )
        result = list[0];
    return result;
}

+(Event *) getHotestEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    Event * result = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"like" ascending:NO];
    [request setSortDescriptors:[[NSArray alloc] initWithObjects:sort , nil]];
    NSArray *list = [context executeFetchRequest:request error:NULL];
    if ( list.count )
        result = list[0];
    return result;
}

+ (Event *) getTodayRecommendEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    Event * result = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSDate * today = [NSDate dateWithTimeIntervalSinceNow:32*60*60];
    NSInteger interval = [today timeIntervalSince1970] / DAY_TIME_INTERVAL;
    interval = interval * DAY_TIME_INTERVAL;
    today = [NSDate dateWithTimeIntervalSince1970:interval];
    for ( int index = 0 ; index < 3 ; index ++ )
    {
        [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
        NSPredicate *beginPredicate = [NSPredicate predicateWithFormat:@"beginTime >= %@", today];
        NSPredicate * endPredicate = [NSPredicate predicateWithFormat:@"beginTime < %@",[today dateByAddingTimeInterval:DAY_TIME_INTERVAL]];
        NSPredicate * imagePredicate = [NSPredicate predicateWithFormat:@"imageLink <> %@",MISSING_PIC_LINK];
        [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: beginPredicate, endPredicate, imagePredicate, nil]]];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"like" ascending:YES];
        [request setSortDescriptors:[[NSArray alloc] initWithObjects:sort , nil]];
        NSArray *list = [context executeFetchRequest:request error:NULL];
        today = [today dateByAddingTimeInterval:DAY_TIME_INTERVAL];
        if ( [list count] )
        {
            result = [list lastObject];
            NSLog(@"%@",result.imageLink);
            return result;
        }
    }
    return result;
}

+ (void) clearAllEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}

+ (NSArray *)allScheduledEventsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"canSchedule == 0"]];
    
    NSArray *result = [context executeFetchRequest:request error:NULL];
    return result;
}
+ (void) clearAllScheduledEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"canSchedule == 0"]];
    NSArray *items = [context executeFetchRequest:request error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}


@end
