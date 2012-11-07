//
//  WTClient.m
//  WeTongjiSDK
//
//  Created by tang zhixiong on 12-11-7.
//  Copyright (c) 2012年 WeTongji. All rights reserved.
//

#import "WTClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "NSString+URLEncoding.h"

@interface WTClient()

@property (nonatomic,retain) NSMutableDictionary * params;

@end

@implementation WTClient

@synthesize params=_params;

static NSString * const baseURLString = @"http://we.tongji.edu.cn";
static NSString * const pathString = @"/api/call";

+ (WTClient *) getClient
{
    static WTClient * _client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[WTClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    
    return _client;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (NSMutableDictionary *) params
{
    if ( !_params )
    {
        _params = [[NSMutableDictionary alloc] init];
        [_params setObject:@"iPhone" forKey:@"D"];
        [_params setObject:@"2.0" forKey:@"V"];
    }
    return _params;
}

- (void)setCompletionBlock:(WTCompletionBlock)completionBlock
{
    _completionBlock = [completionBlock copy];
}

- (void)addHashParam
{
    NSArray *names = [self.params allKeys];
    NSArray *sortedNames = [names sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
    
    NSMutableString *result = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < [sortedNames count]; i++) {
        if (i > 0)
            [result appendString:@"&"];
        NSString *name = [sortedNames objectAtIndex:i];
        NSString *parameter = [self.params objectForKey:name];
        [result appendString:[NSString stringWithFormat:@"%@=%@", [name URLEncodedString],
                              [parameter URLEncodedString]]];
    }
    NSString *md5 = [result md5HexDigest];
    [self.params setObject:md5 forKey:@"H"];
}

- (void)sendRequest
{
    
    if ([self.params count])
    {
        [self addHashParam];
    }
    [self getPath:pathString parameters:self.params success:^( AFHTTPRequestOperation *operation , id resposeObject)
     {
         NSDictionary *status = [resposeObject objectForKey:@"Status"];
         NSString *statusId = [status objectForKey:@"Id"];
         NSMutableDictionary * result = [[resposeObject objectForKey:@"Data"] mutableCopy];
         if(result && [statusId intValue] == 0)
         {
             [result setObject:@"N" forKey:@"isFailed"];
         }
         else
         {
             NSString * errorDesc = [NSString stringWithFormat:@"%@", [status objectForKey:@"Memo"]];
             [result setObject:@"Y" forKey:@"isFailed"];
             [result setObject:statusId forKey:@"errorID"];
             [result setObject:errorDesc forKey:@"errorDesc"];
             NSLog(@"Server responsed error code:%d\n\
                   desc: %@\n", [statusId intValue], errorDesc);
         }
         _completionBlock([[NSDictionary alloc] initWithDictionary: result]);
     }
    failure:^(AFHTTPRequestOperation *operation , NSError * error)
     {
         NSLog(@"Request Failed");
         NSLog(@"%@", error);
     }];
    
}


- (void)login:(NSString *)num password:(NSString *)password
{
    self.params = nil;
    [self.params setObject:@"User.LogOn" forKey:@"M"];
    [self.params setObject:num forKey:@"NO"];
    [self.params setObject:password forKey:@"Password"];
    [self sendRequest];
}

- (void)logoff
{
    [self.params setObject:@"User.LogOff" forKey:@"M"];
    [self sendRequest];
}

- (void)activeUserWithNo:(NSString *) studentNumber
                password:(NSString *) password
                    name:(NSString *) name
{
    [self.params setObject:@"User.Active" forKey:@"M"];
    [self.params setObject:studentNumber forKey:@"NO"];
    [self.params setObject:password forKey:@"Password"];
    [self.params setObject:name forKey:@"Name"];
    [self sendRequest];
}

- (void)getCourses
{
    [self.params setObject:@"TimeTable.Get" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self sendRequest];
}

- (void) getCalender
{
#warning lots of things to do
}

@end
