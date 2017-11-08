//
//  WJHomePageActivitiesModel.m
//  WanJiCard
//
//  Created by silinman on 16/6/3.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageActivitiesModel.h"

@implementation WJHomePageActivitiesModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.activityName       = kTrueString(dic[@"activityName"]);
        self.activityType       = kTrueString(dic[@"type"]);
        self.imagePosition      = kTrueString(dic[@"imagePosition"]);
        self.img                = kTrueString(dic[@"img"]);
        self.url                = ToString(dic[@"url"]);
        self.merchantName       = kTrueString(dic[@"merchantName"]);
        self.brandName          = kTrueString(dic[@"brandName"]);
        self.merchantAccountId  = ToString(dic[@"merchantAccountId"]);
        self.merchantId         = ToString(dic[@"merchantId"]);
        self.isLogin            = ToString(dic[@"isLogin"]);

    }
    return self;
}

@end
