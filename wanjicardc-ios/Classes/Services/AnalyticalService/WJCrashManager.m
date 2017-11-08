//
//  WJCrashManager.m
//  BuglyTest
//
//  Created by 孙明月 on 15/11/3.
//  Copyright © 2015年 SMY. All rights reserved.
//

#import "WJCrashManager.h"
#import <Bugly/Bugly.h>

@interface WJCrashManager ()<BuglyDelegate>

@end

@implementation WJCrashManager

+ (instancetype)sharedCrashManager{
    static WJCrashManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJCrashManager alloc] init];
    });
    return instance;
}

- (void)installWithAppId:(NSString *)appId{
    [self setConfigWithAppId:appId];
}


- (void)setConfigWithAppId:(NSString *)appid{
    //接入第三方
    
    NSString *buildNO = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    BuglyConfig *config = [BuglyConfig new];
    
    config.channel = @"AppStore";
    config.version = [NSString stringWithFormat:@"%@-%@", WJCardAppVersion,buildNO];
    config.deviceId = [WJGlobalVariable sharedInstance].currentID;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.delegate = self;

    [Bugly startWithAppId:appid config:config];
    
    [BuglyLog initLogger:BuglyLogLevelWarn consolePrint:NO];
    
    [self changeUserId];

}

- (void)changeUserId{
    
    NSString *strUUID = [WJGlobalVariable sharedInstance].currentID;
    
    NSString *userID = nil;
    if ([WJGlobalVariable sharedInstance].defaultPerson.userName) {
        
        userID = [strUUID stringByAppendingString:[WJGlobalVariable sharedInstance].defaultPerson.userName];
    }else{
        
        userID = strUUID;
    }
    NSLog(@"bugly userid ==== %@",userID);

//    [Bugly setUserIdentifier:userID];
}


- (NSString *)attachmentForException:(NSException *)exception{
    return @"exception";
}


@end
