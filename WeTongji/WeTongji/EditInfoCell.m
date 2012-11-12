//
//  EditInfoCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-12.
//
//

#import "EditInfoCell.h"

@implementation EditInfoCell
@synthesize name;
@synthesize field;

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
}

@end
