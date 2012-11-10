//
//  PullRefreshManagement.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "PullRefreshManagement.h"

@interface PullRefreshManagement()<EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,weak) UIScrollView * scrollView;

@end

@implementation PullRefreshManagement

@synthesize pullRefreshFooterView=_pullRefreshFooterView;
@synthesize pullRefreshHeaderView=_pullRefreshHeaderView;
@synthesize scrollView=_scrollView;

-(id) initWithScrollView:(UIScrollView *)scrollView;
{
    self = [super init];
    if ( self )
    {
        self.scrollView = scrollView;
        [self.scrollView addSubview:self.pullRefreshHeaderView];
        [self.scrollView addSubview:self.pullRefreshFooterView];
        [self.scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 40.0f, 0.0f)];
    }
    return self;
}

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
        [self configureFooterView];
        [_pullRefreshFooterView refreshLastUpdatedDate];
        _pullRefreshFooterView.delegate = self;
    }
    return _pullRefreshFooterView;
}

-(void) configureFooterView
{
    float height;
    if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height)
        height=self.scrollView.contentSize.height;
    else height=self.scrollView.bounds.size.height;
    [self.pullRefreshFooterView setFrame:CGRectMake(0, height, 320, 200)];
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
    [self.delegate endLoading];
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
    [self.delegate refresh];
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
    [self.delegate loadMoreData];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _reloading;
}




@end
