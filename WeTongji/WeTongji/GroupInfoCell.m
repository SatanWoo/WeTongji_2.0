//
//  GroupInfoCell.m
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-1.
//
//

#import "GroupInfoCell.h"

@implementation GroupInfoCell
@synthesize infoTitle;
@synthesize groupName;
@synthesize seeNumber;

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
