//
//  WJCouponModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCouponModel.h"

@implementation WJCouponModel

- (id)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.available = [ToNSNumber([dic objectForKey:@"available"]) boolValue];
        self.couponCode = ToString(dic[@"couponCode"]);
        self.couponEndDate = ToString(dic[@"couponEndDate"]);
        self.couponIntroduce = ToString(dic[@"couponIntroduce"]);
        self.couponName = ToString(dic[@"couponName"]);
        self.couponVal = [dic[@"couponValue"] floatValue];
        self.date_available = [ToNSNumber([dic objectForKey:@"date_available"]) boolValue];
        self.userCouponId = ToString(dic[@"userCouponId"]);
        
    }
    return self;
}

@end
