//
//  User+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-14.
//
//

#import "User.h"

@interface User (Addition)

+(User *) userinManagedObjectContext:(NSManagedObjectContext *)context;
+(void) updateUser:(NSDictionary *) dict inManagedObjectContext:(NSManagedObjectContext *)context;
+(void) userClearinManagedObjectContext:(NSManagedObjectContext *)context;

@end
