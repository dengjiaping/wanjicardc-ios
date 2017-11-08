//
//  WJMyBunsRecordModel.m
//  WanJiCard
//
//  Created by silinman on 16/8/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMyBunsRecordModel.h"
#import "WJBunsTransRecordModel.h"

@implementation WJMyBunsRecordModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.total                  = ToString(dic[@"total"]);
        self.walletCount            = ToString(dic[@"walletCount"]);
        self.totalPage              = [dic[@"totalPage"] integerValue];
        self.recharge               = [dic[@"ifRecharge"] boolValue];
        NSMutableArray *results = [NSMutableArray array];
        for (NSDictionary *cardsDic in dic[@"result"]) {
            WJBunsTransRecordModel *cards = [[WJBunsTransRecordModel alloc] initWithDictionary:cardsDic];
            [results addObject:cards];
        }
        self.recordsArray = [NSArray arrayWithArray:results];
        [results removeAllObjects];
    }
    return self;
}

@end
