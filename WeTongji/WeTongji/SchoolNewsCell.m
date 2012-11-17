//
//  SchoolInfoCell.m
//  WeTongji
//
//  Created by Ziqi on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SchoolNewsCell.h"

@implementation SchoolNewsCell

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
    self.titleLabel.text = information.title;
    self.lookLabel.text = [information.read stringValue];
    self.descriptionLabel.text = information.summary;
    NSLog(@"%@ : %@",information.title,information.read);
    _information = information;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
