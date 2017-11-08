//
//  WJPayOrderInfo.h
//  WanJiCard
//
//  Created by Angie on 15/9/9.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPayOrderInfo : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *merName;
@property (nonatomic, strong) NSString *cardName;
@property (nonatomic, strong) NSString *merCover;
@property (nonatomic, assign) CardBgType cType;
@property (nonatomic, assign) CGFloat payAmount;        //支付金额
@property (nonatomic, assign) CGFloat balance;          //卡包余额
@property (nonatomic, assign) OrderStatus orderStatus;

- (id)initWithDic:(NSDictionary *)dic;

@end
