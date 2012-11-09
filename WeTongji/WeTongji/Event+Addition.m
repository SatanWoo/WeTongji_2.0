//
//  Event+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-8.
//
//

#import "Event+Addition.h"
#import "NSString+Addition.h"

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
    }
    
    result.activityId = activityID;
    result.title = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Title"]];
    result.detail = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Description"]];
    result.location = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Location"]];
    result.orgranizerAvatarLink = [NSString stringWithFormat:@"%@", [dict objectForKey:@"OrganizerAvatar"]];
    result.createAt = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"CreatedAt"]] convertToDate];
    //result.imageLinkArray =
    NSLog(@"%@",[dict objectForKey:@"Image"]);
    result.organizer = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Organizer"]];
    //result.status =  [NSString stringWithFormat:@"%@", [dict objectForKey:@"Status"]];
    result.beginTime = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"Begin"]] convertToDate];
    result.endTime = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"End"]] convertToDate];
    result.channelId = [[NSNumber numberWithInt:[[dict objectForKey:@"Channel_Id"] intValue] - 1] stringValue];
    result.like = [NSNumber numberWithInt:[[dict objectForKey:@"Like"] intValue]];
    result.favorite = [NSNumber numberWithInt:[[dict objectForKey:@"Favorite"] intValue]];
    result.schedule = [NSNumber numberWithInt:[[dict objectForKey:@"Schedule"] intValue]];
    result.canFavorite = [NSNumber numberWithInt:[[dict objectForKey:@"CanFavorite"] intValue]];
    result.canLike = [NSNumber numberWithInt:[[dict objectForKey:@"CanLike"] intValue]];
    
    return result;
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

+ (void) clearAllEventInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray * eventList = [Event allEventsInManagedObjectContext:context];
    for ( Event * event in eventList ) [context delete:event];
}

@end
