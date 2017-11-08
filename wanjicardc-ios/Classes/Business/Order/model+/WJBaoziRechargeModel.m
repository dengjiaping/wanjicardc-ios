//
//  WJBaoziRechargeModel.m
//  WanJiCard
//
//  Created by 孙明月 on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaoziRechargeModel.h"

@implementation WJBaoziRechargeModel
- (id)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.moneyID = ToString([dic objectForKey:@"id"]);
        self.baoziAmount = ToString([dic objectForKey:@"baoziAmount"]);
        self.describe = ToString([dic objectForKey:@"describe"]);
        self.rechargeAmount = [ToNSNumber([dic objectForKey:@"rechargeAmount"]) floatValue];
        self.successdescribe = ToString([dic objectForKey:@"successdescribe"]);
        self.newdescribe = ToString([dic objectForKey:@"newdescribe"]);
    }
    return self;
}



@end
