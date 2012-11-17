//
//  Exam+Addition.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-17.
//
//

#import "Exam+Addition.h"
#import "NSString+Addition.h"


@implementation Exam (Addition)

+(void) insertAnExam:(NSDictionary *) dict inManagedObjectContext:(NSManagedObjectContext *) context
{
    NSString * examNO = [NSString stringWithFormat:@"%@", [dict objectForKey:@"nO"]];
    if ( !examNO || [examNO isEqualToString:@""]) return;
    Exam * exam = [Exam getExamWithNO:examNO  inManagedObjectContext:context];
    if ( !exam )
    {
        exam = [NSEntityDescription insertNewObjectForEntityForName:@"Exam" inManagedObjectContext:context];
    }
    exam.begin = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"Begin"]] convertToDate];
    exam.end = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"End"]] convertToDate];
    exam.hours =[NSString stringWithFormat:@"%@",[dict objectForKey:@"Hours"]];
    exam.location = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Location"]];
    exam.nO = [NSString stringWithFormat:@"%@",[dict objectForKey:@"NO"]];
    exam.name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Name"]];
    exam.point = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Point"]];
    exam.required = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Required"]];
    exam.teacher = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Teacher"]];
    exam.what = [NSString stringWithFormat:@"%@(考试)",exam.name];
    exam.where = exam.location;
    exam.begin_time = exam.begin;
    exam.end_time = exam.end;
}

+(NSArray *) getAllExamithCategoryinManagedObjectContext:(NSManagedObjectContext *) context
{
    NSArray * result;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context]];
    result = [context executeFetchRequest:request error:NULL];
    return result;
}

+(Exam *) getExamWithNO:(NSString*) examNO inManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"nO == %@", examNO]];
    
    Exam *result = [[context executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+(void) clearDataInManagedObjectContext:(NSManagedObjectContext *) context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Exam" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    for (NSManagedObject *managedObject in items)
        [context deleteObject:managedObject];
}

@end
