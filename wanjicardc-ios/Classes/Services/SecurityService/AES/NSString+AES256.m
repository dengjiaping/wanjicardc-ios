//
//  NSString+AES256.m
//  WanJiCard
//
//  Created by wangzhangjie on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "NSString+AES256.h"

@implementation NSString (AES256)

-(NSString *) aes256_encrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data AES256EncryptWithKey:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}

-(NSString *) aes256_decrypt:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data AES256DecryptWithKey:key];
    NSLog(@"retule===%@=",result);
    if (result && result.length > 0) {
        
        NSString * mystr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] ;
        return mystr ;
    }
    return nil;
}

@end
