//
//  AbstractCollection+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-21.
//
//

#import "AbstractCollection+Addition.h"

@implementation AbstractCollection (Addition)

+ (NSArray *)allCollectionInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"AbstractCollection" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"can_favorite == 0"]];
    NSArray *result = [context executeFetchRequest:request error:NULL];
    return result;
}

+ (void) clearAllCollectionInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"AbstractCollection" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"can_favorite == 0"]];
    NSArray *items = [context executeFetchRequest:request error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}



@end
