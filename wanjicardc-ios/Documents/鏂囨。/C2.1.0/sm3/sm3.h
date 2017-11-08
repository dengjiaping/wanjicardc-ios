//
//  sm33.h
//  SM3
//
//  Created by Angie on 15/11/5.
//  Copyright © 2015年 Angie. All rights reserved.
//

#ifndef sm33_h
#define sm33_h

#define IsLittleEndian() (NSHostByteOrder() == CFByteOrderLittleEndian)//(*(char *)&endianTest == 1)


#include <stdio.h>


#define SM3_HASH_SIZE 32

/*
 * SM3上下文
 */
typedef struct SM3Context
{
    unsigned int intermediateHash[SM3_HASH_SIZE / 4];
    unsigned char messageBlock[64];
} SM3Context;


/**
 *  检测大小端
 *
 *  @return 真假
 */
int CheckCPUIsLittleEndian();


/*
 * SM3计算函数
 */
unsigned char *SM3Calc(const unsigned char *message,
                       unsigned int messageLen, unsigned char *digest);


#endif /* sm33_h */
