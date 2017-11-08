//
//  WJPayCompleteModel.m
//  WanJiCard
//
//  Created by Angie on 15/11/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJPayCompleteModel.h"

NSString * const kOrderNumber   = @"pn";
NSString * const kOrderAmount   = @"am";
NSString * const kMerId         = @"mi";
NSString * const kMerName       = @"mn";


@implementation WJPayCompleteModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.orderNo = ToString(dic[@"pn"]);
        self.amount = ToString(dic[@"am"]);
        self.merId = ToString(dic[@"mi"]);
        self.merName = ToString(dic[@"mn"]);
    }
    return self;
}



@end
