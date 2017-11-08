//
//  WJAppIsInstalled.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/26.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJAppIsInstalled.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"


@implementation WJAppIsInstalled

+ (NSMutableArray *)isAppInstalled
{
    NSMutableArray * shareOrderArray = [NSMutableArray array];
    if ([QQApiInterface isQQInstalled]) {
        [shareOrderArray addObject:@"1"];
    }
    if ([WXApi isWXAppInstalled]) {
        [shareOrderArray addObject:@"2"];
        [shareOrderArray addObject:@"3"];
    }
    if ([WeiboSDK isWeiboAppInstalled]) {
        [shareOrderArray addObject:@"4"];
    }
    
    return shareOrderArray;
}


@end
