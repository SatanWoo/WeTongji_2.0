//
//  User+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-14.
//
//

#import "User+Addition.h"
#import "NSString+Addition.h"

@implementation User (Addition)

+(User *) userinManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [request setPredicate:nil];
    User *result = [[context executeFetchRequest:request error:NULL] lastObject];
    return result;
}

+(void) updateUser:(NSDictionary *) dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    User * user = [[self class] userinManagedObjectContext:context];
    if ( !user )
    user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    user.qq = [NSString stringWithFormat:@"%@",[dict objectForKey:@"QQ"]];
    user.name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Name"]];
    user.degree = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Degree"]];
    user.year = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Year"]];
    user.sinaWeibo = [NSString stringWithFormat:@"%@",[dict objectForKey:@"SinaWeibo"]];
    user.avatarLink = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Avatar"]];
    user.major = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Major"]];
    user.nativePlace = [NSString stringWithFormat:@"%@",[dict objectForKey:@"NativePlace"]];
    user.email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Email"]];
    user.gender = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Gender"]];
    user.birthday = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"Birthday"]] convertToDate];
    user.department = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Department"]];
    user.displayname = [NSString stringWithFormat:@"%@",[dict objectForKey:@"DisplayName"]];
    user.phone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Phone"]];
    user.plan = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Plan"]];
    user.studentNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"NO"]];
    user.age = [NSNumber numberWithDouble: (-[user.birthday timeIntervalSinceNow] ) / (60*60*24*365) ];
}

+(void) userClearinManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}


@end
