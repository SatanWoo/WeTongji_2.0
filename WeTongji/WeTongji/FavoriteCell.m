//
//  FavoriteCell.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-28.
//
//

#import "FavoriteCell.h"
#import "AbstractCollection+Addition.h"
#import "Event+Addition.h"
#import "Star+Addition.h"
#import "Information+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "FavoriteIconCell.h"
#import <QuartzCore/QuartzCore.h>

#define kShadowTag 1000

@interface FavoriteCell()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isRotate;
}


@end

@implementation FavoriteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

-(void) setTableList:(NSArray *)tableList
{
    if ( _tableList == nil )
        [self.iconTableView  registerNib:[UINib nibWithNibName:@"FavoriteIconCell" bundle:nil] forCellReuseIdentifier:@"FavoriteIconCell"];
    _tableList = tableList;
    if ( _tableList.count > 4 )
    {
        _tableList = [[NSArray alloc] initWithObjects:_tableList[0],_tableList[1],_tableList[2],_tableList[3], nil];
    }
    [self.iconTableView reloadData];
}

-(void) rotate
{
    if ( _isRotate ) return;
    CGPoint center = self.iconView.center;
    CGAffineTransform at = CGAffineTransformMakeRotation(-M_PI/2);
    [self.iconTableView setTransform:at];
    [self.iconTableView setCenter:center];
    _isRotate = YES;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableList count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteIconCell"];
    if (cell == nil) {
        cell = [[FavoriteIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavoriteIconCell"];
        [cell.avatar.layer setCornerRadius:15.0f];
    }
    
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);
    [cell.contentView setTransform:at];
    AbstractCollection * collection = _tableList[indexPath.row];
    
    UIImage *placeholder = [UIImage imageNamed:@"favourite_avatar.png"];
    if ( [collection isKindOfClass:[Event class]] )
    {
        [cell.avatar setImageWithURL:[NSURL URLWithString:((Event *) collection).orgranizerAvatarLink] placeholderImage:placeholder];
    }
    else if ( [collection isKindOfClass:[Star class]] )
    {
        [cell.avatar setImageWithURL:[NSURL URLWithString:((Star *) collection).avatarLink] placeholderImage:placeholder];
    }
    else if ( [collection isKindOfClass:[Event class]] )
    {
        [cell.avatar setImageWithURL:[NSURL URLWithString:((Information *) collection).organizerAvatar] placeholderImage:placeholder];
    }
    
    if (![cell viewWithTag:kShadowTag]) {
        NSLog(@"fuck u ");
        UIImageView *shadowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favourite_avatar"]];
        [shadowImage setFrame:CGRectMake(cell.avatar.frame.origin.x, cell.avatar.frame.origin.y, shadowImage.frame.size.width,shadowImage.frame.size.height)];
        [cell insertSubview:shadowImage belowSubview:cell.avatar];
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
