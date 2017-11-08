//
//  WJBunsTransRecordModel.m
//  WanJiCard
//
//  Created by silinman on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBunsTransRecordModel.h"

@implementation WJBunsTransRecordModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.days               = ToString(dic[@"days"]);
        self.bun                = ToString(dic[@"bun"]);
        self.typeStr            = ToString(dic[@"typeStr"]);
        self.git                = ToString(dic[@"git"]);
        self.type               = ToString(dic[@"type"]);
        self.order_no           = ToString(dic[@"orderNo"]);
        self.dayStr             = ToString(dic[@"dayStr"]);
    }
    return self;
}


@end
