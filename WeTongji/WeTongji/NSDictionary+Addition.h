//
//  NSDictionary+Addition.h
//  WeTongji
//
//  Created by Tang Zhixiong on 12-11-26.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Addition)

+(NSDictionary *) getImageLinkDictInJsonString:(NSString *) jSonString;

-(NSArray *) allKeysInStringOrder;

@end
