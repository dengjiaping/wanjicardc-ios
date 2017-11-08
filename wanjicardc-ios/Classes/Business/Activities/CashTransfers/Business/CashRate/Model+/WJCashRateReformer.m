//
//  WJCashRateReformer.m
//  WanJiCard
//
//  Created by reborn on 16/11/25.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJCashRateReformer.h"
#import "WJCashRateModel.h"
@implementation WJCashRateReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"result"] isKindOfClass:[NSArray class]]) {
        for (id obj in data[@"result"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                WJCashRateModel * cashRateModel = [[WJCashRateModel alloc] initWithDic:obj];
                [result addObject:cashRateModel];
            }
        }
    }
    return result;
}
@end
