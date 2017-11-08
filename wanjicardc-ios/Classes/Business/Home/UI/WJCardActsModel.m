//
//  WJCardActsModel.m
//  WanJiCard
//
//  Created by silinman on 16/7/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCardActsModel.h"

@implementation WJCardActsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.actName         = kTrueString(dic[@"actName"]);
        self.Id              = kTrueString(dic[@"id"]);
    }
    return self;
}

@end
