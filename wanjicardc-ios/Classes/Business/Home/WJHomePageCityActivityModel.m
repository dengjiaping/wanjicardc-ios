//
//  WJHomePageCityActivityModel.m
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageCityActivityModel.h"

@implementation WJHomePageCityActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.category           = kTrueString(dic[@"category"]);
        self.Id                 = kTrueString(dic[@"id"]);
        self.img                = kTrueString(dic[@"img"]);
        self.url                = ToString(dic[@"url"]);
        self.type               = kTrueString(dic[@"type"]);
        self.merchantName       = kTrueString(dic[@"merchantName"]);
        self.brandName          = kTrueString(dic[@"brandName"]);
        self.merchantAccountId  = ToString(dic[@"merchantAccountId"]);
        self.merchantId         = ToString(dic[@"merchantId"]);
        self.isLogin            = ToString(dic[@"isLogin"]);
        
        self.merchantBranchId      = ToString(dic[@"merchantBranchId"]);


    }
    return self;
}

@end
