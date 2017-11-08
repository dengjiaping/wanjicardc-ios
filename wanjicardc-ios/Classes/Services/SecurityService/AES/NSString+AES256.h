//
//  NSString+AES256.h
//  WanJiCard
//
//  Created by wangzhangjie on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AES.h"

@interface NSString (AES256)

-(NSString *) aes256_encrypt:(NSString *)key;
-(NSString *) aes256_decrypt:(NSString *)key;

@end
