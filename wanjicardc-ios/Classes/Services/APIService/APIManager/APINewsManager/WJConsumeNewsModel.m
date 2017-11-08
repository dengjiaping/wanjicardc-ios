//
//  WJConsumeNewsModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJConsumeNewsModel.h"

@implementation WJConsumeNewsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.money             = kTrueString(dic[@"money"]);
        self.reqParam          = kTrueString(dic[@"reqParam"]);
        self.type              = kTrueString(dic[@"type"]);
        self.date              = kTrueString(dic[@"date"]);
        self.time              = kTrueString(dic[@"time"]);
    }
    return self;
}

@end
