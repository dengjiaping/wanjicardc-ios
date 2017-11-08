//
//  APIRequestGenerator.h
//  LESports
//
//  Created by ZhangQibin on 15/6/23.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
