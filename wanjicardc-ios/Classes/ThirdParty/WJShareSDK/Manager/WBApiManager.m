//
//  WBApiManager.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WBApiManager.h"
#import "WJSystemAlertView.h"

@implementation WBApiManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WBApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WBApiManager alloc]init];
    });
    return instance;
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if((int)response.statusCode == 0){
        //分享成功
        [self alertShow];

        if (_delegate && [_delegate respondsToSelector:@selector(WBMangerDidRecvGetMessageResponse:)]) {
            [_delegate WBMangerDidRecvGetMessageResponse:response];
        }
    }
}

- (void)alertShow
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
    [alert showIn];
}

@end
