//
//  SecurityService.m
//  WanJiCard
//
//  Created by Lynn on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "SecurityService.h"
#import "NSString+MD5.h"
#import "NSString+SHA.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SecurityService

//#pragma mark - AES加密
////将string转成带密码的data
//+(NSData*)encryptAESData:(NSString*)string {
//    //将nsstring转化为nsdata
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    //使用密码对nsdata进行加密
//    NSData *encryptedData = [data AES256EncryptWithKey:Encryt_Key];
//    return encryptedData;
//}
//
////将带密码的data转成string
//+(NSString*)decryptAESData:(NSData*)data {
//    //使用密码对data进行解密
//    NSData *decryData = [data AES256DecryptWithKey:Encryt_Key];
//    //将解了密码的nsdata转化为nsstring
//    NSString *string = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
//    return string;
//}

#pragma mark - MD5加密

+(NSString *) md5ForString:(NSString *)string {
    return [string md5Encrypt];
}

+(NSString *) md5ForFileContent:(NSString *)filePath {
    
    if (nil == filePath) {
        return nil;
    }
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    return [[self class]  md5ForData:data];
}

+(NSString *) md5ForData:(NSData *)data {
    
    if (!data || ![data length]) {
        return nil;
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([data bytes], (CC_LONG)[data length], result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

#pragma mark - BASE64
//base64解码
+ (NSString *)base64WithString:(NSString *)originStr
{
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:originStr options:0];
    
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
//    NSLog(@"decodeStr = %@",decodeStr);
    return decodeStr;
}


//base64编码
+ (NSString *)stringWithBase64Str:(NSString *)base64Str
{
    NSData* originData = [base64Str dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
//    NSLog(@"encodeResult:%@",encodeResult);
    return encodeResult;
}

#pragma mark - SHA1
+ (NSString *)getSha1String:(NSString *)string
{
    return [string getSha1String];
}

+ (NSString *)getSha256String:(NSString *)string
{
    return  [string getSha256String];
}

+ (NSString *)getSha384String:(NSString *)string
{
    return  [string getSha384String];
}

+ (NSString *)getSha512String:(NSString *)string
{
    return [string getSha512String];
}


@end
