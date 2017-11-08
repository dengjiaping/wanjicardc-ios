//
//  PushManager.h
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JPush/JPUSHService.h>

@interface PushManager : NSObject<JPUSHRegisterDelegate>

+ (void)instancePushManager:(NSDictionary *)launchOptions;

#pragma - mark 基本功能
+ (void)registerDeviceToken:(NSData *)deviceToken;  // 向服务器上报Device Token
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;  // 处理收到的APNS消息，向服务器上报收到APNS消息

// 下面的接口是可选的
// 设置标签和(或)别名（若参数为nil，则忽略；若是空对象，则清空；详情请参考文档：http://docs.jpush.cn/pages/viewpage.action?pageId=3309913）

+ (void)setTags:(NSSet *)tags
          alias:(NSString *)alias
callbackSelector:(SEL)cbSelector
         object:(id)theTarget;

+ (void)setTags:(NSSet *)tags
callbackSelector:(SEL)cbSelector
         object:(id)theTarget;

+ (void)setAlias:(NSString *)alias
callbackSelector:(SEL)cbSelector
          object:(id)theTarget;

// 用于过滤出正确可用的tags，如果总数量超出最大限制则返回最大数量的靠前的可用tags
+ (NSSet *)filterValidTags:(NSSet *)tags;

#pragma - mark 设置Badge
/**
 *  set setBadge
 *  @param value 设置JPush服务器的badge的值
 *  本地仍须调用UIApplication:setApplicationIconBadgeNumber函数,来设置脚标
 */
+ (BOOL)setBadge:(NSInteger)value;
/**
 *  set setBadge
 *  @param value 清除JPush服务器对badge值的设定.
 *  本地仍须调用UIApplication:setApplicationIconBadgeNumber函数,来设置脚标
 */

+ (void)resetBadge;

/**
 *  get RegistrationID
 */
+ (NSString *)registrationID;

#pragma - mark 打印日志信息配置
/**
 *  setDebugMode获取更多的Log信息
 *  开发过程中建议开启DebugMode
 *
 *  setLogOFF关闭除了错误信息外的所有Log
 *  发布时建议开启LogOFF用于节省性能开销
 *
 *  默认为不开启DebugLog,只显示基本的信息
 */
+ (void)setDebugMode;
+ (void)setLogOFF;

/**
 *  处理获得的PushToken
 *
 *  @param token <#token description#>
 */
+ (void)setPushToken:(NSData *)pushToken;

@end
