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
    result.channelId = [[NSNumber numberWithInt:[[dict objectForKey:@"Channel_Id"] intValue] - 1] stringValue];
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

+ (Event *) getTodayRecommendEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    Event * result = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSDate * now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger interval = [now timeIntervalSince1970] / DAY_TIME_INTERVAL;
    NSDate * today = [NSDate dateWithTimeIntervalSince1970:interval * DAY_TIME_INTERVAL];
    
    for ( int index = 0 ; index < 7 ; index ++ )
    {
        [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
        NSPredicate *createEndPredicate = [NSPredicate predicateWithFormat:@"createAt < %@", today];
        NSPredicate * createBeginPredicate = [NSPredicate predicateWithFormat:@"createAt >= %@",[today dateByAddingTimeInterval:-DAY_TIME_INTERVAL]];
        NSPredicate * imagePredicate = [NSPredicate predicateWithFormat:@"imageLink <> %@",[NSNull null]];
        [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects: createEndPredicate, createBeginPredicate, imagePredicate, nil]]];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"like" ascending:YES];
        [request setSortDescriptors:[[NSArray alloc] initWithObjects:sort , nil]];
        NSArray *list = [context executeFetchRequest:request error:NULL];
        today = [today dateByAddingTimeInterval:-DAY_TIME_INTERVAL];
        if ( [list count] )
        {
            result = [list lastObject];
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
