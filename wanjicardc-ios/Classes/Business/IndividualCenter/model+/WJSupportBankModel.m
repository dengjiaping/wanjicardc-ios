//
//  WJSupportBankModel.m
//  WanJiCard
//
//  Created by reborn on 16/9/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSupportBankModel.h"

@implementation WJSupportBankModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.bankId    = ToString(dic[@"id"]);
        self.logoImage = ToString(dic[@"logoImg"]);
        self.name      = ToString(dic[@"name"]) ;

    }
    return self;
}
@end
