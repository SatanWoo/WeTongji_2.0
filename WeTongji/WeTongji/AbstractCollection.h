//
//  AbstractCollection.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AbstractCollection : NSManagedObject

@property (nonatomic, retain) NSString * collectionTitle;
@property (nonatomic, retain) NSString * collectionImageLink;
@property (nonatomic, retain) NSString * collectionSource;

@end
