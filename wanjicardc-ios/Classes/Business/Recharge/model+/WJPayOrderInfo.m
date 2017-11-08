//
//  WJPayOrderInfo.m
//  WanJiCard
//
//  Created by Angie on 15/9/9.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJPayOrderInfo.h"

@implementation WJPayOrderInfo
/*
 "Mername": "万集",//商户名称
 "Cover": "http://localhost:25325//Assets/img/upload/merchant/2/x5yO28EhDi.png",//商户封面
 “CardBalance”://卡包余额,
 “Cardname”://卡名称,
 “Ctype”:1 //颜色
 "Amount": 100.00,//订单金额
 "Status": 30,//订单状态： 10 未支付，30支付完成 40 已退款 70系统关闭
 "Paymentno": "KXF150731000140"//订单号
 */
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.orderId = ToString( dic[@"Paymentno"]);
        self.merName = ToString(dic[@"Mername"]);
        self.merCover = ToString(dic[@"Cover"]);
        self.cardName = ToString(dic[@"Cardname"]);
        self.payAmount = [dic[@"Amount"] floatValue];
        self.balance = [dic[@"CardBalance"] floatValue];
        self.cType = (CardBgType)[dic[@"Ctype"] intValue];
        self.orderStatus = (OrderStatus)[dic[@"Status"] intValue];
    }
    return self;
}

@end
