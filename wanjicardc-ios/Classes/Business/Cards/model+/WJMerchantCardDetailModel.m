//
//  WJMerchantCardDetailModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMerchantCardDetailModel.h"

@implementation WJMerchantCardDetailModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        //分享
        self.shareInfoDic = dic[@"ShareInfo"];
        
        //商家branch
        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *storeDic in dic[@"branch"]) {
            WJStoreModel *store = [[WJStoreModel alloc] initWithDic:storeDic];
            [results addObject:store];
        }
        self.supportStoreArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
        
        //branch数量
        self.supportStoreNum = [dic[@"branchNum"] integerValue];
        
        //cardList
        for (NSDictionary *storeDic in dic[@"cardList"]) {
            WJCardModel *store = [[WJCardModel alloc] initWithDic:storeDic];
            [results addObject:store];
        }
        self.cardArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];

        //商家
        self.mainMerId = ToString(dic[@"mainMerchantId"]);
        self.merId = ToString(dic[@"merchantId"]);
        self.merName = dic[@"merchantName"];
        self.isMyCard = [dic[@"isMyCard"] integerValue];
    }
    
    return self;
}

@end
