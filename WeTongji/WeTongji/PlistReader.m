//
//  PlistReader.m
//  WeTongji
//
//  Created by Wu Ziqi on 12-10-23.
//
//

#import "PlistReader.h"
#import "LeftMenuCellModel.h"

#define kLeftMenuArray @"kLeftMenuArray"
#define kTableViewCellName @"kTableViewCellName"
#define kViewControllerIdentifier @"kViewControllerIdentifier"
#define kNeedLogin @"kNeedLogin"

@interface PlistReader()
@property (nonatomic, strong) NSDictionary *leftMenuDic;
- (void)parsePlist;
@end

@implementation PlistReader
@synthesize leftMenuDic = _leftMenuDic;

- (id)init
{
    self = [super init];
    if (self) {
        [self parsePlist];
    }
    return self;
}

- (NSArray *)getLeftMenuResult
{
    NSArray *infoArray = [self.leftMenuDic objectForKey:kLeftMenuArray];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in infoArray) {
        LeftMenuCellModel *info = [[LeftMenuCellModel alloc] init];
        info.cellName = [dict objectForKey:kTableViewCellName];
        info.identifier = [dict objectForKey:kViewControllerIdentifier];
        info.needLogin = [[dict objectForKey:kNeedLogin] boolValue];
        [result addObject:info];
    }
    return result;
}

#pragma mark - Private Method
- (void)parsePlist
{
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"LeftMenu" ofType:@"plist"];
    self.leftMenuDic = [[NSDictionary alloc] initWithContentsOfFile:configFilePath]; 
}

@end
