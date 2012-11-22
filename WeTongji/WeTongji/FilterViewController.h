//
//  FilterViewController.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

@protocol FilterViewControllerDelegate <NSObject>

@optional
-(void) filterViewSelectedRow:(NSInteger) row;

@end

@interface FilterViewController : CoreDataViewController
{
    BOOL _isFilterViewAppear;
}

@property (nonatomic,weak) id<FilterViewControllerDelegate> delegate;

-(id) initWithFilterList:(NSArray *) filterList forContentView:(UIView *)contentView;

-(void)showFilterView;
-(void)hideFilterView;
-(void) reloadTableView;
-(void)selectRow:(NSInteger) row;

@end
