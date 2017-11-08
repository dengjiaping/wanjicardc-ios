//
//  WJBillModel.m
//  WanJiCard
//
//  Created by reborn on 16/11/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBillModel.h"

@implementation WJBillModel
- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.billId = ToString(dic[@"orderId"]);
        self.billNo = ToString(dic[@"orderNo"]);
        self.billStatus = (BillStatus)[dic[@"status"] intValue];
        self.statusName = ToString(dic[@"StatusName"]);
        self.receiveAmount =  ToString(dic[@"accountMoney"]);
        self.fee = ToString(dic[@"charge"]);
        self.deductedChannel = ToString(dic[@"channelName"]);
        self.createTime = ToString(dic[@"crtTime"]);
        
    }
    return self;
}

@end
