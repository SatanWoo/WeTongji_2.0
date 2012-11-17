//
//  GroupInfoCell.m
//  WeTongji
//
//  Created by Ziqi Wu on 12-11-1.
//
//

#import "GroupInfoCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

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

-(void) setInformation:(Information *)information
{
    self.infoTitle.text = information.title;
    self.groupName.text = information.organizer;
    [self.organizerAvatar setImageWithURL:[NSURL URLWithString:information.organizerAvatar]];
    self.seeNumber.text = [information.read stringValue];
    _information = information;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
