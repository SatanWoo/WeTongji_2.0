//
//  NSUserDefaults+Settings.h
//  WeTongji
//
//  Created by Tang Zhixiong on 12-11-25.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    InformationDefaultTypeSchool = 0,
    InformationDefaultTypeClub,
    InformationDefaultTypeTongji,
    InformationDefaultTypeRecommend
    
} InformationDefaultType;

@interface NSUserDefaults (Settings)

+(void) setInformationDefaultType:(InformationDefaultType)type;
+ (InformationDefaultType)getInformationDefaultType;

@end
