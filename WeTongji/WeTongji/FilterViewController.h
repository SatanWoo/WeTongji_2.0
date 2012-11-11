//
//  FilterViewController.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-11.
//
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

@optional
-(void) filterViewSelectedRow:(NSInteger) row;

@end

@interface FilterViewController : UIViewController
{
    BOOL _isFilterViewAppear;
}

@property (nonatomic,weak) id<FilterViewControllerDelegate> delegate;

-(id) initWithFilterList:(NSArray *) filterList forContentView:(UIView *)contentView;

-(void)showFilterView;
-(void)hideFilterView;
-(void)selectRow:(NSInteger) row;

@end
