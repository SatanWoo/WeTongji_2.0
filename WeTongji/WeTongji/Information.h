//
//  Information.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractActivity.h"


@interface Information : AbstractActivity

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

@end
