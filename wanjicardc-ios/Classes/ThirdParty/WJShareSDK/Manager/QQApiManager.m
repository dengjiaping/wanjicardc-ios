//
//  QQApiManager.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "QQApiManager.h"
#import "WJSystemAlertView.h"

@implementation QQApiManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static QQApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QQApiManager alloc]init];
    });
    return instance;
}

#pragma mark - QQApiInterfaceDelegate
- (void)onResp:(QQBaseResp *)resp
{
    if ([resp.result integerValue] == 0) {
        WJSystemAlertView *alert = [[WJSystemAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil textAlignment:NSTextAlignmentCenter];
        [alert showIn];
    }
    // SendMessageToQQResp应答帮助类
    //    if ([resp.class isSubclassOfClass: [SendMessageToQQResp class]]) {  //QQ分享回应
    //        if (_qqDelegate) {
    //            if ([_qqDelegate respondsToSelector:@selector(shareSuccssWithQQCode:)]) {
    //                SendMessageToQQResp *msg = (SendMessageToQQResp *)resp;
    //                NSLog(@"code %@  errorDescription %@  infoType %@",resp.result,resp.errorDescription,resp.extendInfo);
    //                [_qqDelegate shareSuccssWithQQCode:[msg.result integerValue]];
    //            }
    //        }
    //    }

}

- (void)onReq:(QQBaseReq *)req
{
    
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}


@end
