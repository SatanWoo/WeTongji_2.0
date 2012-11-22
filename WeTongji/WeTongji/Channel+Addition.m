//
//  Channel+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-23.
//
//

#import "Channel+Addition.h"

@implementation Channel (Addition)
+(void) insertChannel:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *ID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"Id"]];
    
    if (!ID || [ID isEqualToString:@""]) {
        return;
    }
    
    Channel *result = [Channel channelWithId:ID inManagedObjectContext:context];
    if (!result)
    {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:context];
    }
    result.channelId = ID;
    result.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]];
     result.imageLink = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]];
    result.follow = [NSNumber numberWithInt:[[dict objectForKey:@"Follow"] intValue]];
     result.detail = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Description"]];
}
+(Channel *) channelWithId:(NSString *)channelId inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Channel" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"channelId == %@", channelId]];
    
    Channel *result = [[context executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}
+(NSArray *) allChannelsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Channel" inManagedObjectContext:context]];
    NSArray *result = [context executeFetchRequest:request error:NULL];
    return result;
}
+ (void) clearAllChannelsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Channel" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}

@end
