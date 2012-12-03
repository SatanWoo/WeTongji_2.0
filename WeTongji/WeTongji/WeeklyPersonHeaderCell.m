//
//  WeeklyPersonHeaderCell.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import "WeeklyPersonHeaderCell.h"
#import "NSDictionary+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import <QuartzCore/QuartzCore.h>
#define kRound 3.0f

@implementation WeeklyPersonHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void) setStar:(Star *)star
{
    [self.avatar setImageWithURL:[NSURL URLWithString:star.avatarLink]];
    self.name.text = star.title;
    self.title.text = star.jobTitle;
    self.summary.text = star.words;
    self.likeCount.text = [star.like stringValue];
    NSDictionary * imageDict = [NSDictionary getImageLinkDictInJsonString:star.images];
    if ( [imageDict allKeys].count ){
        id key = [imageDict allKeys][0];
        [self.image setImageWithURL:[NSURL URLWithString:key] placeholderImage:[UIImage imageNamed:@"defalut_pic_loading"]];
    }
    _star = star;
    
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.image.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(kRound, kRound)].CGPath;
    [self.image.layer setMasksToBounds:YES];
    self.image.layer.mask = shapeLayer;
    //[self.personBG.layer setCornerRadius:3.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
