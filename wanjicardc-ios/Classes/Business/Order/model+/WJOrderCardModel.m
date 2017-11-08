//
//  WJOrderCardModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrderCardModel.h"
#import "WJCouponModel.h"
#import "WJTicketModel.h"

@implementation WJOrderCardModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.canBuyNum = [ToString([dic objectForKey:@"canBuyNum"]) integerValue];
        self.code = ToString([dic objectForKey:@"code"]);
        self.discount = [ToNSNumber([dic objectForKey:@"discount"]) floatValue];
        self.ecoEnable = [ToNSNumber([dic objectForKey:@"ecoEnable"]) boolValue];
        
        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *preivilegeDic in dic[@"userCoupons"]) {
//            WJCouponModel *preivilege = [[WJCouponModel alloc] initWithDic:preivilegeDic];
            WJTicketModel *preivilege = [[WJTicketModel alloc] initWithDic:preivilegeDic];
            [results addObject:preivilege];
        
        }
        self.couponArray = [NSArray arrayWithArray:results];
    }
    return self;
}

@end
