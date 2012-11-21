//
//  AbstractCollection+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-21.
//
//

#import "AbstractCollection.h"


@interface AbstractCollection (Addition)

+ (NSArray *)allCollectionInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) clearAllCollectionInManagedObjectContext:(NSManagedObjectContext *)context;

@end
