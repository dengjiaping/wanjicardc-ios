//
//  WJOrderDetailModel.m
//  WanJiCard
//
//  Created by Angie on 15/9/26.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOrderDetailModel.h"
#import "PayPrivilegeModel.h"

@implementation WJOrderDetailModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.orderInfo = [[WJOrderModel alloc] initWithDic:dic];
        self.supportStoreCount = [dic[@"merchantNum"] integerValue];
        
        NSMutableArray *arr = [NSMutableArray array ];
        for (NSDictionary *dict in dic[@"SupportStore"]) {
            WJStoreModel *store = [[WJStoreModel alloc] initWithDic:dict];
            [arr  addObject:store];
        }
        self.storeArray = [NSArray arrayWithArray:arr];
        [arr removeAllObjects];

        for (NSDictionary *preivilegeDic in dic[@"privilege"]) {
            PayPrivilegeModel *preivilege = [[PayPrivilegeModel alloc] initWithDic:preivilegeDic];
            [arr addObject:preivilege];
        }
        self.privilegeArray = [NSArray arrayWithArray:arr];
        [arr removeAllObjects];

    }
    return self;
}

@end
