//
//  WJSearchConditionReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJSearchConditionReformer.h"
#import "WJSearchConditionModel.h"

@implementation WJSearchConditionReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"KeyOrder"] isKindOfClass:[NSArray class]]) {
        for (id obj in data[@"KeyOrder"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJSearchConditionModel * searchCondition = [[WJSearchConditionModel alloc] initWithDic:obj];
                [result addObject:searchCondition];
            }
        }
    }
    return result;
}
@end
