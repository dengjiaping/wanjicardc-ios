//
//  WJMyCardPackageDetailModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/13.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyCardPackageDetailModel.h"
#import "PayPrivilegeModel.h"

@implementation WJMyCardPackageDetailModel

- (id)initWithDic:(NSDictionary *)dic{
    self.ad = ToString(dic[@"ad"]);
    self.balance = [dic[@"balance"] floatValue];
    self.cType = (CardBgType)[dic[@"cardColor"] integerValue];
    self.cardLogo = dic[@"cardLogo"];
    self.cardName = dic[@"cardName"];
    self.merchantId = ToString(dic[@"merchantId"]);
    self.totalRecharge = ToString(dic[@"totalRecharge"]);
    
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary *preivilegeDic in dic[@"privilege"]) {
        PayPrivilegeModel*preivilege = [[PayPrivilegeModel alloc] initWithDic:preivilegeDic];
        [results addObject:preivilege];
    }
    self.privilegeArray = [NSArray arrayWithArray:results];
    
    return self;
}

@end
