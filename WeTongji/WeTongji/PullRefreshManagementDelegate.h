//
//  PullRefreshManagementDelegate.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-10.
//
//

#import <Foundation/Foundation.h>

@protocol PullRefreshManagementDelegate <NSObject>

@optional
-(void) refresh;
-(void) loadMoreData;
-(void) endLoading;
@end
