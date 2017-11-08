//
//  WJHomePageTopModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJHomePageTopModel.h"


@implementation WJHomePageTopModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.merchantBusinesshours = kTrueString(dic[@"merchantBusinesshours"]);
        self.merchantPhone = kTrueString(dic[@"merchantPhone"]);
        self.merchantLinkman = kTrueString(dic[@"merchantLinkman"]);
        self.merchantName = kTrueString(dic[@"merchantName"]);
        self.merchantIntroduce = kTrueString(dic[@"merchantIntroduce"]);
        self.merchantLatitude = kTrueString(dic[@"merchantLatitude"]);
        self.merchantLongitude = kTrueString(dic[@"merchantLongitude"]);
        self.merchantAddress = kTrueString(dic[@"merchantAddress"]);
        self.merchantId = kTrueString(dic[@"merchantId"]);
        self.merchantStatus = kTrueString(dic[@"merchantStatus"]);
    }
    return self;
}

@end
