//
//  WJCardChangeModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardChangeModel.h"
#import "WJChoiceCardModel.h"
#import "WJTicketModel.h"

@implementation WJCardChangeModel

- (id)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.discount = [ToNSNumber([dic objectForKey:@"discount"]) floatValue];
        self.ecoEnable = [ToNSNumber([dic objectForKey:@"ecoEnable"]) boolValue];

        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *storeDic in dic[@"cards"]) {
            WJChoiceCardModel *store = [[WJChoiceCardModel alloc] initWithDic:storeDic];
            [results addObject:store];
        }
        self.choiceCardArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
        
        for (NSDictionary *preivilegeDic in dic[@"coupon"]) {
//            WJCouponModel *preivilege = [[WJCouponModel alloc] initWithDic:preivilegeDic];
            WJTicketModel *preivilege = [[WJTicketModel alloc] initWithDic:preivilegeDic];
            [results addObject:preivilege];
        }
        self.couponArray = [NSArray arrayWithArray:results];
    }
    return self;
}




@end
