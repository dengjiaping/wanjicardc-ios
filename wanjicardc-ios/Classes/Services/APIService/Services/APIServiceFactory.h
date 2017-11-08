//
//  APIServiceFactory.h
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//
//  APIServiceFactory 工厂类

#import <Foundation/Foundation.h>
#import "APIBaseService.h"

@interface APIServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (APIBaseService <APIBaseServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
