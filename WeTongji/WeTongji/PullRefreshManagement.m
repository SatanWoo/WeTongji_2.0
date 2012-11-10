//
//  PullRefreshManagement.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "PullRefreshManagement.h"

@interface PullRefreshManagement()<EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate>

@end

@implementation PullRefreshManagement

@synthesize pullRefreshFooterView=_pullRefreshFooterView;
@synthesize pullRefreshHeaderView=_pullRefreshHeaderView;

-(EGORefreshTableHeaderView *) pullRefreshHeaderView
{
    if ( !_pullRefreshHeaderView )
    {
        _pullRefreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -200, 320, 200)];
        [_pullRefreshHeaderView refreshLastUpdatedDate];
        _pullRefreshHeaderView.delegate = self;
    }
    return _pullRefreshHeaderView;
}


-(EGORefreshTableFooterView *) pullRefreshFooterView
{
    if ( !_pullRefreshFooterView )
    {
        _pullRefreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0,-200 , 320, 200)];
        [_pullRefreshFooterView refreshLastUpdatedDate];
        _pullRefreshFooterView.delegate = self;
    }
    return _pullRefreshFooterView;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData
{
	_reloading = NO;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_pullRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_pullRefreshFooterView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat
{
	[_pullRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_pullRefreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma -
#pragma - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

#pragma -
#pragma - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _reloading;
}




@end
