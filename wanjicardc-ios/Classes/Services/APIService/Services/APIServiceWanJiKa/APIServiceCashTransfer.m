//
//  APIServiceCashTransfer.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIServiceCashTransfer.h"

@implementation APIServiceCashTransfer

#pragma mark - AIFServiceProtocal
- (BOOL)isOnline
{
    return YES;
}

- (NSString *)onlineApiBaseUrl
{
    NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:KCashTransferUrl];
    if ([WJGlobalVariable serverBaseUrlIsTest])
    {
        return [NSString stringWithFormat:@"%@/card",urlString];
//        return @"http://123.56.253.122:8080/card";
    }
    return [NSString stringWithFormat:@"%@/card",urlString];
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
