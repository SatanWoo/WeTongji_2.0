//
//  LeftMenuCellModel.h
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-23.
//
//

#import <Foundation/Foundation.h>

@interface LeftMenuCellModel : NSObject
@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) BOOL needLogin;
@end
