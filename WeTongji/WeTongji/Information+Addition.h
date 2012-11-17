//
//  Information+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "Information.h"

@interface Information (Addition)

+(void) insertAnInformation:(NSDictionary *) infoDict inCategory:(NSString *) category inManagedObjectContext:(NSManagedObjectContext *) context;
+(NSArray *) getAllInformationWithCategory:(NSString *) category inManagedObjectContext:(NSManagedObjectContext *) context;
+(Information *) getInformationWithId:(NSString*) informaionId inManagedObjectContext:(NSManagedObjectContext *) context;
+(void) clearDataInManagedObjectContext:(NSManagedObjectContext *) context;

@end
