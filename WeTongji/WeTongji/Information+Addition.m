//
//  Information+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "Information+Addition.h"
#import "NSString+Addition.h"

@implementation Information (Addition)

+(void) insertAnInformation:(NSDictionary *) infoDict inManagedObjectContext:(NSManagedObjectContext *) context
{
    NSString * informationId = [NSString stringWithFormat:@"%@", [infoDict objectForKey:@"Id"]];
    if ( !informationId || [informationId isEqualToString:@""]) return;
    Information * information = [Information getInformationWithId:informationId inManagedObjectContext:context];
    if ( !information )
    {
        information = [NSEntityDescription insertNewObjectForEntityForName:@"Information" inManagedObjectContext:context];
    }
    information.canFavorite = [NSNumber numberWithInt:[[infoDict objectForKey:@"CanFavorite"] intValue]];
    information.canLike = [NSNumber numberWithInt:[[infoDict objectForKey:@"CanLike"] intValue]];
    information.category = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"Category"]];
    information.context = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"Context"]];
    information.createdAt = [[NSString stringWithFormat:@"%@",[infoDict objectForKey:@"CreatedAt"]] convertToDate];
    information.favorite = [NSNumber numberWithInt:[[infoDict objectForKey:@"Favorite"] intValue]];
    information.id = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"Id"]];
    //information.images =
    NSLog(@"%@",[infoDict objectForKey:@"Images"]);
    information.like = [NSNumber numberWithInt:[[infoDict objectForKey:@"like"] intValue]];
    information.read = [NSNumber numberWithInt:[[infoDict objectForKey:@"read"] intValue]];;
    information.source = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"Source"]];
    information.summary = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"Summary"]];
    information.title = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"Title"]];
}

+(NSArray *) getAllInformationWithCategory:(NSString *) category inManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Information" inManagedObjectContext:context]];
    NSArray *tempList = [context executeFetchRequest:request error:NULL];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (Information * information in tempList)
        if ([information.category isEqualToString:category])
            [result addObject:information];
    return [NSArray arrayWithArray:result];
}

+(Information *) getInformationWithId:(NSString*) informaionId inManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Information" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id == %@", informaionId]];
    
    Information *result = [[context executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+(void) clearDataInManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Information" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}

@end
