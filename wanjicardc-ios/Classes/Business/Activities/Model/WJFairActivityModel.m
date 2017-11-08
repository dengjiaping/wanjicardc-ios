//
//  WJFairActivityModel.m
//  WanJiCard
//
//  Created by silinman on 16/8/23.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFairActivityModel.h"

@implementation WJFairActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.linkUrl            = ToString(dic[@"linkUrl"]);
        self.name               = ToString(dic[@"name"]);
        self.state              = ToString(dic[@"state"]);
        self.pcUrl              = ToString(dic[@"pcUrl"]);
    }
    return self;
}


@end
