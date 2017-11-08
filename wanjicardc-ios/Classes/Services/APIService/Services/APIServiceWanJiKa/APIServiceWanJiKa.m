//
//  APIServiceLESports.m
//  LESports
//
//  Created by ZhangQibin on 15/6/22.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "APIServiceWanJiKa.h"
#import "WJGlobalVariable.h"

@implementation APIServiceWanJiKa
#pragma mark - AIFServiceProtocal
- (BOOL)isOnline
{
    return YES;
}

- (NSString *)onlineApiBaseUrl
{
    if ([WJGlobalVariable serverBaseUrlIsTest])
    {
//        return @"http://123.56.253.122/wjapp_mobile/card";
        
        return @"https://apptest.wjika.com/wjapp_mobile/card";
    }
    
    return @"https://mobilecardc.wjika.com/wjapp_mobile/card";
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";
}

- (NSString *)offlineApiBaseUrl
{
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion
{
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey
{
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey
{
    return self.onlinePublicKey;
}

@end
