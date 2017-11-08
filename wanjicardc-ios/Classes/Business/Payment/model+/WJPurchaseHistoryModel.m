//
//  WJPurchaseHistoryModel.m
//  WanJiCard
//
//  Created by Angie on 15/9/25.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJPurchaseHistoryModel.h"

@implementation WJPurchaseHistoryModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.merId = ToString(dic[@"merchantId"]);
        self.amount = [dic[@"consumerRecoreValue"] floatValue];
        self.merName = ToString(dic[@"merchantName"]);
        self.historyId = ToString(dic[@"consumerRecordId"]);
        self.createTime = ToString(dic[@"cosumerRecordCreateDate"]);
        self.paymentNo = ToString(dic[@"consumerRecoreNo"]);
        self.historyStatus = (OrderStatus)[dic[@"consumerRecordStatus"] integerValue];
        self.userId = ToString(dic[@"userId"]);
        self.userName = ToString(dic[@"Username"]);

//        self.cover = ToString(dic[@"Cover"]);
//        self.consumeCount = [dic[@"Merid"] integerValue];
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSDictionary *dict in dic[@"Consumes"]) {
//            WJConsumeModel *model = [[WJConsumeModel alloc] initWithDic:dict];
//            [arr addObject:model];
//        }
//        self.consumeArray = [NSArray arrayWithArray:arr];
    }
    return self;
}


@end
