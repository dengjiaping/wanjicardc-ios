//
//  WJCardDetailModel.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCardDetailModel.h"
#import "WJStoreModel.h"
#import "WJConsumeModel.h"
#import "WJPrivilegeModel.h"


@implementation WJCardDetailModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.cardId = ToString(dic[@"cardId"]);
        self.name = ToString(dic[@"cardName"]);
        self.faceValue = [dic[@"faceValue"] floatValue];
        self.cardCoverUrl = dic[@"cardLogo"];
        self.salePrice = [dic[@"saleValue"] floatValue];
        self.saledNumber = [dic[@"totalSale"] integerValue];
        self.adString = dic[@"ad"];
        self.cType = (CardBgType)[dic[@"cardColor"] integerValue];
        self.supportStoreNum = [dic[@"branchNum"] integerValue];
        self.cardIntroduce = dic[@"introduce"];
        self.merId = ToString(dic[@"merchantId"]);
        self.mainMerId = ToString(dic[@"mainMerchantId"]);
        self.merName = dic[@"merchantName"];
        self.shareInfoDic = dic[@"ShareInfo"];
        self.useExplain = dic[@"useExplain"];
        self.isLimitForSale = [dic[@"isLimitForSale"] boolValue];
        self.activityId = ToString(dic[@"activityId"]);
        
        self.price = [dic[@"price"] floatValue];
        
        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *storeDic in dic[@"branch"]) {
            WJStoreModel *store = [[WJStoreModel alloc] initWithDic:storeDic];
            [results addObject:store];
        }
        self.supportStoreArray = [NSArray arrayWithArray:results];

        
        [results removeAllObjects];
        for (NSDictionary *preivilegeDic in dic[@"privilege"]) {
            WJPrivilegeModel *preivilege = [[WJPrivilegeModel alloc] initWithDic:preivilegeDic];
            [results addObject:preivilege];
        }
        self.privilegeArray = [NSArray arrayWithArray:results];
        
        
        
        self.promotion = dic[@"Promotion"];
        self.merRule = dic[@"Rule"];

    }
    
    return self;
}


@end
