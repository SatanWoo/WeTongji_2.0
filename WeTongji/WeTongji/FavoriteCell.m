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
    _tableList = nil;
    [self.iconTableView reloadData];
    _tableList = tableList;
    if ( _tableList.count > 4 )
    {
        _tableList = [[NSArray alloc] initWithObjects:_tableList[0],_tableList[1],_tableList[2],_tableList[3], nil];
    }
    [self.iconTableView reloadData];
    for ( int index = 0 ; index < _tableList.count ; index++ )
    {
        AbstractCollection * collection = _tableList[index];
        UITableViewCell * cell = [self.iconTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if ( [collection isKindOfClass:[Event class]] )
        {
            [cell.imageView setImageWithURL:[NSURL URLWithString:((Event *) collection).orgranizerAvatarLink]];
        }
        else if ( [collection isKindOfClass:[Star class]] )
        {
            [cell.imageView setImageWithURL:[NSURL URLWithString:((Star *) collection).avatarLink]];
        }
        else if ( [collection isKindOfClass:[Event class]] )
        {
            [cell.imageView setImageWithURL:[NSURL URLWithString:((Information *) collection).organizerAvatar]];
        }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CGAffineTransform at = CGAffineTransformMakeRotation(M_PI/2);
    [cell.contentView setTransform:at];
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
