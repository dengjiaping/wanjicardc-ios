//
//  HotKeysModel.m
//  WanJiCard
//
//  Created by Lynn on 15/9/23.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJHotKeysModel.h"

@implementation WJHotKeysModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.countNum = [NSString stringWithFormat:@"%@",dic[@"Count"]];
        self.name = ToString(dic[@"hotwordsName"]);
    }
    return self;
}

@end
