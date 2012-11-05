//
//  WTClient.m
//  WeTongji
//
//  Created by 紫川 王 on 12-4-23.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTClient.h"
#import "JSON.h"
#import "NSString+URLEncoding.h"
#import "ASIFormDataRequest.h"

//static NSString* const APIDomain = @"106.187.95.107:8080";
static NSString* const APIDomain = @"we.tongji.edu.cn";

#define GetActivitySortMethodLikeDesc   @"`like` DESC"
#define GetActivitySortMethodBeginDesc  @"`begin` DESC"

@interface WTClient()

@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, assign, getter = isSessionRequired) BOOL sessionRequired;
@property (nonatomic, assign, getter = isCurrentUserIDRequired) BOOL currentUserIDRequired;

@end

@implementation WTClient

@synthesize responseStatusCode = _responseStatusCode;
@synthesize hasError = _hasError;
@synthesize errorDesc = _errorDesc;
@synthesize responseData = _responseData;

@synthesize params = _params;
@synthesize request = _request;
@synthesize sessionRequired = _sessionRequired;
@synthesize currentUserIDRequired = _currentUserIDRequired;

- (void)setCompletionBlock:(void (^)(WTClient* client))completionBlock {
    [_completionBlock autorelease];
    _completionBlock = [completionBlock copy];
}

- (WTCompletionBlock)completionBlock {
    return _completionBlock;
}

+ (id)client {
    //autorelease intentially ommited here
    return [[WTClient alloc] init];
}

- (void)dealloc {
    NSLog(@"WTClient dealloc");
    [_errorDesc release];
    [_completionBlock release];
    [_params release];
    [_request release];
    [_responseData release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if(self) {
        self.params = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.hasError = NO;
        self.responseStatusCode = 0;
        
        self.request = [[ASIHTTPRequest alloc] initWithURL:nil];
        self.request.delegate = self;
        
        [self.params setObject:@"iPhone" forKey:@"D"];
        [self.params setObject:@"1.0" forKey:@"V"];
    }
    return self;
}

- (void)reportCompletion {
    if (_completionBlock) {
        _completionBlock(self);
    }
    [self autorelease];
}

#pragma mark -
#pragma mark ASIHTTPRequest delegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Request Finished");
    //NSLog(@"Response raw string:\n%@", [request responseString]);
    NSLog(@"Response code:%d", request.responseStatusCode);
    
    switch (request.responseStatusCode) {
        case 200: // OK: everything went awesome.
            break;
        default:
        {
            self.hasError = YES;
            self.errorDesc = [NSHTTPURLResponse localizedStringForStatusCode:request.responseStatusCode];
            NSLog(@"error %@", self.errorDesc);
            goto report_completion;
        }
    }
    
    id responseJSONObject = [request.responseString JSONValue];
    NSLog(@"respond dict:%@", responseJSONObject);
    
    if ([responseJSONObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*)responseJSONObject;
        NSDictionary *status = [dict objectForKey:@"Status"];
        NSString *statusId = [status objectForKey:@"Id"];
        NSDictionary *data = [dict objectForKey:@"Data"];
        if(data && [statusId intValue] == 0) {
            self.responseData = data;
        } else {
            self.hasError = YES;
            self.responseStatusCode = [statusId intValue];
            self.errorDesc = [NSString stringWithFormat:@"%@", [status objectForKey:@"Memo"]];
            NSLog(@"Server responsed error code:%d\n\
                  desc: %@\n", self.responseStatusCode, self.errorDesc);
        }
    } else {
        self.hasError = YES;
        self.responseStatusCode = 1000;
    }
    
report_completion:
    [self reportCompletion];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed");
    NSLog(@"%@", self.request.error);
    
    self.hasError = YES;
    self.errorDesc = @""; //to do
    
    //same block called when failed
    [self reportCompletion];
}

#pragma mark - 
#pragma mark URL generation

- (NSString *)hashQueryString:(NSString *)queryString {
    NSMutableString *result = [NSMutableString stringWithString:@"&H="];
    NSString *md5 = [queryString md5HexDigest];
    [result appendFormat:@"%@", md5];
    return result;
}

- (NSString *)queryString
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
    NSString *hash = [self hashQueryString:result];
    [result appendFormat:@"%@", hash];
    
    return result;
}

- (void)buildURL
{
    NSString* url = [NSString stringWithFormat:@"http://%@/%@", APIDomain, @"api/call"];
    
    if ([self.params count]) {
        url = [NSString stringWithFormat:@"%@?%@", url, [self queryString]];
    }
    
    NSURL *finalURL = [NSURL URLWithString:url];
    
    NSLog(@"requestURL: %@", finalURL);
    
    [self.request setURL:finalURL];
}

- (void)sendRequest
{
    if ([self.request url]) {
        return;
    }
    
//    if(self.isCurrentUserIDRequired && [NSUserDefaults getCurrentUserID])
//        [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
//    
//    if(self.isSessionRequired && [NSUserDefaults getCurrentUserSession]) {
//        [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
//    }
    
    [self buildURL];
    [self.request startAsynchronous];
}

#pragma mark -
#pragma mark APIs

- (void)login:(NSString *)num password:(NSString *)password {
    [self.params setObject:@"User.LogOn" forKey:@"M"];
    [self.params setObject:num forKey:@"NO"];
    [self.params setObject:password forKey:@"Password"];
    [self sendRequest];
}

@end
