//
//  NSData+AES.h
//  
//
//  Created by XuanChen on 14-2-27.
//  Copyright (c) 2014年 XuanChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
