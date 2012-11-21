//
//  FavoriteCell.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-28.
//
//

#import <UIKit/UIKit.h>

@interface FavoriteCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UITableView *iconTableView;
@property (nonatomic,strong) NSArray * tableList;

-(void) rotate;

@end
