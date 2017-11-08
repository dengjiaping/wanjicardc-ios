//
//  WXApiManager.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WXApiManager.h"
#import "WJSystemAlertView.h"

@implementation WXApiManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc]init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp
{
    if (resp.errCode == 0) {
        [self alertShow];
    }else{
        NSLog(@"微信分享失败 /n errCode:%d /n errStr:%@",resp.errCode,resp.errStr);
    }
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    }
}

- (void)onReq:(BaseReq*)req
{
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    }
}


- (void)alertShow
{
    WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
    [alert showIn];
}

@end
