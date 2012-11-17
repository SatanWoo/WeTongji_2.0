//
//  PullRefreshManagement.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import "PullRefreshManagement.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface PullRefreshManagement()<EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,strong) EGORefreshTableHeaderView * pullRefreshHeaderView;
@property (nonatomic,strong) EGORefreshTableFooterView * pullRefreshFooterView;
@property (nonatomic,weak) UITableView * scrollView;

@end

@implementation PullRefreshManagement

@synthesize pullRefreshFooterView=_pullRefreshFooterView;
@synthesize pullRefreshHeaderView=_pullRefreshHeaderView;
@synthesize scrollView=_scrollView;

-(id) initWithScrollView:(UITableView *)scrollView;
{
    self = [super init];
    if ( self )
    {
        self.scrollView = scrollView;
        [self.scrollView addSubview:self.pullRefreshHeaderView];
        self.scrollView.tableFooterView=self.pullRefreshFooterView;
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
        _pullRefreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0,0 , 320, 0)];
        [_pullRefreshFooterView refreshLastUpdatedDate];
        _pullRefreshFooterView.delegate = self;
    }
    return _pullRefreshFooterView;
}


-(void) setNoMoreData:(BOOL)isNoMoreData
{
    [self.pullRefreshFooterView setIsEndingAll:isNoMoreData];
}

-(void) firstTrigger
{
    [self.pullRefreshFooterView setIsEndingAll:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.pullRefreshHeaderView setState:EGOOPullRefreshLoading];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, self.scrollView.contentInset.bottom, 0.0f);
    [UIView commitAnimations];
    [self.scrollView scrollRectToVisible:CGRectMake(-120, 0, 320, 10) animated:YES];
    [self.delegate refresh];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
	
}

- (void) endLoading
{
	_reloading = NO;
        [self.delegate endLoading];
    [self.pullRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
	[self.pullRefreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
    [self.pullRefreshFooterView setIsEndingAll:NO];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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
#pragma - EGORefreshTableFooterDelegate

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.delegate loadMoreData];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _reloading;
}




@end
