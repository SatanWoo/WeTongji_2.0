//
//  Channel.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Channel : NSManagedObject

@property (nonatomic, retain) NSString * channelId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageLink;
@property (nonatomic, retain) NSNumber * follow;
@property (nonatomic, retain) NSString * detail;

@end
