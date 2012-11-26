//
//  RecommendCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-27.
//
//

#import "RecommendCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@implementation RecommendCell
@synthesize infoTitle = _infoTitle;
@synthesize source = _source;
@synthesize icon = _icon;
@synthesize count = _count;
@synthesize preview = _preview;

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
    [self.infoTitle sizeToFit];
    self.source.text = information.source;
    self.count.text = [information.read stringValue];
    [self.preview setImageWithURL:[NSURL URLWithString: information.image]];
    _information = information;
    
    CGRect oldFrame = self.icon.frame;
    CGRect titleFrame = self.infoTitle.frame;
    float newX = titleFrame.origin.x + 4 + titleFrame.size.width;
    oldFrame.origin.x = newX;
    self.icon.frame = oldFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
