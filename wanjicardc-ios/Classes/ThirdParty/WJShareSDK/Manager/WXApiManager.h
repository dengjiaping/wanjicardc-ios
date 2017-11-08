//
//  WXApiManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiMangerDelegate <NSObject>

@optional

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic,assign)id<WXApiMangerDelegate>delegate;

+ (instancetype)sharedManager;

@end
