//
//  Information.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractCollection.h"


@interface Information : AbstractCollection

@property (nonatomic, retain) NSNumber * canFavorite;
@property (nonatomic, retain) NSNumber * canLike;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSNumber * hiden;
@property (nonatomic, retain) NSString * images;
@property (nonatomic, retain) NSString * informationId;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizerAvatar;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * ticketService;

@end
