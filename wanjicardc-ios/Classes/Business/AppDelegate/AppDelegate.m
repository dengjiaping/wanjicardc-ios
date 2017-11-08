//
//  AppDelegate.m
//  WanJiCard
//
//  Created by zOne on 15/8/26.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "AppDelegate.h"

#import "WJSqliteBaseManager.h"
#import "WJSqliteUserManager.h"

#import "Reachability.h"
#import "PushManager.h"
#import "LocationManager.h"
#import "TimeSynchronousManager.h"
#import "WJShareManager.h"
#import "WJCrashManager.h"
#import "CheckUpdateManager.h"
#import "WJStatisticsManager.h"

#import "WJLoginViewController.h"
#import "WJUserGuideViewController.h"


#import "WJPayCompleteController.h"

#import "WJWatchAPIRequestService.h"

#import <WatchConnectivity/WCSession.h>
#import <UserNotifications/UserNotifications.h>
//#import <Bugly/Bugly.h>
//#import <CoreImage/CoreImage.h>
//#import <CoreGraphics/CoreGraphics.h>

#import "SM3Generation.h"
#import "APISearchManager.h"

#import "WJMerchantDetailController.h"

#import "WJUpgradeAlert.h"
#import "CreatQRCodeAndBarCodeFromLeon.h"
#import "WJDBAreaManager.h"

#import <ZXingObjC/ZXingObjC.h>
#import "SSKeychain.h"

#import "WJAdvertiseViewController.h"
#import "WJVerificationReceiptMoneyController.h"

#import <BaiduMapAPI_Base/BMKMapManager.h>


@interface AppDelegate () <WCSessionDelegate,WJUpgradeAlertDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{

    Reachability *currentReachability;
    TimeSynchronousManager *timeSynchronousManager;
    
    BOOL isFirstLoadAfterInstalled;
    WJWatchAPIRequestService *watchService;
    
    NSMutableData * receiveData;
    NSString *trackViewURL;
    
    BOOL activityIsOpen;        //是否开启广告位
    
    BMKMapManager * _mapManager;

}


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    isCorrectedBundleId;

    NSLog(@"NSHomeDirectory -- %@", NSHomeDirectory());
    isFirstLoadAfterInstalled = [WJUtilityMethod whetherIsFirstLoadAfterInstalled] && [[WJSqliteUserManager sharedManager] status];
    activityIsOpen = YES;
    
    [WJGlobalVariable sharedInstance].currentID = [WJUtilityMethod keyChainValue:isFirstLoadAfterInstalled];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appUpdate:)
                                                 name:@"kAppNeedUpdate"
                                               object:nil];
    [self initDatabase];

    [self initApplication];

    [[LocationManager sharedInstance] initCoreLoacation];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([WCSession isSupported]) {
//           wcSession = [WCSession defaultSession];
//           wcSession.delegate = self;
//           [wcSession activateSession];
//        }
//       
//    });
    
    [self initBugly];

   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myTab = [[WJTabBarViewController alloc] init];
    
    //判断是不是第一次启动应用
    if(isFirstLoadAfterInstalled)
    {
        //如果是第一次启动的话,使用 (用户引导页面) 作为根视图
        WJUserGuideViewController *userGuideViewController = [[WJUserGuideViewController alloc] init];
        WJNavigationController * rootNav = [[WJNavigationController alloc] initWithRootViewController:userGuideViewController];
        userGuideViewController.navigationController.navigationBar.hidden = YES;
        self.window.rootViewController = rootNav;
    }
    else
    {
        if (activityIsOpen) {
            //如果不是第一次启动的话,使用广告位作为根视图
            WJAdvertiseViewController *advertiseVC = [[WJAdvertiseViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:advertiseVC];
            self.window.rootViewController = nav;
            
        }else{
        
            
            self.window.rootViewController = self.myTab;
        }
    }
    
    [self.window makeKeyAndVisible];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

#ifdef DEBUG
        
#else
        //检查版本
        [CheckUpdateManager checkAppUpdate];
#endif

        //分享
        [self initSDKInfomation];
        
        //接入友盟
        [self initUMAnalytic];
        
        //接入百度地图
        [self initBaiduMap];
        
        //接入推送
        [self initPushNotification:launchOptions];

        //3D Touch
        [self init3DTouchWithApplication:application launchOptions:launchOptions];
        

    });
    
    return YES;
}

#pragma mark - Init


- (void)init3DTouchWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    
    if (SystemVersionGreaterOrEqualThan(9.0)) {
        
        //  通过这个键值，我们可以区别是否是从标签进入的app，如果是，则处理结束逻辑后，返回NO，防止处理逻辑被反复回调。
        if (nil != launchOptions) {
            NSDictionary *pushNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
            if (nil != pushNotification) {
                
            }
        }
    }
   
}

- (void)initBaiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"NxvNYsGtBuQFAwbtGBd4Uro1eMdARv0h"  generalDelegate:nil];
    
    if (!ret) {
        NSLog(@"BaiduMap manager start failed!");
    }
}


- (void)initBugly
{
    [[WJCrashManager sharedCrashManager] installWithAppId:@"900007537"];
}

- (void)initUMAnalytic{

    //关闭，因为使用bugly限制
    [[WJStatisticsManager sharedStatisManager] setCrashReportEnabled:NO];
    
    // version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[WJStatisticsManager sharedStatisManager] setAppVersion:version];

    [[WJStatisticsManager sharedStatisManager] startWithAppkey:@"55d3ede4e0f55a2820003325" reportPolicy:BATCH channelId:nil];
    
}

- (void)initPushNotification:(NSDictionary *)launchOptions{
    
    [PushManager instancePushManager:launchOptions];
 
    // apn 内容获取：
    if (nil != launchOptions) {

        NSDictionary *pushNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (nil != pushNotification) {
            //设置badge值，本地仍须调用UIApplication:setApplicationIconBadgeNumber函数
            [PushManager setBadge:0];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

//            NSDictionary *aps = [pushNotification valueForKey:@"aps"];
//            NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容

            //进入结果页
            [self pushControllerByPushNotification:pushNotification withType:1];
        }
    }
}



- (void)initSDKInfomation{
//    [ShareManager initShareSDKEnviroment];
    [WJShareManager initShareEnviroment];
}


- (void)initDatabase{
    if(isFirstLoadAfterInstalled){
        [WJSqliteBaseManager copyBaseData];
        [[WJSqliteUserManager sharedManager] upgradeTables];
    }
}


- (void)initApplication
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChange:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    currentReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [currentReachability startNotifier];


}


- (void)changeRootViewController{
   
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        self.window.rootViewController = self.myTab;
                        [UIView setAnimationsEnabled:oldState];
                        
                        WJUpgradeAlert *alertView = (WJUpgradeAlert *)[self.window viewWithTag:100002];
                        if (alertView) {
                            [self.window bringSubviewToFront:alertView];
                        }

                    }
                    completion:nil];
    
 }


#pragma mark - reachabilityChange

- (void)reachabilityChange:(NSNotification *)notice{
    Reachability *curr = [notice object];

    if ([curr isMemberOfClass:[Reachability class]]) {
        
        NetworkStatus state = [curr currentReachabilityStatus];
        
        switch (state) {
            case NotReachable:{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请检查网络连接"];
            }
                break;
                
            case ReachableViaWiFi:
            case ReachableViaWWAN:
                
                break;
        }
    }
}


#pragma mark - App 更新

- (void)appUpdate:(NSNotification *)notice{

    NSString *newVersion = [[notice userInfo] objectForKey:@"newVersion"];
    trackViewURL = [[notice userInfo] objectForKey:@"trackViewUrl"];

    WJUpgradeAlert *upgradeAlert = [[WJUpgradeAlert alloc]initWithTitle:@"检测到新版本" message:[NSString stringWithFormat:@"V%@",newVersion] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即更新"];
    [upgradeAlert showIn];
    
}


#pragma mark -  3D touch 代理方法

//类似推送，当我们通过标签进入app时，就会在appdelegate中调用这样一个回调，我们可以获取shortcutItem的信息进行相关逻辑操作。
- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    //判断我们设置的唯一标识
    if ([shortcutItem.type isEqualToString:@"pay"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:KTap3DTouchIndex];
        [self.myTab enterFromTouchWithIndex:2];
    }
    
    if ([shortcutItem.type isEqualToString:@"buy"])
    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KTap3DTouchIndex];

        [self.myTab enterFromTouchWithIndex:1];
    }
}


#pragma mark - WJUpgradeAlertDelegate

- (void)wjUpgradeAlert:(WJUpgradeAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
//        NSString *str = @"https://itunes.apple.com/us/app/wan-ji-ka-ji-he-suo-you-you/id1021840697?mt=8&uo=4";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewURL]];
    }
}


#pragma mark - Push Notification


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleLaunchWithapplication:[UIApplication sharedApplication] RemoteNotification:userInfo];
        [PushManager handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleLaunchWithapplication:[UIApplication sharedApplication] RemoteNotification:userInfo];
        [PushManager handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Required
    [PushManager registerDeviceToken:deviceToken];
    
    //设置别名, 有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字
    NSString *uuid = [WJGlobalVariable sharedInstance].currentID;
    NSString * alias = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
  
    [PushManager setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    //返回对应的状态码：0为成功
    if (iResCode == 0) {
        NSLog(@"极光推送 registrationID -- %@", [PushManager registrationID]);
//        NSData *registrationID = [NSKeyedArchiver archivedDataWithRootObject:[PushManager registrationID]];
//        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"JPushRegistrationId"];
    }
}

//说明app的APNS权限问题或者app运行在模拟器
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"registe error ====%@",error);
}

//设备收到一条推送（APNs）, 用户点击推送通知打开应用时，如果 App状态为正在前台或者后台运行，那么此函数将被调用, 在此方法中添加代码以获取apn内容, 并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行，做出相应处理：
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //接到通知后的处理事件
    [self handleLaunchWithapplication:application RemoteNotification:userInfo];
 
    // Required
    [PushManager handleRemoteNotification:userInfo];
    
//    //wzj- iwatch
//    [self registerWatchMsg:userInfo];
}



//使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //接到通知后的处理事件
    [self handleLaunchWithapplication:application RemoteNotification:userInfo];
    
    // IOS 7 Support Required
    [PushManager handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



- (void)handleLaunchWithapplication:(UIApplication*)application RemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"push user id =================%@",userInfo);
    
    //badge置0
    [PushManager setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

//    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    
    //applicationState有3个状态, UIApplicationStateActive(在前端运行),UIApplicationStateInactive(从后台进入前端),UIApplicationStateBackground在后台端运行
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive) {
        //进入结果页
        [self pushControllerByPushNotification:userInfo withType:3-application.applicationState];
    }
}


- (void)pushControllerByPushNotification:(NSDictionary *)pushNotificationUserInfo withType:(NSInteger)category{

    NSInteger type = [pushNotificationUserInfo[@"type"] intValue];
 
    [[NSUserDefaults standardUserDefaults] setObject:@{@"pushType":@(type), @"pushCategory":@(category), @"PushUserInfo":pushNotificationUserInfo} forKey:@"PushArguments"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.myTab receiveNotification];
}


#pragma mark - Handle Url

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    //分享回调
    [WJShareManager shareHandleOpenURL:url sourceApplication:sourceApplication];
    
    if ([sourceApplication rangeOfString:@"alipay"].length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResultCallBack" object:nil userInfo:@{@"userInfo":url}];
    }
    NSLog(@"%@", url);
    return  YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    //分享回调
    [WJShareManager application:app openURL:url options:options];
    
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] rangeOfString:@"alipay"].length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayResultCallBack" object:nil userInfo:@{@"userInfo":url}];
    }
    return YES;
}


#pragma mark - Application cycle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        [PushManager setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        [PushManager setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    [kDefaultCenter postNotificationName:kLocationSettingChange object:nil];
    [kDefaultCenter postNotificationName:@"HomePageRefershData" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        [PushManager setBadge:0];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    }
    timeSynchronousManager = [TimeSynchronousManager new];
    [timeSynchronousManager synchronousTimeWithServer];

    //如果不支持指纹验证，将本地值改成NO
    BOOL isAvail = [WJGlobalVariable touchIDIsAvailable];
    if (!isAvail) {
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key = KFingerIdentySwitch;
     
        if (key) {
            [accountDefaults setBool:NO forKey:key];
        }
    }
 
    //通知安全设置页面指纹信息是否有变动
    [kDefaultCenter postNotificationName:kTouchIDChange object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    WJViewController *vc = [[WJGlobalVariable sharedInstance] realAuthenReciveMoneyfromController];
    
    if ([vc isKindOfClass:[WJVerificationReceiptMoneyController class]]) {
        [WJGlobalVariable sharedInstance].realAuthenReciveMoneyfromController = nil;
        [kDefaultCenter postNotificationName:kRealNameReciveMoneyRecord object:nil];
    }
}


#pragma mark - iWatch API

- (NSString *)getQrString{
    WJModelPerson *person = [WJGlobalVariable sharedInstance].defaultPerson;
    NSString *qrString = nil;
    if (person.token.length == 32 && person.payPassword.length > 18) {
        
        NSString *key = [person.token stringByAppendingString:person.payPassword];
        NSTimeInterval serverTimeSubLocal = [[[NSUserDefaults standardUserDefaults] objectForKey:kServerTimeSubLocal] doubleValue];
        int time = [[NSDate date] timeIntervalSince1970] + serverTimeSubLocal;
        NSString *qrToken = [SM3Generation getTokenWithSM3TOTP:time tokenChangeDuring:5 priKey:[key substringWithRange:NSMakeRange(18, 32)] tokenLength:6];
        
        qrString = [NSString stringWithFormat:@"86%@%@", [person.phone substringFromIndex:1], qrToken];
        
        
    }else{
        qrString = @"nologin";//14个零
    }
    
    return qrString;
}



@end

