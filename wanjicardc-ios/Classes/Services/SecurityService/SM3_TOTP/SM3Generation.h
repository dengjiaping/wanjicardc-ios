//
//  SM3_TOTP_Algorithm.h
//  WanJiCard
//
//  Created by Angie on 15/10/20.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SM3Generation : NSObject


/**
 *  SM3_TOTP算法
 *
 *  @param currentTime 当前时间戳
 *  @param during      口令变化周期
 *  @param TokenLength 口令长度， 6/8位数字
 *
 *  @return 口令
 */
+ (NSString *)getTokenWithSM3TOTP:(unsigned int)currentTime
                tokenChangeDuring:(unsigned int)during
                           priKey:(NSString *)key
                      tokenLength:(int)TokenLength;

@end
