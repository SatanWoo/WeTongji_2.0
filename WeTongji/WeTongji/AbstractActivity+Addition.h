//
//  AbstractActivity+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-20.
//
//

#import "AbstractActivity.h"

@interface AbstractActivity (Addition)

+(AbstractActivity *) emptyActivityInManagedObjectContext:(NSManagedObjectContext *)context;

@end
