//
//  Star+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "Star.h"

@interface Star (Addition)

+ (void) insertStarWithDict:(NSDictionary *) dict inManagedObjectContext:(NSManagedObjectContext *)context;
+(NSArray *) getAllStarsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Star *) getStarWithId:(NSString *) starId inManagedObjectContext:(NSManagedObjectContext *)context;
+(void)clearDataInManagedObjectContext:(NSManagedObjectContext *) context;

@end
