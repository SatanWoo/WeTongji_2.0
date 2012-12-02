//
//  MyFavoriteCell.m
//  WeTongji
//
//  Created by Tang Zhixiong on 12-12-2.
//
//

#import "MyFavoriteCell.h"

@interface MyFavoriteCell()

@property (nonatomic,strong) AbstractCollection * colleciton;

@end

@implementation MyFavoriteCell

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

-(void) setCollection:(AbstractCollection *) collection
{
    _colleciton = collection;
    //implement this method in subclass
}

@end
