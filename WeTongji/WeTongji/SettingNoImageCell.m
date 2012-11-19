//
//  SettingNoImageCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 12-11-19.
//
//

#import "SettingNoImageCell.h"

@implementation SettingNoImageCell
@synthesize swtich = _swtich;
@synthesize name = _name;
@synthesize back = _back;

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
