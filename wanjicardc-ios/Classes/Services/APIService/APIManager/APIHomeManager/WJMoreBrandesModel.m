//
//  WJMoreBrandesModel.m
//  WanJiCard
//
//  Created by XT Xiong on 16/6/2.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMoreBrandesModel.h"

@implementation WJMoreBrandesModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.brandPhotoUrl          = kTrueString(dic[@"brandPhotoUrl"]);
        self.hotNum                 = kTrueString(dic[@"hotNum"]);
        self.logoUrl                = kTrueString(dic[@"logoUrl"]);
        self.name                   = kTrueString(dic[@"name"]);
        self.merchantAccountId      = ToString(dic[@"merchantAccountId"]);
        self.merchantBranchId      = ToString(dic[@"merchantBranchId"]);
        self.brandType              = [dic[@"type"] integerValue];
        self.color                  = kTrueString(dic[@"colour"]);
        
    }
    return self;
}

@end
