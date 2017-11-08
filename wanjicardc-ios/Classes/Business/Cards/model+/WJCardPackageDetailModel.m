//
//  WJCardPackageDetailModel.m
//  WanJiCard
//
//  Created by Angie on 15/10/13.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJCardPackageDetailModel.h"
#import "WJStoreModel.h"
#import "WJConsumeModel.h"
#import "WJPrivilegeModel.h"


@implementation WJCardPackageDetailModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.merId = ToString(dic[@"merchantId"]);
        self.mainMerId = ToString(dic[@"mainMerchantId"]);
        self.cardCoverUrl = dic[@"cardLogo"];
        self.balance = [dic[@"balance"] floatValue];
        self.faceValue = [dic[@"faceValue"] floatValue];
        self.name = dic[@"cardName"];
        self.introduce = dic[@"introduce"];
        self.cType = (CardBgType)[dic[@"cardColor"] integerValue];
        self.supportStoreNum = [dic[@"branchNum"] integerValue];
        self.adString = ToString(dic[@"ad"]);
        self.shareInfoDic = dic[@"ShareInfo"];
        self.merName = dic[@"merchantName"];
        self.useExplain = dic[@"useExplain"];
        
        
        self.cardId = ToString(dic[@"cardId"]);
        self.isLimitForSale = [dic[@"isLimitForSale"] boolValue];
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
        
//        self.consumeCount = [dic[@"ConsumeCount"] integerValue];
//        for (NSDictionary *consumeDic in dic[@"Consumes"]) {
//            WJConsumeModel *consume = [[WJConsumeModel alloc] initWithDic:consumeDic];
//            [results addObject:consume];
//        }
//        self.consumeArray = [NSArray arrayWithArray:results];
//        [results removeAllObjects];

    }
    
    return self;
}


@end
