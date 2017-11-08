//
//  WJNewsCenterModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/7/5.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJNewsCenterModel.h"

@implementation WJNewsCenterModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.isRead              = kTrueString(dic[@"isRead"]);
        self.reqParam            = kTrueString(dic[@"reqParam"]);
        self.type                = kTrueString(dic[@"type"]);
        self.money               = kTrueString(dic[@"money"]);
    }
    return self;
}
@end
