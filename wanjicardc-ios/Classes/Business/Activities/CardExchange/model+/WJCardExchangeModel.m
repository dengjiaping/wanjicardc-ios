//
//  WJCardExchangeModel.m
//  WanJiCard
//
//  Created by XT Xiong on 2016/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardExchangeModel.h"

@implementation WJCardExchangeModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.cardLogolUrl = ToString(dic[@"logoUrl"]);
        self.cardName = ToString(dic[@"newCardName"]);
        self.cardColorValue = ToString(dic[@"cardColorValue"]);
        self.thirdCardSortId = ToString(dic[@"thirdCardSortId"]);
        self.cardId = ToString(dic[@"id"]);

    }
    return self;
}
@end
