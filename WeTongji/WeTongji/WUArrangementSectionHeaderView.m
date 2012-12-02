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
    NSDate * today = [NSDate dateWithTimeIntervalSinceNow: 60 * 60 * 8];
    NSInteger interval = [today timeIntervalSince1970] / ( 60 * 60 * 24 );
    today = [NSDate dateWithTimeIntervalSince1970:interval * 60 * 60 * 24];
    if ( [date timeIntervalSinceDate:today] >= 0 &&
        [date timeIntervalSinceDate:today] < 60 * 60 * 24 )
    {
#warning 这里调颜色
        self.day.textColor = [UIColor orangeColor];
    }
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"dd"];
    self.day.text = [form stringFromDate:date];
    [form setDateFormat:@"MM月"];
    self.month.text = [form stringFromDate:date];
}

@end
