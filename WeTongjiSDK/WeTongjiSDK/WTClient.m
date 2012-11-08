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
    [self.params setObject:userJSONStr forKey:@"User"];
    [self sendRequest];
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

- (void)updateUserAvatar:(UIImage *)image
{
#warning lots of work to do 
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
{
    [self.params setObject:@"Activities.Get" forKey:@"M"];
    if (channelId) [self.params setObject:channelId forKey:@"Channel_Ids"];
    if (sort) [self.params setObject:sort forKey:@"Sort"];
    if (isExpired) [self.params setObject:[NSString stringWithFormat:@"%d", isExpired] forKey:@"Expire"];
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

- (void) getFavorites
{
    [self.params setObject:[NSUserDefaults getCurrentUserID] forKey:@"U"];
    [self.params setObject:[NSUserDefaults getCurrentUserSession] forKey:@"S"];
    [self.params setObject:@"Favorite.Get" forKey:@"M"];
    [self sendRequest];
}

- (void) getAllInformationInSort:(NSString *) sort
{
    [self.params setObject:@"Information.GetList" forKey:@"M"];
    if ( sort ) [self.params setObject:sort forKey:@"Sort"];
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

- (void) getAllStars
{
    [self.params setObject:@"People.Get" forKey:@"M"];
    [self sendRequest];
}

@end
