//
//  PullRefreshManagement.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "PullRefreshManagementDelegate.h"

@interface PullRefreshManagement : NSObject
{
    BOOL _reloading;
}

@property (nonatomic,strong) EGORefreshTableHeaderView * pullRefreshHeaderView;
@property (nonatomic,strong) EGORefreshTableFooterView * pullRefreshFooterView;
@property (nonatomic,weak) id<PullRefreshManagementDelegate> delegate;

-(id) initWithScrollView:(UIScrollView *)scrollView;

@end
