//
//  WJStatisticsManager.m
//  UMAnalytics_Sdk_Demo
//
//  Created by 孙明月 on 15/11/9.
//
//

#import "WJStatisticsManager.h"

@implementation WJStatisticsManager
+ (instancetype)sharedStatisManager{
    static WJStatisticsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJStatisticsManager alloc] init];
    });
    return instance;
}

- (void)setAppVersion:(NSString *)appVersion
{
    [MobClick setAppVersion:appVersion];
}

- (void)setCrashReportEnabled:(BOOL)value
{
    [MobClick setCrashReportEnabled:value];
}

- (void)setLogEnabled:(BOOL)value
{
    [MobClick setLogEnabled:value];
}

- (void)setBackgroundTaskEnabled:(BOOL)value
{
    [MobClick setBackgroundTaskEnabled:value];
}

- (void)setEncryptEnabled:(BOOL)value
{
    [MobClick setEncryptEnabled:value];
}

- (void)startWithAppkey:(NSString *)appKey
{
    UMConfigInstance.appKey = appKey;
}

- (void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid
{
    UMConfigInstance.appKey = appKey;
    UMConfigInstance.ePolicy = rp;
    UMConfigInstance.channelId = cid;
}

- (void)setLogSendInterval:(double)second
{
    [MobClick setLogSendInterval:second];
}


- (void)setLatency:(int)second
{
    [MobClick setLatency:second];
}

- (void)logPageView:(NSString *)pageName seconds:(int)seconds
{
    [MobClick logPageView:pageName seconds:seconds];
}

- (void)beginLogPageView:(NSString *)pageName
{
    [MobClick beginLogPageView:pageName];
}

- (void)endLogPageView:(NSString *)pageName
{
    [MobClick endLogPageView:pageName];
}

- (void)event:(NSString *)eventId{
    
    [MobClick event:eventId];
}

- (void)event:(NSString *)eventId label:(NSString *)label{
    [MobClick event:eventId label:label];
}

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    [MobClick event:eventId attributes:attributes];
}

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number
{
    [MobClick event:eventId attributes:attributes counter:number];
}

- (void)beginEvent:(NSString *)eventId
{
    [MobClick beginEvent:eventId];
}

- (void)endEvent:(NSString *)eventId
{
    [MobClick endEvent:eventId];
}

- (void)beginEvent:(NSString *)eventId label:(NSString *)label
{
    [MobClick beginEvent:eventId label:label];
}

- (void)endEvent:(NSString *)eventId label:(NSString *)label
{
    [MobClick endEvent:eventId label:label];
}

- (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes
{
    [MobClick beginEvent:eventId primarykey:keyName attributes:attributes];
}

- (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName
{
    [MobClick endEvent:eventId primarykey:keyName];
}

- (void)event:(NSString *)eventId durations:(int)millisecond
{
    [MobClick event:eventId durations:millisecond];
}

- (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond
{
    [MobClick event:eventId label:label durations:millisecond];
}

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond
{
    [MobClick event:eventId attributes:attributes durations:millisecond];
}

- (void)profileSignInWithPUID:(NSString *)puid
{
    [MobClick profileSignInWithPUID:puid];
}
- (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider
{
    [MobClick profileSignInWithPUID:puid provider:provider];
}

- (void)profileSignOff
{
    [MobClick profileSignOff];
}

- (void)updateOnlineConfig
{
//    [MobClick updateOnlineConfig];
}

- (NSString *)getConfigParams:(NSString *)key
{
    return nil;//[MobClick getConfigParams:key];
}

- (NSDictionary *)getConfigParams
{
    return nil;//[MobClick getConfigParams];
}

- (void)setLatitude:(double)latitude longitude:(double)longitude
{
    [MobClick setLatitude:latitude longitude:longitude];
}

- (void)setLocation:(CLLocation *)location
{
    [MobClick setLocation:location];
}
- (BOOL)isJailbroken
{
   return [MobClick isJailbroken];
}

- (BOOL)isPirated
{
  return [MobClick isPirated];
}



- (void)startSession:(NSNotification *)notification
{
    [MobClick startSession:notification];
}

- (NSString *)getAdURL
{
    return nil;//[MobClick getAdURL];
}
@end
