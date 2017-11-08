//
//  WJCityModel.m
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJCityModel.h"

@implementation WJCityModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.cityName = dic[@"Name"];
        self.cityId = [NSString stringWithFormat:@"%@",dic[@"Id"]];
    }
    return self;
}

@end
