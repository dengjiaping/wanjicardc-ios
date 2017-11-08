//
//  WJSearchConditionModel.m
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSearchConditionModel.h"

@implementation WJSearchConditionModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.keyStr = dic[@"key"];
        self.name   = dic[@"value"];
    }
    return self;
}

@end
