//
//  AbstractActivity+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-20.
//
//

#import "AbstractActivity+Addition.h"

@implementation AbstractActivity (Addition)

+(AbstractActivity *) emptyActivityInManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"AbstractActivity" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"what == nil"]];
    
    AbstractActivity * activity = [[context executeFetchRequest:request error:NULL] lastObject];
    if ( !activity )
    {
        activity = [NSEntityDescription insertNewObjectForEntityForName:@"AbstractActivity" inManagedObjectContext:context];
        activity.what = nil;
    }
    return activity;
}

@end
