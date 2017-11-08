//
//  WJCashRateModel.m
//  WanJiCard
//
//  Created by reborn on 16/11/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashRateModel.h"

@implementation WJCashRateModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.rateFast  = ToString([dic[@"type_0"] objectForKey:@"rate"]);
        self.rateNormal = ToString([dic[@"type_1"] objectForKey:@"rate"]);
        
        self.settleFast = ToString([dic[@"type_0"] objectForKey:@"charge"]);
        self.settleNormal = ToString([dic[@"type_1"] objectForKey:@"charge"]);
        
        self.quotaFast =  ToString([dic[@"type_0"] objectForKey:@"limits"]);
        self.quotaNormal = ToString([dic[@"type_1"] objectForKey:@"limits"]);
        
        self.idFast =  ToString([dic[@"type_0"] objectForKey:@"id"]);
        self.idNormal = ToString([dic[@"type_1"] objectForKey:@"id"]);
        
        self.channelName = ToString(dic[@"channelName"]);
        self.tipCopy = ToString(dic[@"tipCopy"]);
        self.imageUrl = ToString(dic[@"url"]);

    }
    return self;
}
@end
