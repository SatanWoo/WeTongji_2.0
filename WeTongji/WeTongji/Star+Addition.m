//
//  Star+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "Star+Addition.h"
#import <WeTongjiSDK/WetongjiSDK.h>

@implementation Star (Addition)

+ (Star *) insertStarWithDict:(NSDictionary *) dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString * starId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
    if ( !starId || [starId isEqualToString:@""]) return nil;
    Star * result = [Star getStarWithId:starId inManagedObjectContext:context];
    if ( !result )
    {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Star" inManagedObjectContext:context];
    }
    result.avatarLink = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Avatar"]];
    if ( [result.canFavorite boolValue] || !result.canFavorite )
        result.canFavorite = [NSNumber numberWithInt:[[dict objectForKey:@"CanFavorite"] intValue]];
    if ( [result.canLike boolValue] || !result.canLike )
        result.canLike = [NSNumber numberWithInt:[[dict objectForKey:@"CanLike"] intValue]];
    result.detail = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Description"]];
    result.starId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
    result.images = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"Images"] JSONRepresentation]];
    result.jobTitle = [NSString stringWithFormat:@"%@",[dict objectForKey:@"JobTitle"]];
    result.like = [NSNumber numberWithInt:[[dict objectForKey:@"Like"] intValue]];
    result.favorite = [NSNumber numberWithInt:[[dict objectForKey:@"Favorite"] intValue]];
    result.count = [NSString stringWithFormat:@"%@",[dict objectForKey:@"NO"]];
    result.read = [NSNumber numberWithInt:[[dict objectForKey:@"Like"] intValue]];
    result.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Name"]];
    result.words = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Words"]];
    result.collectionSummary = result.words;
    result.collectionTitle = result.title;
    result.collectionSource = @"每周人物";
    return result;
}

-(NSNumber *) can_favorite
{
    return self.canFavorite;
}

+(NSArray *) getAllStarsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:context]];
    NSArray *result = [context executeFetchRequest:request error:NULL];
    return result;
}

+ (Star *) getStarWithId:(NSString *) starId inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"starId == %@", starId]];
    
    Star *result = [[context executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+(void)clearDataInManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}

@end
