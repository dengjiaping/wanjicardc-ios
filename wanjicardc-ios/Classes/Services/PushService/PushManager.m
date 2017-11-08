//
//  PushManager.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/1.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "PushManager.h"
#import <UserNotifications/UserNotifications.h>

@implementation PushManager

+ (void)instancePushManager:(NSDictionary *)launchOptions
{
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert
                       | UNAuthorizationOptionBadge
                       | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
    } 
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"d2f77b2df01f88593cfe53f9"
                          channel:@"App Store"
                 apsForProduction:YES];

}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    [PushManager setPushToken:deviceToken];
}

+ (void)setPushToken:(NSData *)pushToken{
    
    NSString *deviceTokenStr = [[pushToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr==%@",deviceTokenStr);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"currentPushToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];
}

#pragma mark - Push setting

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
}


+ (void)setTags:(NSSet *)tags
          alias:(NSString *)alias
callbackSelector:(SEL)cbSelector
         object:(id)theTarget
{
    [JPUSHService setTags:tags alias:alias callbackSelector:cbSelector object:theTarget];
}

+ (void)setTags:(NSSet *)tags
callbackSelector:(SEL)cbSelector
         object:(id)theTarget
{
    [JPUSHService setTags:tags callbackSelector:cbSelector object:theTarget];
}

+ (void)setAlias:(NSString *)alias
callbackSelector:(SEL)cbSelector
          object:(id)theTarget
{
    [JPUSHService setAlias:alias callbackSelector:cbSelector object:theTarget];
}

+ (NSSet *)filterValidTags:(NSSet *)tags
{
    return [JPUSHService filterValidTags:tags];
}


+ (BOOL)setBadge:(NSInteger)value
{
   return [JPUSHService setBadge:value];
}

+ (void)resetBadge
{
    [JPUSHService resetBadge];
}

+ (NSString *)registrationID
{
    return [JPUSHService registrationID];
}

+ (void)setDebugMode
{
    [JPUSHService setDebugMode];
}

+ (void)setLogOFF
{
    [JPUSHService setLogOFF];
}

@end
