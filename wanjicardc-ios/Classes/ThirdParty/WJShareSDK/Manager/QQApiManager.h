//
//  QQApiManager.h
//  WanJiCard
//
//  Created by XT Xiong on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>



@interface QQApiManager : NSObject<QQApiInterfaceDelegate>

+ (instancetype)sharedManager;

@end
