//
//  WJCardModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardModel.h"
#import "PayPrivilegeModel.h"
@implementation WJCardModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.activityId         = ToString(dic[@"activityId"]);
        self.adString           = dic[@"ad"];
        self.activityName         = dic[@"activityName"];
        self.activityDescription  = dic[@"activityDescription"];
        self.cType              = [dic[@"cardColor"] integerValue];
        self.cardId             = ToString(dic[@"cardId"]);
        self.cardCoverUrl       = dic[@"cardLogo"];
        self.name               = ToString(dic[@"cardName"]);
        self.currentFlag        = ToString(dic[@"currentFlag"]);
        self.faceValue          = ToString(dic[@"faceValue"]);
        self.cardIntroduce      = dic[@"introduce"];
        self.isLimitForSale     = ToString(dic[@"isLimitForSale"]);
        self.merName            = dic[@"merchantName"];
        self.price              = ToString(dic[@"price"]);
        
        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *preivilegeDic in dic[@"privilege"]) {
            
            PayPrivilegeModel *preivilege = [[PayPrivilegeModel alloc] initWithDic:preivilegeDic];
            [results addObject:preivilege];
        }
        self.privilegeArray     = [NSArray arrayWithArray:results];
        self.salePrice          = ToString(dic[@"saleValue"]);
        self.saledNumber        = [dic[@"totalSale"] integerValue];
        self.useExplain         = dic[@"useExplain"];
    }
    return self;
}

@end
