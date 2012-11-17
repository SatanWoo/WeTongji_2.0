//
//  Exam+Addition.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-17.
//
//

#import "Exam.h"

@interface Exam (Addition)

+(void) insertAnExam:(NSDictionary *) infoDict inManagedObjectContext:(NSManagedObjectContext *) context;
+(NSArray *) getAllExamithCategoryinManagedObjectContext:(NSManagedObjectContext *) context;
+(Exam *) getExamWithNO:(NSString*) examNO inManagedObjectContext:(NSManagedObjectContext *) context;
+(void) clearDataInManagedObjectContext:(NSManagedObjectContext *) context;

@end
