//
//  WJMerchantListReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJMerchantListReformer.h"
#import "WJRecommendStoreModel.h"

@implementation WJMerchantListReformer
- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (id obj in data) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJRecommendStoreModel * recommend = [[WJRecommendStoreModel alloc] initWithDic:obj];
                [result addObject:recommend];
            }
        }
    }
    return result;
}

@end
