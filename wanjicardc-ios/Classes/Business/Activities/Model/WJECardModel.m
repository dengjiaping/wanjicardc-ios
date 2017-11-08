//
//  WJECardModel.m
//  WanJiCard
//
//  Created by silinman on 16/8/18.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJECardModel.h"

@implementation WJECardModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.cardId             = ToString(dic[@"id"]);
        self.cardColor          = [dic[@"cardColor"] integerValue];
        self.faceValue          = ToString(dic[@"faceUrl"]);
        self.facePrice          = ToString(dic[@"facePrice"]);
        self.stock              = ToString(dic[@"stock"]);
        self.expiryDate         = ToString(dic[@"expiryDate"]);
        self.cardDes            = ToString(dic[@"ad"]);
        self.logoUrl            = ToString(dic[@"logoUrl"]);
        self.salePrice          = ToString(dic[@"salePrice"]);
        self.commodityName      = ToString(dic[@"commodityName"]);
        self.soldCount          = ToString(dic[@"soldCount"]);
        self.limitCount         = [dic[@"limitCount"] integerValue];
        self.activityType       = [dic[@"activityType"] integerValue];
        self.allowBuyCount      = [dic[@"allowBuyCount"] integerValue];
        self.cardColorValue     = ToString(dic[@"cardColorValue"]);
        self.salePriceRmb       = ToString(dic[@"salePriceRmb"]);
    }
    return self;
}


@end
