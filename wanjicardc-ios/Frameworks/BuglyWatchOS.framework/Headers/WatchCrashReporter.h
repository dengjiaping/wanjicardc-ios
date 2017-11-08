//
//  WatchCrashReporter.h
//  Bugly
//
//  Created by Ben Xu on 15/11/06.
//  Copyright (c) 2015年 tencent.com. All rights reserved.
//
//  Bugly WatchOS SDK Version 1.0
#import <Foundation/Foundation.h>

extern NSString const * WatchCrashReporterVersion;

@interface WatchCrashReporter : NSObject

/**
 *    @brief  初始化 Bugly WatchCrashReporter 崩溃上报 (通过 WatchConnectivity.framework 传输数据)
 *
 *            初始化方法：
 *            在 ExtensionDelegate 的 applicationDidFinishLaunching 方法中调用
 */
+ (BOOL)start;

/**
 *    @brief  设置是否开启打印 SDK 的 log 信息，默认关闭。在初始化方法之前调用
 *
 *    @param enable 设置为YES，则打印sdk的log信息，在Release产品中请务必设置为NO
 */
+ (void)enableLog:(BOOL)enable;

@end
