//
//  WJCrashManager.h
//  BuglyTest
//
//  Created by 孙明月 on 15/11/3.
//  Copyright © 2015年 SMY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJCrashManager : NSObject

@property (nonatomic, copy) void (^buglyBlock)(void);

+ (instancetype)sharedCrashManager;

#pragma mark -
/**
 *    @brief  初始化SDK接口并启动崩溃捕获上报功能
 *
 *    @param appId 应用标识, 在平台注册时分配的应用标识
 *
 *    @return
 */
- (void)installWithAppId:(NSString *)appId;

- (void)changeUserId;

@end
