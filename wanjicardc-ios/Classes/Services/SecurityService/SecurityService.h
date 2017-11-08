//
//  SecurityService.h
//  WanJiCard
//
//  Created by Lynn on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityService : NSObject


#pragma mark - AES
////将string转换成加密后的data(自定义密码)
//+ (NSData*)encryptAESData:(NSString*)string;
////将加密后的data转成string(自定义密码)
//+ (NSString*)decryptAESData:(NSData*)data;

#pragma mark - MD5
+(NSString *) md5ForString:(NSString *)string;
+(NSString *) md5ForFileContent:(NSString *)filePath;
+(NSString *) md5ForData:(NSData *)data;


#pragma mark - Base64
+ (NSString *)base64WithString:(NSString *)originStr;

+ (NSString *)stringWithBase64Str:(NSString *)base64Str;

#pragma mark - SHA1

+ (NSString *)getSha1String:(NSString *)string;

+ (NSString *)getSha256String:(NSString *)string;

+ (NSString *)getSha384String:(NSString *)string;

+ (NSString *)getSha512String:(NSString *)string;

@end
