//
//  NSString+CoculationSize.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CoculationSize)

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size;

//判断改字符串是否为手机号
- (BOOL)isMobilePhoneNumber;

//判断字符串是否是正确的身份证号
- (BOOL)isIDCardNumber;

//判断字符串是否是有效的银行卡号
- (BOOL)isBankCardID;


- (NSString *)EncodeUTF8Str;

- (NSString *)chinaString:(NSString *)utfString;

- (NSString *)macCodeFormaterWithString;

- (NSString *)stringByReversed;

@end

