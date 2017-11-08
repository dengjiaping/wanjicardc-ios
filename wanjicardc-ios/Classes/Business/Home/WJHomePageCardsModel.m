//
//  WJHomePageCardsModel.m
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageCardsModel.h"

@implementation WJHomePageCardsModel


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.ad                 = kTrueString(dic[@"ad"]);
        self.balance            = kTrueString(dic[@"balance"]);
        self.cardColor          = kTrueString(dic[@"cardColor"]);
        self.cardId             = ToString(dic[@"cardId"]);
        self.cardLogo           = kTrueString(dic[@"cardLogo"]);
        self.cardName           = kTrueString(dic[@"cardName"]);
        self.faceValue          = ToString(dic[@"faceValue"]);
        self.introduce          = kTrueString(dic[@"introduce"]);
        self.isLimitForSale     = ToString(dic[@"limitForSale"]);
        self.merchantCardStatus = kTrueString(dic[@"merchantCardStatus"]);
        self.merchantId         = ToString(dic[@"merchantId"]);
        self.merchantName       = kTrueString(dic[@"merchantName"]);
        self.price              = ToString(dic[@"price"]);
        self.salePercent        = kTrueString(dic[@"salePercent"]);
        self.saleValue          = ToString(dic[@"saleValue"]);
        self.totalSale          = kTrueString(dic[@"totalSale"]);
        self.useExplain         = kTrueString(dic[@"useExplain"]);
        self.privailegeNum      = ToString(dic[@"privailegeNum"]);
        
        self.actsArray          = [NSArray arrayWithArray:dic[@"acts"]];
    }
    return self;
}

@end
