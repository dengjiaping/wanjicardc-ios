//
//  APIProxy.h
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIURLResponse.h"

typedef void(^APICallBack) (APIURLResponse *response);

@interface APIProxy : NSObject

+ (instancetype)sharedInstance;

- (void)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(APICallBack)success fail:(APICallBack)fail;
- (void)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(APICallBack)success fail:(APICallBack)fail;


@end
