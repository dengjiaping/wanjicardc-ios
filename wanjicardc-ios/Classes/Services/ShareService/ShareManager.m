//
//  ShareManager.m
//  WanJiCard
//
//  Created by Angie on 15/11/12.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager


#pragma mark - ShareSDK
+ (void)initShareSDKEnviroment{
    
    
//    [ShareSDK registerApp:ShareSDK_AppKey
//          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
//                            @(SSDKPlatformSubTypeWechatTimeline),
//                            @(SSDKPlatformSubTypeQQFriend),
//                            @(SSDKPlatformTypeSinaWeibo)]
//                 onImport:^(SSDKPlatformType platformType) {
//                     
//                     switch (platformType)
//                     {
//                         case SSDKPlatformTypeWechat:
//                             [ShareSDKConnector connectWeChat:[WXApi class]];
//                             break;
//                             
//                         case SSDKPlatformTypeQQ:
//                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                             break;
//                             
//                         case SSDKPlatformTypeSinaWeibo:
//                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                             break;
//                             
//                         default:
//                             break;
//                     }
//                     
//                 }
//     
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//              
//              switch (platformType)
//              {
//                  case SSDKPlatformTypeSinaWeibo:
//                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                      [appInfo SSDKSetupSinaWeiboByAppKey:ShareSDK_Weibo_AppID
//                                                appSecret:ShareSDK_Weibo_AppSecret
//                                              redirectUri:@"http://www.wjika.com"
//                                                 authType:SSDKAuthTypeBoth];
//                      break;
//                      
//                  case SSDKPlatformTypeWechat:
//                      [appInfo SSDKSetupWeChatByAppId:ShareSDK_WeChat_AppID
//                                            appSecret:ShareSDK_WeChat_Secret];
//                      break;
//                      
//                  case SSDKPlatformTypeQQ:
//                      [appInfo SSDKSetupQQByAppId:ShareSDK_QQ_AppID
//                                           appKey:ShareSDK_QQ_AppKey
//                                         authType:SSDKAuthTypeBoth];
//                      break;
//                      
//                      
//                  default:
//                      break;
//              }
//              
//          }];
}


@end
