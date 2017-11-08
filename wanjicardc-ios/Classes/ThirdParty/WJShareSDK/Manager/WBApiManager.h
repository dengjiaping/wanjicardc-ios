//
//  WBApiManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"


@protocol WBApiManagerDelegate <NSObject>

@optional
- (void)WBMangerDidRecvGetMessageResponse:(WBBaseResponse *)response;

@end

@interface WBApiManager : NSObject <WeiboSDKDelegate>

@property (nonatomic,assign)id<WBApiManagerDelegate>delegate;

+ (instancetype)sharedManager;

@end
