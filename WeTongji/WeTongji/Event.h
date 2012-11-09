//
//  Event.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-8.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * activityId;
@property (nonatomic, retain) NSDate * beginTime;
@property (nonatomic, retain) NSNumber * canFavorite;
@property (nonatomic, retain) NSNumber * canLike;
@property (nonatomic, retain) NSString * channelId;
@property (nonatomic, retain) NSDate * createAt;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSArray * imageLinkArray;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * orgranizerAvatarLink;
@property (nonatomic, retain) NSNumber * schedule;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * hidden;

@end
