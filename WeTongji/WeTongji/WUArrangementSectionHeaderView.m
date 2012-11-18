//
//  WUArrangementSectionHeaderView.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-5.
//
//

#import "WUArrangementSectionHeaderView.h"

@implementation WUArrangementSectionHeaderView

@synthesize day;
@synthesize month;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void) setDate:(NSDate *)date
{
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"dd"];
    self.day.text = [form stringFromDate:date];
    [form setDateFormat:@"MM月"];
    self.month.text = [form stringFromDate:date];
}

@end
