//
//  Event+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-8.
//
//

#import "Event.h"

@interface Event (Addition)

+ (Event *)insertActivity:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Event *)EventWithID:(NSString *)activityId inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allEventsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) clearAllEventInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)allScheduledEventsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) clearAllScheduledEventInManagedObjectContext:(NSManagedObjectContext *)context;



@end
