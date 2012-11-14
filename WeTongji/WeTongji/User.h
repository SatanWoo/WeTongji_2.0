//
//  User.h
//  WeTongji
//
//  Created by tang zhixiong on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * sinaWeibo;
@property (nonatomic, retain) NSString * avatarLink;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * nativePlace;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * displayname;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * plan;
@property (nonatomic, retain) NSString * studentNumber;
@property (nonatomic, retain) NSNumber * age;

@end
