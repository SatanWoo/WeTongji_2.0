//
//  Channel+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-23.
//
//

#import "Channel.h"

@interface Channel (Addition)

+(void) insertChannel:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+(Channel *) channelWithId:(NSString *)channelId inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *) allChannelsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) clearAllChannelsInManagedObjectContext:(NSManagedObjectContext *)context;
@end
