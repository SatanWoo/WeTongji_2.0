//
//  Star.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-9.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Star : NSManagedObject

@property (nonatomic, retain) NSString * avatarLink;
@property (nonatomic, retain) NSNumber * canFavorite;
@property (nonatomic, retain) NSNumber * canLike;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * starId;
@property (nonatomic, retain) NSArray * images;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) NSString * studentNumber;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * words;
@property (nonatomic, retain) NSNumber * hiden;

@end
