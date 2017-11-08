//
//  SM3.h
//  WanJiCard
//
//  Created by Angie on 15/10/20.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IsLittleEndian() (NSHostByteOrder() == CFByteOrderLittleEndian)//(*(char *)&endianTest == 1)

@interface SM3 : NSObject

#define SM3_HASH_SIZE 32

/*
 * SM3上下文
 */
typedef struct SM3Context
{
    unsigned int intermediateHash[SM3_HASH_SIZE / 4];
    unsigned char messageBlock[64];
} SM3Context;

/*
 * SM3计算函数
 */
unsigned char *SM3Calc(const unsigned char *message,
                       unsigned int messageLen, unsigned char digest[SM3_HASH_SIZE]);


@end
