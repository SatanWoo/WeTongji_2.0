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
#import "NSString+Addition.h"
#import "JSON.h"

#define HttpMethodGET @"GET"
#define HttpMethodPOST @"POST"
#define HttpMethodCostomUpLoadAvatar @"UPLOADAVATAR"

@interface WTClient()

@property (nonatomic,strong) NSMutableDictionary * params;
@property (nonatomic,strong) WTCompletionBlock completionBlock;
@property (nonatomic,strong) NSMutableDictionary * postValue;
@property (nonatomic,weak) UIImage * avatarImage;

@end

@implementation WTClient

@synthesize params=_params;
@synthesize completionBlock=_completionBlock;
@synthesize postValue=_postValue;
@synthesize avatarImage = _avatarImage;

static NSString * const baseURLString = @"http://we.tongji.edu.cn";
static NSString * const pathString = @"/api/call";

+(WTClient *)getClient
{
    static WTClient * _client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [[WTClient alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        _client.parameterEncoding = AFFormURLParameterEncoding;
        //_client.stringEncoding = NSUnicodeStringEncoding;
    });
    
    return _client;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (NSMutableDictionary *) postValue
{
    if ( !_postValue )
    {
        _postValue = [[NSMutableDictionary alloc] init];
    }
    return _postValue;
}

- (NSMutableDictionary *) params
{
    if ( !_params )
    {
        _params = [[NSMutableDictionary alloc] init];
        [_params setObject:@"iPhone" forKey:@"D"];
        [_params setObject:@"2.0.0" forKey:@"V"];
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
    
    return result;
}

- (void)sendRequest
{
    [self sendRequestWithHttpMethod:HttpMethodGET];
}

- (void)sendRequestWithHttpMethod:(NSString *)httpMethod;
{
    
    if ([self.params count])
    {
        if ( ![self.params objectForKey:@"H"] )
        [self addHashParam];
    }
    
    NSMutableURLRequest * request;
    if ( [httpMethod isEqualToString:HttpMethodPOST] )
    {
        request= [self requestWithMethod:httpMethod path:[NSString stringWithFormat:@"%@?%@",pathString,[self queryString]] parameters:self.postValue];
    }
    if ( [httpMethod isEqualToString:HttpMethodGET] )
    {
        request = [self requestWithMethod:httpMethod path:pathString parameters:self.params];
    }
    if ( [httpMethod isEqualToString:HttpMethodCostomUpLoadAvatar] )
    {
        NSData *imageData = UIImageJPEGRepresentation(self.avatarImage, 1.0);
        request = [self multipartFormRequestWithMethod:HttpMethodPOST path:[NSString stringWithFormat:@"%@?%@",pathString,[self queryString]] parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData)
                   {
                       [formData appendPartWithFileData:imageData name:@"Image" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
                   }];
    }
    
    NSLog(@"%@",request);
    NSLog(@"%@",[[NSString alloc]initWithData:[request HTTPBody] encoding:self.stringEncoding]);
    AFHTTPRequestOperation * operation = [self HTTPRequestOperationWithRequest:request success:^( AFHTTPRequestOperation *operation , id resposeObject)
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
    [self enqueueHTTPRequestOperation:operation];
    self.params = nil;
    self.postValue = nil;
    self.avatarImage = nil;
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

- (void)updateUserDisplayName:(NSString *)display_name email:(NSString *)email weiboName:(NSString *)weibo phoneNum:(NSString *)phone qqAccount:(NSString *)qq
{
    [self.params setObject:@"User.Update" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc] init];
    if (display_name != nil) [itemDict setObject:display_name forKey:@"DisplayName"];
    if (email != nil) [itemDict setObject:email forKey:@"Email"];
    if (weibo != nil) [itemDict setObject:weibo forKey:@"SinaWeibo"];
    if (phone != nil) [itemDict setObject:phone forKey:@"Phone"];
    if (qq != nil) [itemDict setObject:qq forKey:@"QQ"];
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:itemDict forKey:@"User"];
    NSString *userJSONStr = [userDict JSONRepresentation];
    NSLog(@"userJSONStr %@", userJSONStr);
    [self addHashParam];
    [self.postValue setObject:userJSONStr forKey:@"User"];
    [self sendRequestWithHttpMethod:HttpMethodPOST];
}

- (void)updatePassword:(NSString *)new withOldPassword:(NSString *)old
{
    [self.params setObject:@"User.Update.Password" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:new forKey:@"New"];
    [self.params setObject:old forKey:@"Old"];
    [self sendRequest];
}

- (void)resetPasswordWithNO:(NSString *) studentNumber
                       Name:(NSString*) name
{
    [self.params setObject:@"User.Reset.Password" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:studentNumber forKey:@"NO"];
    [self.params setObject:name forKey:@"Name"];
    [self sendRequest];
}

- (void)getUserInformation
{
    [self.params setObject:@"User.Get" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self sendRequest];
}

- (void)updateUserAvatar:(UIImage *)image
{
    [self.params setObject:@"User.Update.Avatar" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    self.avatarImage = image;
    [self sendRequestWithHttpMethod:HttpMethodCostomUpLoadAvatar];
}


- (void)getScheduleWithBeginDate:(NSDate *)begin endDate:(NSDate *)end
{
    [self.params setObject:@"Schedule.Get" forKey:@"M"];
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:[NSString standardDateStringCovertFromDate:begin] forKey:@"Begin"];
    [self.params setObject:[NSString standardDateStringCovertFromDate:end] forKey:@"End"];
    [self sendRequest];
}

- (void) setChannelFavored:(NSString *) channelId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Channel.Favorite" forKey:@"M"];
    [self.params setObject:channelId forKey:@"Id"];
    [self sendRequest];
    
}
     
- (void) cancelChannelFavored:(NSString *) channelId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Channel.UnFavorite" forKey:@"M"];
    [self.params setObject:channelId forKey:@"Id"];
    [self sendRequest];
}

- (void) getChannels
{
    [self.params setObject:@"Channels.Get" forKey:@"M"];
    [self sendRequest];
}

- (void) getActivitiesInChannel:(NSString *) channelId
                         inSort:(NSString *) sort
                        Expired:(Boolean) isExpired
                       nextPage:(int) nextPage;
{
    [self.params setObject:@"Activities.Get" forKey:@"M"];
    if (channelId) [self.params setObject:channelId forKey:@"Channel_Ids"];
    if (sort) [self.params setObject:sort forKey:@"Sort"];
    if (isExpired) [self.params setObject:[NSString stringWithFormat:@"%d", isExpired] forKey:@"Expire"];
    [self.params setObject:[NSString stringWithFormat:@"%d",nextPage] forKey:@"P"];
    [self sendRequest];
}

- (void) setLikeActivitiy:(NSString *) activityId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Activity.Like" forKey:@"M"];
    [self.params setObject:activityId forKey:@"Id"];
    [self sendRequest];
}

- (void) cancelLikeActivity:(NSString *) activityId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Activity.UnLike" forKey:@"M"];
    [self.params setObject:activityId forKey:@"Id"];
    [self sendRequest];
}

- (void) setActivityFavored:(NSString *) activityId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Activity.Favorite" forKey:@"M"];
    [self.params setObject:activityId forKey:@"Id"];
    [self sendRequest];
}

- (void) cancelActivityFavored:(NSString *) activityId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Activity.UnFavorite" forKey:@"M"];
    [self.params setObject:activityId forKey:@"Id"];
    [self sendRequest];
}

- (void) getFavoritesWithNextPage:(int) nextPage
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Favorite.Get" forKey:@"M"];
    [self.params setObject:[NSString stringWithFormat:@"%d",nextPage] forKey:@"P"];
    [self sendRequest];
}

- (void) getAllInformationInSort:(NSString *) sort
                        nextPage:(int)nextPage;
{
    [self.params setObject:@"Information.GetList" forKey:@"M"];
    if ( sort ) [self.params setObject:sort forKey:@"Sort"];
    [self.params setObject:[NSString stringWithFormat:@"%d",nextPage] forKey:@"P"];
    [self sendRequest];
}

- (void) getDetailOfInformaion:(NSString *) informationId
{
    [self.params setObject:@"Information.Get" forKey:@"M"];
    [self.params setObject:informationId forKey:@"Id"];
    [self sendRequest];
}

- (void) readInformaion:(NSString *) informationId
{
    [self.params setObject:@"Information.Read" forKey:@"M"];
    [self.params setObject:informationId forKey:@"Id"];
    [self sendRequest];
}

- (void) getNewVersion
{
    [self.params setObject:@"System.Version" forKey:@"M"];
    [self sendRequest];
}

- (void) getLatestStar
{
    [self.params setObject:@"Person.GetLatest" forKey:@"M"];
    [self sendRequest];
}

- (void) getAllStarsWithNextPage:(int)nextPage;
{
    [self.params setObject:@"People.Get" forKey:@"M"];
    [self.params setObject:[NSString stringWithFormat:@"%d",nextPage] forKey:@"P"];
    [self sendRequest];
}

- (void) readStar:(int)starId
{
    [self.params setObject:@"Person.Read" forKey:@"M"];
    [self.params setObject:@"Id" forKey:[NSString stringWithFormat:@"%d",starId]];
    [self sendRequest];
}

- (void) setStarFavored:(int)starId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Person.Favorite" forKey:@"M"];
    [self.params setObject:@"Id" forKey:[NSString stringWithFormat:@"%d",starId]];
    [self sendRequest];
}

- (void) cancelStarFaved:(int)starId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Person.UnFavorite" forKey:@"M"];
    [self.params setObject:@"Id" forKey:[NSString stringWithFormat:@"%d",starId]];
    [self sendRequest];
}

- (void) likeStar:(int)starId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Person.Like" forKey:@"M"];
    [self.params setObject:@"Id" forKey:[NSString stringWithFormat:@"%d",starId]];
    [self sendRequest];
}

- (void) unlikeStar:(int)starId
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Person.UnLike" forKey:@"M"];
    [self.params setObject:@"Id" forKey:[NSString stringWithFormat:@"%d",starId]];
    [self sendRequest];
}

@end
