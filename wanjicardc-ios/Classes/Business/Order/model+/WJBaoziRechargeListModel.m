//
//  WJBaoziRechargeListModel.m
//  WanJiCard
//
//  Created by 孙明月 on 16/8/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaoziRechargeListModel.h"
#import "WJBaoziRechargeModel.h"
@implementation WJBaoziRechargeListModel
- (id)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        self.rechargeAgreement = ToString([dic objectForKey:@"rechargeAgreement"]);
        self.ecoEnable = [ToNSNumber([dic objectForKey:@"ecoEnable"]) boolValue];
        
        NSMutableArray *results = [NSMutableArray array];
        
        for (NSDictionary *storeDic in dic[@"bunList"]) {
            WJBaoziRechargeModel *rechargeModel = [[WJBaoziRechargeModel alloc] initWithDic:storeDic];
            [results addObject:rechargeModel];
        }
        self.bunList = [NSArray arrayWithArray:results];
        
    }
    return self;
}


@end
