//
//  APIURLResponse.h
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APINetworkingConfiguration.h"

@interface APIURLResponse : NSObject
@property (nonatomic, assign, readonly) APIURLResponseStatus status;
@property (nonatomic, copy, readonly) id content;

- (instancetype)initWithResponseData:(NSData *)responseData status:(APIURLResponseStatus)status;
- (instancetype)initWithResponseData:(NSData *)responseData error:(NSError *)error;
- (instancetype)initWithData:(NSData *)data;

@end

