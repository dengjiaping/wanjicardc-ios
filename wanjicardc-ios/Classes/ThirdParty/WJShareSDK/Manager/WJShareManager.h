//
//  WJShareManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

#import "WeiboSDK.h"

@interface WJShareManager : NSObject

+ (void)initShareEnviroment;

+ (void)shareHandleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

+ (void)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;

@end
