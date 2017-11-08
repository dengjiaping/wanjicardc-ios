//
//  APIBaseService.h
//  LESports
//
//  Created by ZhangQibin on 15/6/18.
//  Copyright (c) 2015年 LETV. All rights reserved.
//
//  APIBaseService 其子类需要接受APIBaseServiceProtocol协议

#import <Foundation/Foundation.h>

@protocol APIBaseServiceProtocol <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, copy, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, copy, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, copy, readonly) NSString *offlineApiVersion;
@property (nonatomic, copy, readonly) NSString *onlineApiVersion;

@property (nonatomic, copy, readonly) NSString *onlinePublicKey;
@property (nonatomic, copy, readonly) NSString *offlinePublicKey;

@property (nonatomic, copy, readonly) NSString *onlinePrivateKey;
@property (nonatomic, copy, readonly) NSString *offlinePrivateKey;


@end

@interface APIBaseService : NSObject

@property (nonatomic, copy, readonly) NSString *publicKey;
@property (nonatomic, copy, readonly) NSString *privateKey;
@property (nonatomic, copy, readonly) NSString *apiBaseUrl;
@property (nonatomic, copy, readonly) NSString *apiVersion;

@property (nonatomic, weak) id <APIBaseServiceProtocol> child;

@end