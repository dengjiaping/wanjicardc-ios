//
//  WJShareManager.m
//  WanJiCard
//
//  Created by XT Xiong on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJShareManager.h"

#import "QQApiManager.h"
#import "WXApiManager.h"
#import "WBApiManager.h"


#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>


@implementation WJShareManager

+ (void)initShareEnviroment
{
    //注册微信
    [WXApi registerApp:ShareSDK_WeChat_AppID];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    [WXApi registerAppSupportContentFlag:typeFlag];
    
    //注册QQ
    TencentOAuth *oauth = [[TencentOAuth alloc] initWithAppId:ShareSDK_QQ_AppID andDelegate:[QQApiManager sharedManager]];
    if ([oauth isSessionValid]) {
        NSLog(@"重新登录");
    }
    //注册微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:ShareSDK_Weibo_AppID];

}

+ (void)shareHandleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        [QQApiInterface handleOpenURL:url delegate:[QQApiManager sharedManager]];
    }else{
        [WeiboSDK handleOpenURL:url delegate:[WBApiManager sharedManager]];
    }
}

+ (void)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    NSString * sourceApplication = [options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]) {
        [QQApiInterface handleOpenURL:url delegate:[QQApiManager sharedManager]];
    }else{
        [WeiboSDK handleOpenURL:url delegate:[WBApiManager sharedManager]];
    }
}

@end
