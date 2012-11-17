//
//  PullRefreshManagement.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import <Foundation/Foundation.h>

#import "PullRefreshManagementDelegate.h"

@interface PullRefreshManagement : NSObject
{
    BOOL _reloading;
}


@property (nonatomic,weak) id<PullRefreshManagementDelegate> delegate;

-(id) initWithScrollView:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerat;
-(void) setNoMoreData:(BOOL)isNoMoreData;
-(void) endLoading;
-(void) firstTrigger;

@end
