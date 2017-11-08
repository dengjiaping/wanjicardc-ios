//
//  WJRecommendStroeReformer.m
//  WanJiCard
//
//  Created by Lynn on 15/9/16.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJRecommendStoreReformer.h"
#import "WJRecommendStoreModel.h"

@implementation WJRecommendStoreReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * result = [NSMutableArray array];
    if ([data[@"branch"] isKindOfClass:[NSArray class]]) {
        for (id obj in [data objectForKey:@"branch"]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                WJRecommendStoreModel * recommend = [[WJRecommendStoreModel alloc] initWithDic:obj];
                [result addObject:recommend];
            }
        }
    }
    return result;
}


@end
