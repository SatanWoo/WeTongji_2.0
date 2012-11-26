//
//  ArrangementCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-11-5.
//
//

#import "ArrangementCell.h"
#define kBottom 80
#define kRight 320

@implementation ArrangementCell
@synthesize locationLabel = _locationLabel;
@synthesize timeLabel = _timeLabel;
@synthesize titleLabel = _titleLabel;
@synthesize colorBall = _colorBall;
@synthesize line = _line;
@synthesize locationIcon = _locationIcon;

//- (void)setLine:(UIImageView *)line
//{
//    NSLog(@"Caoniamde");
//    CGSize size = [line image].size;
//    _line = line;
//    _line.frame = CGRectMake(kRight - size.width, kBottom - size.height, size.width, size.height);
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
